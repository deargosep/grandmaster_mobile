import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart' as d;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Directory> _prepareSaveDir() async {
  String _localPath = (await _getSavedDir())!;
  final savedDir = Directory(_localPath);
  if (!savedDir.existsSync()) {
    await savedDir.create();
  }
  return savedDir;
}

Future<void> _retryRequestPermission() async {
  final hasGranted = await _checkPermission();

  if (hasGranted) {
    await _prepareSaveDir();
  }
}

Future<void> _requestDownload(TaskInfo task) async {
  Directory savedDir = (await _prepareSaveDir());
  task.taskId = await d.FlutterDownloader.enqueue(
    url: task.link!,
    savedDir: savedDir.absolute.path,
    // saveInPublicStorage: _saveInPublicStorage,
  );

  d.FlutterDownloader.open(taskId: task.taskId!);
}

Future<bool> _checkPermission() async {
  if (Platform.isIOS) {
    return true;
  }

  if (Platform.isAndroid) {
    // final info = await DeviceInfoPlugin().androidInfo;
    // if (info.version.sdkInt > 28) {
    //   return true;
    // }

    final status = await Permission.storage.status;
    if (status == PermissionStatus.granted) {
      return true;
    }

    final result = await Permission.storage.request();
    return result == PermissionStatus.granted;
  }

  throw StateError('unknown platform');
}

Future<String?> _getSavedDir() async {
  String? externalStorageDirPath;

  if (Platform.isAndroid) {
    try {
      externalStorageDirPath = await AndroidPathProvider.downloadsPath;
    } catch (err, st) {
      print('failed to get downloads path: $err, $st');

      final directory = await getExternalStorageDirectory();
      externalStorageDirPath = directory?.path;
    }
  } else if (Platform.isIOS) {
    externalStorageDirPath =
        (await getApplicationDocumentsDirectory()).absolute.path;
  }
  return externalStorageDirPath;
}

Future<void> _retryDownload(TaskInfo task) async {
  final newTaskId = await d.FlutterDownloader.retry(taskId: task.taskId!);
  task.taskId = newTaskId;
}

@pragma('vm:entry-point')
void downloadCallback(
  String id,
  d.DownloadTaskStatus status,
  int progress,
) {
  print(
    'Callback on background isolate: '
    'task ($id) is in status ($status) and process ($progress)',
  );

  IsolateNameServer.lookupPortByName('downloader_send_port')
      ?.send([id, status, progress]);
}

void _bindBackgroundIsolate() {
  final ReceivePort _port = ReceivePort();

  final isSuccess = IsolateNameServer.registerPortWithName(
    _port.sendPort,
    'downloader_send_port',
  );
  if (!isSuccess) {
    _unbindBackgroundIsolate();
    _bindBackgroundIsolate();
    return;
  }
  _port.listen((dynamic data) {
    final taskId = (data as List<dynamic>)[0] as String;
    final status = data[1] as d.DownloadTaskStatus;
    final progress = data[2] as int;

    print(
      'Callback on UI isolate: '
      'task ($taskId) is in status ($status) and process ($progress)',
    );
  });
}

void _unbindBackgroundIsolate() {
  IsolateNameServer.removePortNameMapping('downloader_send_port');
}

void download(String url) async {
  if (kIsWeb) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    _bindBackgroundIsolate();

    d.FlutterDownloader.registerCallback(downloadCallback, step: 1);
    _requestDownload(TaskInfo(link: url));
  }
}

class TaskInfo {
  TaskInfo({this.name, this.link});

  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
}
