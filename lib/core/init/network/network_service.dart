import 'dart:convert';
import 'dart:io';
import 'package:navigationapp/core/base/ibase_model.dart';
import 'package:navigationapp/core/constants/enums/methods_enum.dart';
import 'package:navigationapp/core/init/locale/locale_manager.dart';
/*
class NetworkService {
  static final NetworkService _instance = NetworkService._init();
  static NetworkService get instance => _instance;

  NetworkService._init();

  Future<dynamic> http<T extends IBaseModel>(
    String path,
    IBaseModel model,
    Methods method, {
    String? faceAccesToken,
    Object? body,
    Map<String, dynamic>? queryParameters,
    String? anyDiffUrl,
  }) async {
    var url = Uri.parse("${anyDiffUrl ?? AppConstants.baseURL}$path");

    String accessToken =
        LocaleManager.instance.getString(PreferencesKeys.token) ?? '';

    print("URLS ->> $url");
    print("TOKENm ->> $accessToken");

    var headers = {
      'content-type': 'application/json',
      'Authorization': faceAccesToken != null
          ? 'Bearer $faceAccesToken'
          : 'Bearer $accessToken',
    };

    https.Response? response;
    https.MultipartRequest? requestMultipart;
    https.StreamedResponse? responseMulti;
    switch (method) {
      case Methods.get:
        response = await https.get(url, headers: headers).timeout(
              const Duration(seconds: AppConstants.responseTimeout),
              onTimeout: () => https.Response('Timeout', 408),
            );
        break;
      case Methods.post:
        response = await https
            .post(url, headers: headers, body: jsonEncode(body))
            .timeout(
              const Duration(seconds: AppConstants.responseTimeout),
              onTimeout: () => https.Response('Timeout', 408),
            );
        break;
      case Methods.put:
        response = await https
            .put(url, headers: headers, body: jsonEncode(body))
            .timeout(
              const Duration(seconds: AppConstants.responseTimeout),
              onTimeout: () => https.Response('Timeout', 408),
            );
        break;
      case Methods.delete:
        response = await https
            .delete(url,
                headers: headers, body: body != null ? jsonEncode(body) : null)
            .timeout(
              const Duration(seconds: AppConstants.responseTimeout),
              onTimeout: () => https.Response('Timeout', 408),
            );
        break;
      case Methods.postFormData:
        requestMultipart = https.MultipartRequest('POST', url)
          ..headers.addAll(headers);
        queryParameters!.forEach((key, value) async {
          if (value is File) {
            requestMultipart!.files.add(
              await https.MultipartFile.fromPath(
                key,
                value.path,
              ),
            );
          } else if (value is List<File>) {
            for (var listValue in value) {
              requestMultipart!.files.add(
                await https.MultipartFile.fromPath(
                  key,
                  listValue.path,
                ),
              );
            }
          } else if (value is DateTime) {
            requestMultipart!.fields[key] =
                DateFormat("yyyy-MM-dd").format(value);
          } else {
            requestMultipart!.fields[key] = value.toString();
          }
        });
        responseMulti = await requestMultipart.send();
        break;
      case Methods.patch:
        requestMultipart = https.MultipartRequest('PATCH', url)
          ..headers.addAll(headers);
        queryParameters!.forEach((key, value) async {
          if (value is File) {
            requestMultipart!.files.add(
              await https.MultipartFile.fromPath(
                key,
                value.path,
              ),
            );
          } else if (value is List<File>) {
            for (var listValue in value) {
              requestMultipart!.files.add(
                await https.MultipartFile.fromPath(
                  key,
                  listValue.path,
                ),
              );
            }
          } else {
            requestMultipart!.fields[key] = value.toString();
          }
        });
        responseMulti = await requestMultipart.send();
        break;
      default:
    }

    if (Methods.postFormData == method || Methods.patch == method) {
      if (responseMulti!.statusCode == 200) {
        final responseBody = await responseMulti.stream.bytesToString();
        debugPrint(responseBody);

        return jsonBodyParser<T>(model, responseBody);
      } else {
        Get.offAllNamed(NavigationConstants.connectionError);
      }
    } else {
      if (response!.statusCode == 200) {
        print(response.body);
        return jsonBodyParser<T>(model, response.body);
      } else if (response.statusCode == 401) {
        // TODO logout ve token' ı sil
      } else if (response.statusCode == 408) {
        return Get.offAllNamed(NavigationConstants.connectionError);
      } else {
        // Hata mesajını ekrana göster Get.Snackbar()
        return jsonBodyParser<T>(model, response.body);
      }
    }
  }

  dynamic jsonBodyParser<T>(IBaseModel model, String body) {
    final Map<String, dynamic> jsonBody = jsonDecode(body);
    return model.fromJson(jsonBody);
  }
}
*/