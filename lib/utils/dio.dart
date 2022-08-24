import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData, Response;
import 'package:shared_preferences/shared_preferences.dart';

void showErrorSnackbar(String message) {
  Get.snackbar('Ошибка', message,
      backgroundColor: Colors.red, colorText: Colors.white);
}

Dio createDio({Function(DioError)? errHandler}) {
  Dio dio = Dio(BaseOptions(baseUrl: "https://app.grandmaster.center"));
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
    showErrorSnackbar(error.message);
    print('dio error: ${error.error}, WHY?: ${error.response?.data}');
    if (errHandler != null) errHandler(error);
    SharedPreferences.getInstance().then((sp) {
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
      if (error.response?.data["code"] == 'user_inactive') {
        sp.clear();
        Get.offAllNamed('/');
      }
    });
  }));
  return dio;
}

Future<Response> getDataDio(String endpoint) async {
  var response = await createDio().get(endpoint);
  return response;
}

Future<FormData> getFormFromFile(File file, String photoKey, Map data) async {
  String fileName = file.path.split('/').last;
  FormData formData = FormData.fromMap({
    ...data,
    photoKey: await MultipartFile.fromFile(file.path, filename: fileName)
  });
  return formData;
}
