import 'dart:convert';

import 'package:projeto_eventos/utils/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_eventos/utils/base_api.dart';

/*
class UserService extends BaseAPI {
  Future<http.Response> getToken(String username, String password) async {
    String body = jsonEncode({
      "username": username,
      "password": password,
    });

    http.Response response = await super.request(
      http.post,
      super.getURL(Endpoints.token, null, null),
      body,
    );

    return response;
  }

  Future<http.Response> getUser() async {
    http.Response response = await super.request(
      http.get,
      super.getURL(Endpoints.user, null, null),
      null,
    );

    return response;
  }
}
*/