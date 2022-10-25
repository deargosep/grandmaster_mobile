import 'dart:math' show Random;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData, Response;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isValidContactType(contact_type) {
  print(contact_type);
  switch (contact_type) {
    case '1':
      return true;
    case 'PARTNER':
      return true;
    case 'PARENT':
      return true;
    case 'CLIENT':
      return true;
    default:
      showErrorSnackbar(
          'Произошла ошибка с учетной записью. Обратитесь в поддержку');
      return false;
  }
}

void showErrorSnackbar(String message) {
  Get.snackbar('Ошибка', '',
      messageText: Text(
        message.toString(),
        maxLines: 2,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      colorText: Colors.white);
}

Dio createDio(
    {Function(DioError, ErrorInterceptorHandler)? errHandler,
    showSnackbar = true}) {
  Dio dio = Dio(BaseOptions(baseUrl: "https://app.grandmaster.club/api"));
  dio.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options, handler) async {
    SharedPreferences.getInstance().then((value) {
      if (value.getString('access') != null) {
        options.headers.addAll({
          "Authorization": "Bearer ${value.getString('access')}",
        });
      }
    });
    print('${options.method} ${options.path}   ${options.data}');
    if (!options.path.endsWith('/') && !options.path.contains('?'))
      handler.reject(DioError(requestOptions: options, error: 'Add /'));
    return handler.next(options);
  }, onError: (error, handler) {
    try {
      if (showSnackbar) {
        if (error.response?.statusCode != 500) {
          if (error.response?.data != null) {
            print(
                'dio error: ${error.error}, WHY?: ${error.response?.data ?? error.message}');
            showErrorSnackbar(error.response?.data != ''
                ? error.response!.data["details"]
                : error.message);
          } else {
            print('dio error: ${error.error}, WHY?: ${error.message}');
            showErrorSnackbar(error.message);
          }
        } else {
          print('dio error: 500');
          showErrorSnackbar('Ошибка сервера. Попробуйте позднее');
        }
      }
    } catch (e) {
      print(e);
    }
    if (errHandler != null) errHandler(error, handler);
  }));
  return dio;
}

Future<FormData> getFormFromFile(file, String photoKey, Map data) async {
  String fileName = file.path.split('/').last;
  FormData formData = FormData.fromMap({
    ...data,
    photoKey: !kIsWeb
        ? await MultipartFile.fromFile(file.path)
        : await MultipartFile.fromBytes(file.readAsBytesSync(),
            filename: file.name.substring((int.parse(file!.name.length! - 8))))
  });
  return formData;
}

Future<FormData> getFormFromXFile(XFile file, String photoKey, Map data) async {
  FormData formData = FormData.fromMap({
    ...data,
    photoKey: await MultipartFile.fromBytes(await file.readAsBytes(),
        filename: file.name)
  });
  return formData;
}

// Future<FormData> getFormFromFileArticle(
//     List<MyFile> files, String photoKey, Map data) async {
//   Iterable<MapEntry> listOfEntriesWithFiles = files.map((e) async {
//     String fileName = e.file!.path.split('/').last;
//     return MapEntry(
//         e.id,
//         e.isModified
//             ? await MultipartFile.fromFile(e.file!.path, filename: fileName)
//             : '');
//   });
//   Map<String, dynamic> map = {...data};
//   map.addEntries(listOfEntriesWithFiles);
//   FormData formData = FormData.fromMap(map);
//   return formData;
// }

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
