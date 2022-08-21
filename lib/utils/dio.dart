import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData, Response;
import 'package:shared_preferences/shared_preferences.dart';

void showErrorSnackbar(String message) {
  Get.snackbar('Ошибка', message,
      backgroundColor: Colors.red, colorText: Colors.white);
}

Dio createDio() {
  Dio dio = Dio(BaseOptions(baseUrl: "https://app.grandmaster.center"));
  dio.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options, handler) async {
    SharedPreferences.getInstance().then((value) {
      if (value.getString('access') != null) {
        options.headers.addAll({
          "Authorization": "Bearer ${value.getString('access')}",
          "content-type": "multipart/form-data"
        });
      }
    });
    print('${options.method} ${options.path}   ${options.data}');
    if (!options.path.endsWith('/'))
      handler.reject(DioError(requestOptions: options, error: 'Add /'));
    return handler.next(options);
  }, onError: (error, handler) {
    showErrorSnackbar(error.message);
    print('dio error: ${error.error}');
    // print(error.response?.data!);
  }));
  return dio;
}

Future<Response> getDataDio(String endpoint) async {
  var response = await createDio().get(endpoint);
  return response;
}

Future<String> uploadImage(File file) async {
  String fileName = file.path.split('/').last;
  FormData formData = FormData.fromMap({
    "file": await MultipartFile.fromFile(file.path, filename: fileName),
  });
  var response = await createDio().post("/info", data: formData);
  return response.data['id'];
}

Future<FormData> getFormFromFile(File file) async {
  String fileName = file.path.split('/').last;
  FormData formData = FormData.fromMap(
      {"file": await MultipartFile.fromFile(file.path, filename: fileName)});
  return formData;
}
