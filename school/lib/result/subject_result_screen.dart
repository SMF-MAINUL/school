/*import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../app_color.dart';

class SubjectResultScreen extends StatelessWidget {
  final String className;

  SubjectResultScreen({super.key, required this.className});

  // এই ডাটাটি এখন ডাইনামিকালি ক্যালকুলেট হবে
  final List<Map<String, dynamic>> dummySubjects = [
    {"subject": "Bangla 1st", "marks": 85},
    {"subject": "Bangla 2nd", "marks": 78},
    {"subject": "English 1st", "marks": 82},
    {"subject": "English 2nd", "marks": 75},
    {"subject": "Mathematics", "marks": 92},
    {"subject": "Science", "marks": 88},
    {"subject": "BGS", "marks": 80},
    {"subject": "Religion", "marks": 95},
    {"subject": "ICT", "marks": 45}, // Out of 50 logic can be applied
    {"subject": "Agriculture", "marks": 84},
    {"subject": "Physical Ed.", "marks": 90},
    {"subject": "Arts & Crafts", "marks": 82},
  ];

  // গ্রেড ক্যালকুলেশন লজিক
  String _calculateGrade(int marks, String subject) {
    int checkMarks = subject == "ICT" ? marks * 2 : marks; // ICT ৫০ এ হলে ১০০ তে কনভার্ট
    if (checkMarks >= 80) return "A+";
    if (checkMarks >= 70) return "A";
    if (checkMarks >= 60) return "A-";
    if (checkMarks >= 50) return "B";
    if (checkMarks >= 40) return "C";
    if (checkMarks >= 33) return "D";
    return "F";
  }

  // ================= INTERNATIONAL PDF GENERATION =================
  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // ১. অফিসিয়াল হেডার
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("TATULBARIA HIGH SCHOOL",
                        style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                    pw.Text("Official Academic Transcript", style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                    pw.Text("EIIN: 112233 | Established: 19XX", style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: "Verify: tatulbariaschool.edu.bd/verify/ST10021",
                  width: 60,
                  height: 60,
                ),
              ],
            ),
            pw.Divider(thickness: 1.5, color: PdfColors.blue900),
            pw.SizedBox(height: 20),

            // ২. স্টুডেন্ট ইনফো সেকশন
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Student Name: Md. Jamil Hossain", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Class: $className | Section: A"),
                      pw.Text("Student ID: 10021"),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("Examination: Annual Exam 2026"),
                      pw.Text("Date: January 21, 2026"),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 25),

            // ৩. মেইন রেজাল্ট টেবিল
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
              cellHeight: 22,
              headers: <String>['Subject', 'Marks', 'Grade', 'Point'],
              data: dummySubjects.map((item) {
                String grade = _calculateGrade(item['marks'], item['subject']);
                return [
                  item['subject'],
                  item['marks'].toString(),
                  grade,
                  grade == "A+" ? "5.00" : "4.00" // Example point
                ];
              }).toList(),
            ),

            pw.SizedBox(height: 30),

            // ৪. জিপিএ সামারি বক্স
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 200,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(color: PdfColors.grey100),
                child: pw.Column(
                  children: [
                    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                      pw.Text("Total Marks:"), pw.Text("976", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                    ]),
                    pw.Divider(),
                    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                      pw.Text("Grade Point Average:"), pw.Text("5.00", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14))
                    ]),
                  ],
                ),
              ),
            ),

            pw.Spacer(),

            // ৫. সিগনেচার এরিয়া
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _signatureColumn("Class Teacher"),
                _signatureColumn("Exam Controller"),
                _signatureColumn("Headmaster"),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Center(child: pw.Text("Powered by School Management System - 2026", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500))),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Transcript_${className}_2026.pdf',
    );
  }

  static pw.Widget _signatureColumn(String label) {
    return pw.Column(
      children: [
        pw.Container(
          width: 120,
          // বর্ডার দেওয়ার সঠিক নিয়ম decoration ব্যবহার করা
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: PdfColors.black, width: 1),
            ),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    // UI Code remain mostly same as before for the App Screen
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("$className Academic Record", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              _buildSummaryCard(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
                    ),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.primary.withOpacity(0.05)),
                      columns: const [
                        DataColumn(label: Text('Subject')),
                        DataColumn(label: Text('Marks')),
                        DataColumn(label: Text('Grade')),
                      ],
                      rows: dummySubjects.map((data) {
                        String grade = _calculateGrade(data['marks'], data['subject']);
                        return DataRow(cells: [
                          DataCell(Text(data['subject'])),
                          DataCell(Text(data['marks'].toString())),
                          DataCell(_buildGradeBadge(grade)),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              _buildDownloadButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradeBadge(String grade) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getGradeColor(grade).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(grade, style: TextStyle(color: _getGradeColor(grade), fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem("GPA", "5.00"),
          _summaryItem("Total Marks", "976"),
          _summaryItem("Status", "PASSED"),
        ],
      ),
    );
  }

  Widget _summaryItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton.icon(
        onPressed: () => _generatePdf(context),
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text("PRINT OFFICIAL TRANSCRIPT", style: TextStyle(letterSpacing: 1.1, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[900],
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    if (grade == "A+") return Colors.green;
    if (grade == "A" || grade == "A-") return Colors.blue;
    if (grade == "F") return Colors.red;
    return Colors.orange;
  }
}*/







import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../app_color.dart';

class SubjectResultScreen extends StatelessWidget {
  final String className;

  SubjectResultScreen({super.key, required this.className});

  final List<Map<String, dynamic>> dummySubjects = [
    {"subject": "Bangla 1st", "marks": 85, "grade": "A+"},
    {"subject": "Bangla 2nd", "marks": 78, "grade": "A"},
    {"subject": "English 1st", "marks": 82, "grade": "A+"},
    {"subject": "English 2nd", "marks": 75, "grade": "A"},
    {"subject": "Mathematics", "marks": 92, "grade": "A+"},
    {"subject": "Science", "marks": 88, "grade": "A+"},
    {"subject": "BGS", "marks": 80, "grade": "A+"},
    {"subject": "Religion", "marks": 95, "grade": "A+"},
    {"subject": "ICT", "marks": 45, "grade": "A+"},
    {"subject": "Agriculture", "marks": 84, "grade": "A+"},
    {"subject": "Physical Ed.", "marks": 90, "grade": "A+"},
    {"subject": "Arts & Crafts", "marks": 82, "grade": "A+"},
  ];



  // গ্রেড ক্যালকুলেশন লজিক
  String _calculateGrade(int marks, String subject) {
    int checkMarks = subject == "ICT" ? marks * 2 : marks; // ICT ৫০ এ হলে ১০০ তে কনভার্ট
    if (checkMarks >= 80) return "A+";
    if (checkMarks >= 70) return "A";
    if (checkMarks >= 60) return "A-";
    if (checkMarks >= 50) return "B";
    if (checkMarks >= 40) return "C";
    if (checkMarks >= 33) return "D";
    return "F";
  }

  

  // ================= PDF GENERATION LOGIC =================
  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // ১. অফিসিয়াল হেডার
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                // pw.Column(
                //   crossAxisAlignment: pw.CrossAxisAlignment.start,
                //   children: [   
                //     pw.Text("TATULBARIA HIGH SCHOOL",
                //         style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                //     pw.Text("Official Academic Transcript", style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                //     pw.Text("EIIN: 112233 | Established: 19XX", style: const pw.TextStyle(fontSize: 10)),
                //   ],
                // ),

                // ১. অফিসিয়াল হেডার
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                      children: [
                        // আপনার বর্তমান স্কুল টেক্সট কলাম
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("TATULBARIA HIGH SCHOOL",
                                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                            pw.Text("Official Academic Transcript", style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                            pw.Text("EIIN: 112233 | Established: 19XX", style: const pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    
                  ],
                ),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: "Verify: tatulbariaschool.edu.bd/verify/ST10021",
                  width: 60,
                  height: 60,
                ),
              ],
            ),
            pw.Divider(thickness: 1.5, color: PdfColors.blue900),
            pw.SizedBox(height: 20),

            // ২. স্টুডেন্ট ইনফো সেকশন
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Student Name: Md. Jamil Hossain", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Class: $className | Section: A"),
                      pw.Text("Student ID: 10021"),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("Examination: Annual Exam 2026"),
                      pw.Text("Date: January 21, 2026"),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 25),

            // ৩. মেইন রেজাল্ট টেবিল
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
              cellHeight: 22,
              headers: <String>['Subject', 'Marks', 'Grade', 'Point'],
              data: dummySubjects.map((item) {
                String grade = _calculateGrade(item['marks'], item['subject']);
                return [
                  item['subject'],
                  item['marks'].toString(),
                  grade,
                  grade == "A+" ? "5.00" : "4.00" // Example point
                ];
              }).toList(),
            ),

            pw.SizedBox(height: 30),

            // ৪. জিপিএ সামারি বক্স
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 200,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(color: PdfColors.grey100),
                child: pw.Column(
                  children: [
                    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                      pw.Text("Total Marks:"), pw.Text("976", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                    ]),
                    pw.Divider(),
                    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                      pw.Text("Grade Point Average:"), pw.Text("5.00", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14))
                    ]),
                  ],
                ),
              ),
            ),

            pw.Spacer(),

            // ৫. সিগনেচার এরিয়া
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _signatureColumn("Class Teacher"),
                _signatureColumn("Exam Controller"),
                _signatureColumn("Headmaster"),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Center(child: pw.Text("Powered by School Management System - 2026", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500))),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Transcript_${className}_2026.pdf',
    );
  }




  static pw.Widget _signatureColumn(String label) {
    return pw.Column(
      children: [
        pw.Container(
          width: 120,
          // বর্ডার দেওয়ার সঠিক নিয়ম decoration ব্যবহার করা
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: PdfColors.black, width: 1),
            ),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("$className Results", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              _buildSummaryCard(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[200]!),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                    ),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.primary.withOpacity(0.05)),
                      columns: const [
                        DataColumn(label: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Marks', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: dummySubjects.map((data) {
                        return DataRow(cells: [
                          DataCell(Text(data['subject'])),
                          DataCell(Text(data['marks'].toString())),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getGradeColor(data['grade']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                data['grade'],
                                style: TextStyle(color: _getGradeColor(data['grade']), fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              _buildDownloadButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem("GPA", "5.00"),
          _summaryItem("Total Marks", "976"),
          _summaryItem("Status", "Passed"),
        ],
      ),
    );
  }

  Widget _summaryItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: () => _generatePdf(context), // ফাংশন কল করা হয়েছে
          icon: const Icon(Icons.download_for_offline),
          label: const Text("Download Full Result Sheet (PDF)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    if (grade == "A+") return Colors.green;
    if (grade == "A") return Colors.blue;
    return Colors.red;
  }
}










/*
import 'package:flutter/material.dart';
import '../app_color.dart';

class SubjectResultScreen extends StatelessWidget {
  final String className;

  SubjectResultScreen({required this.className});

  // ভবিষ্যতে এই লিস্টটি সার্ভার থেকে আসবে
  final List<Map<String, dynamic>> dummySubjects = [
    {"subject": "Bangla 1st", "marks": 85, "grade": "A+"},
    {"subject": "Bangla 2nd", "marks": 78, "grade": "A"},
    {"subject": "English 1st", "marks": 82, "grade": "A+"},
    {"subject": "English 2nd", "marks": 75, "grade": "A"},
    {"subject": "Mathematics", "marks": 92, "grade": "A+"},
    {"subject": "Science", "marks": 88, "grade": "A+"},
    {"subject": "BGS", "marks": 80, "grade": "A+"},
    {"subject": "Religion", "marks": 95, "grade": "A+"},
    {"subject": "ICT", "marks": 45, "grade": "A+"}, // Marks out of 50
    {"subject": "Agriculture", "marks": 84, "grade": "A+"},
    {"subject": "Physical Ed.", "marks": 90, "grade": "A+"},
    {"subject": "Arts & Crafts", "marks": 82, "grade": "A+"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("$className Results", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              // ================= Result Summary Header =================
              _buildSummaryCard(),

              // ================= Result Table =================
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[200]!),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
                      ],
                    ),
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(AppColors.primary.withOpacity(0.05)),
                      columns: const [
                        DataColumn(label: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Marks', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: dummySubjects.map((data) {
                        return DataRow(cells: [
                          DataCell(Text(data['subject'])),
                          DataCell(Text(data['marks'].toString())),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getGradeColor(data['grade']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                data['grade'],
                                style: TextStyle(color: _getGradeColor(data['grade']), fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // ================= Download Button =================
              _buildDownloadButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem("GPA", "5.00"),
          _summaryItem("Total Marks", "976"),
          _summaryItem("Status", "Passed"),
        ],
      ),
    );
  }

  Widget _summaryItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDownloadButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: () {
            // এখানে PDF ডাউনলোডের ফাংশনালিটি যোগ করবেন
            print("Downloading PDF...");
          },
          icon: const Icon(Icons.download_for_offline),
          label: const Text("Download Full Result Sheet (PDF)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    if (grade == "A+") return Colors.green;
    if (grade == "A") return Colors.blue;
    return Colors.red;
  }
}*/
