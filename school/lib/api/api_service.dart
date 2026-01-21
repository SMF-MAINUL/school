import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';





class ApiService {
  final String baseUrl = 'https://aihcompany.threestarambulance.com/bastoobshop/';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> register({
    required String fullname,
    required String mobile,
    required String username,
    required String phone,
    required String email,
    required String dob,
    required String password,
    required String fcmToken,
    File? profileImage,           // 📱 mobile
    Uint8List? webImageBytes,     // 🌐 web
  }) async {
    final url = Uri.parse('$baseUrl/admin_register.php');
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'fullname': fullname,
      'mobile': mobile,
      'username': username,
      'phone': phone,
      'email': email,
      'dob': dob,
      'password': password,
      'fcm_token': fcmToken,
    });

    // 📱 MOBILE IMAGE
    if (profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_image',
          profileImage.path,
        ),
      );
    }

    // 🌐 WEB IMAGE
    if (webImageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'profile_image',
          webImageBytes as List<int>,
          filename: 'profile.jpg',
          contentType: http.MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamedResponse = await request.send();
    final resp = await http.Response.fromStream(streamedResponse);

    return _handleResponse(resp);
  }

  Future<Map<String, dynamic>> login({
    required String mobile,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/admin_login.php');

    var request = http.MultipartRequest('POST', url);
    request.fields.addAll({'mobile': mobile, 'password': password});

    final streamedResponse = await request.send();
    final resp = await http.Response.fromStream(streamedResponse);

    final data = _handleResponse(resp);




    // Storage এ ডেটা সেভ করা হচ্ছে
/*    if (data['admin_id'] != null && data['admin_full_name'] != null ) {
      await _storage.write(key: 'admin_id', value: data['admin_id'].toString());
      await _storage.write(key: 'admin_full_name', value: data['admin_full_name'].toString());
    }*/


    // ✅ FULL ADMIN OBJECT SAVE
    /*   if (data['admin'] != null) {
      await saveAdminData(data['admin']);
      await _storage.write(
        key: 'admin_id',
        value: data['admin']['id'].toString(),
      );
    }*/



    if (data['admin'] != null) {
      // await saveAdminData(data['admin']);

      await _storage.write(
        key: 'admin_id',
        value: data['admin']['id'].toString(),
      );

      await _storage.write(
        key: 'admin_full_name',
        value: data['admin']['fullname'],
      );
    }


    print("LOGIN RESPONSE: $data");



    return data;
  }

// Storage এ ডেটা সেভ পরবর্তীতে পড়ার জন্য  ফাংশন
  Future<String?> getSavedAdminId() async {
    return await _storage.read(key: 'admin_id');
  }
  Future<String?> getSavedAdminName() async {
    return await _storage.read(key: 'admin_full_name');
  }



  Future<Map<String, dynamic>> getProfileById(String adminId) async {
    final url = Uri.parse('$baseUrl/get_admin.php');

    // আমরা POST মেথডে admin_id পাঠাচ্ছি
    var request = http.MultipartRequest('POST', url);
    request.fields['admin_id'] = adminId;

    final streamedResponse = await request.send();
    final resp = await http.Response.fromStream(streamedResponse);

    return _handleResponse(resp);
  }


  Future<void> saveAdminData(Map<String, dynamic> admin) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('admin_data', jsonEncode(admin));
  }



  Future<void> logout() async {
    final token = await _storage.read(key: 'api_token');
    final url = Uri.parse('$baseUrl/admin_logout.php');
    await http.post(url, headers: {'Authorization': 'Bearer $token'});
    await _storage.delete(key: 'api_token');
  }




  /// DELETE NOTICE
  Future<bool> deleteNotice(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_student_notice.php'),
      body: {'id': id.toString()},
    );
    if (response.statusCode != 200) return false;
    final decoded = jsonDecode(response.body);
    return decoded['success'] == true;
  }

  /// UPDATE NOTICE
  Future<bool> updateNotice({
    required int id,
    required String title,
    required String description,
    required String date,
    required String category,
    File? newFile,
  }) async {
    var uri = Uri.parse('$baseUrl/update_student_notice.php');

    if (newFile == null) {
      final response = await http.post(uri, body: {
        'id': id.toString(),
        'title': title,
        'description': description,
        'notice_date': date,
        'category': category,
      });
      final decoded = jsonDecode(response.body);
      return decoded['success'] == true;
    } else {
      var request = http.MultipartRequest('POST', uri);
      request.fields['id'] = id.toString();
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['notice_date'] = date;
      request.fields['category'] = category;

      var stream = http.ByteStream(Stream.castFrom(newFile.openRead()));
      var length = await newFile.length();
      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: basename(newFile.path),
      );
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final decoded = jsonDecode(response.body);
      return decoded['success'] == true;
    }
  }





  Map<String, dynamic> _handleResponse(http.Response resp) {
    try {
      final decoded = json.decode(utf8.decode(resp.bodyBytes));
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return decoded;
      } else {
        throw ApiException(decoded['error'] ?? 'Request failed');
      }
    } catch (e) {
      throw ApiException(resp.body);
    }
  }



/*  Map<String, dynamic> _handleResponse(http.Response resp) {
    try {
      final decoded = json.decode(utf8.decode(resp.bodyBytes));

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return decoded;
      } else {
        final errorMsg = decoded is Map && decoded['error'] != null
            ? decoded['error'].toString()
            : 'Request failed';
        throw ApiException(errorMsg);
      }
    } catch (_) {
      throw ApiException('Invalid server response');
    }
  }*/

}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

