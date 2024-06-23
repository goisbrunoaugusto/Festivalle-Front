// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:projeto_eventos/utils/endpoints.dart';
// // import 'package:mancon_app/utils/secure_storage.dart';

// class BaseAPI {
//   static String baseURL = const String.fromEnvironment(
//     "MANCON_API_BASE_URL",
//     defaultValue: "",
//   );
//   Map<String, String> headers = {
//     "Content-Type": "application/json",
//   };

//   Uri getURL(String endpointURL, int? id, Map<String, dynamic>? queryParams) {
//     String idLookup = id != null ? "${id.toString()}/" : "";

//     Uri url = Uri.parse(
//       baseURL + endpointURL + idLookup,
//     ).replace(
//       queryParameters: queryParams,
//     );

//     return url;
//   }

//   Future<http.Response> request(Function method, Uri url, String? body) async {
//     http.Response response;

//     if (body != null) {
//       response = await method(url, body: body, headers: headers);
//     } else {
//       response = await method(url, headers: headers);
//     }
//     return response;
//   }

//   void updateAuthorization(String token) {
//     headers["Authorization"] = "Bearer $token";
//   }
// }
