import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../repository/response_model/base/error_response.dart';




class ApiErrorHandler {
  static dynamic getMessage(error) {

    dynamic errorDescription = "";
    if (error is Exception) {

      try {
        if (error is DioException) {
          switch (error.type) {
            case   DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.connectionError:
              errorDescription = "Connection Error with API server";
              break;
            case DioExceptionType.unknown:
              errorDescription =
              "Connection to API server failed due to internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription =
              "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badCertificate:
              errorDescription =
              "Bad Certificate in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 403:
                  print('<==Here is error body==${error.response!.data.toString()}===>');
                  errorDescription = error.response!.data['message'];
                  errorDescription = error.response!.data['errors'][0]['message'];
                  ErrorResponse errorResponse = ErrorResponse.fromJson(error.response!.data);
                  errorDescription = errorResponse.errors![0].message;
                  break;
                case 401:
                  debugPrint(error.response!.statusMessage);
                  errorDescription = error.response!.statusMessage;
                case 404:
                  debugPrint(error.response!.statusMessage);
                  errorDescription = error.response!.statusMessage;
                case 500:
                  debugPrint(error.response!.statusMessage);
                  errorDescription = error.response!.statusMessage;
                case 502:
                  debugPrint(error.response!.statusMessage);
                  errorDescription = error.response!.statusMessage;
                case 503:
                  errorDescription = error.response!.statusMessage;
                  break;
                case 504:
                  errorDescription = error.response!.statusMessage;
                  break;

                default:
                  ErrorResponse errorResponse =
                  ErrorResponse.fromJson(error.response!.data);
                  if (errorResponse.errors != null &&
                      errorResponse.errors!.isNotEmpty) {
                    errorDescription = errorResponse;
                  } else {
                    errorDescription =
                    "Failed to load data - status code: ${error.response!.statusCode}";
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
