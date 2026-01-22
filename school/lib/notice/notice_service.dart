import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tatulbaria_school_website/notice/student_notice_model.dart';

class NoticeService {
  final String baseUrl;

  NoticeService(this.baseUrl);
/*
  Future<List<StudentNotice>> fetchStudentNotices() async {
    final url = Uri.parse("${baseUrl}get_student_notices.php");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded["success"] == true) {
        final List list = decoded["data"];
        return list.map((e) => StudentNotice.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load notices");
    }
  }*/


  Future<List<StudentNotice>> fetchStudentNotices() async {
    final url = Uri.parse("${baseUrl}get_student_notices.php");

    final response = await http.get(url);

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded["success"] == true) {
        final List list = decoded["data"];
        return list.map((e) => StudentNotice.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load notices");
    }
  }

}
