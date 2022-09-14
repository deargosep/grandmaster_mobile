import 'dart:math' show Random;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData, Response;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Dio dio = Dio(BaseOptions(baseUrl: "https://app.grandmaster.center/api"));
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
      if (errHandler != null) errHandler(error, handler);
      SharedPreferences.getInstance().then((sp) {
        if (error.response?.data.runtimeType.toString() != 'String') {
          if (error.response?.data.containsKey("code")) {
            if (error.response?.data["code"] == 'token_not_valid') {
              createDio()
                  .post('/auth/token/refresh/',
                      data: {"refresh": sp.getString('refresh')},
                      options: Options(headers: {"Authorization": null}))
                  .then((value) {
                sp.setString('access', value.data["access"]);
                sp.setString('refresh', value.data["refresh"]).then((value) {
                  createDio().get('/users/self/').then((value) {
                    Get.offAllNamed('/bar', arguments: 1);
                  });
                });
              });
            }
          }
          if (error.response?.data["code"] == 'user_inactive') {
            sp.clear();
            Get.offAllNamed('/');
          }
        }
      });
    } catch (e) {}
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
