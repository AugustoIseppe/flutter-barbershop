import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

//! IHttpClient -> Interface para o HttpClient
abstract class IHttpClient {
  //----
  Future<http.Response> get({required String url});

  //----
  Future<http.Response> post({
    required String url,
    Map<String, String>? headers,
    dynamic body,
  });

  //----
  Future<http.Response> uploadFile({
    required String url,
    required Map<String, String> fields,
    required File? file,
    required String fileField,
  });

  //----
  Future<http.Response> uploadFilePut({
    required String url,
    required Map<String, String> fields,
    required File? file,
    required String fileField,
  });

  Future<http.Response> updateUserImage({
    required String url,
    File? file,
  });

  Future<http.Response> login({
    required String url,
    required String email,
    required String password,
    required Map<String, dynamic> headers,
  });

  Future<http.Response> put({
    required String url,
    Map<String, String>? headers,
    dynamic body,
  });

  Future<http.Response> updateSlot({
    required String url,
    required Map<String, String> headers,
    required dynamic body,
  });

  Future<http.Response> delete({
    required String url,
  });
  // void close();
}

//! HttpClient -> Implementação da interface IHttpClient
class HttpClient implements IHttpClient {
  final client = http.Client();

  @override
  Future<http.Response> get({required String url}) async {
    return await client.get(Uri.parse(url));
  }

  @override
  Future<http.Response> post({
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final encodedBody = body is String ? body : jsonEncode(body);

    return await client.post(
      Uri.parse(url),
      headers: headers ?? {'Content-Type': 'application/json'},
      body: encodedBody,
    );
  }

  @override
  Future<http.Response> uploadFile({
    required String url,
    required Map<String, String> fields,
    required File? file,
    required String fileField,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields.addAll(fields);

    if (file != null) {
      request.files
          .add(await http.MultipartFile.fromPath(fileField, file.path));
    }

    final response = await request.send();

    return http.Response.fromStream(response);
  }

  @override
  Future<http.Response> uploadFilePut({
    required String url,
    required Map<String, String> fields,
    required File? file,
    required String fileField,
  }) async {
    var request = http.MultipartRequest('PUT', Uri.parse(url))
      ..fields.addAll(fields);

    if (file != null) {
      request.files
          .add(await http.MultipartFile.fromPath(fileField, file.path));
    }

    final response = await request.send();

    return http.Response.fromStream(response);
  }

  @override
  Future<http.Response> login({
    required String url,
    required String email,
    required String password,
    required Map<String, dynamic> headers,
  }) async {
    return await client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  @override
  Future<http.Response> put({
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final encodedBody = body is String ? body : jsonEncode(body);

    return await client.put(
      Uri.parse(url),
      headers: headers ?? {'Content-Type': 'application/json'},
      body: encodedBody,
    );
  }

  @override
  Future<http.Response> delete({required String url}) {
    return client.delete(Uri.parse(url));
  }

  @override
  Future<http.Response> updateUserImage({required String url, File? file}) {
    var request = http.MultipartRequest('PUT', Uri.parse(url))
      ..files.add(http.MultipartFile.fromBytes('image', file!.readAsBytesSync(),
          filename: file.path.split('/').last));

    return request.send().then((response) async {
      return http.Response.fromStream(response);
    });
  }

  @override
  Future<http.Response> updateSlot(
      {required String url,
      required Map<String, String> headers,
      required dynamic body}) {
    return client.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }
}
