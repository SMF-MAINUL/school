import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../app_color.dart';
import 'view_result_screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ResultSearchScreen(),
  ));
}

class ResultSearchScreen extends StatefulWidget {
  const ResultSearchScreen({super.key});

  @override
  State<ResultSearchScreen> createState() => _ResultSearchScreenState();
}

class _ResultSearchScreenState extends State<ResultSearchScreen> {
  final classController = TextEditingController();
  final yearController = TextEditingController();
  final rollController = TextEditingController();

  Map<String, dynamic>? resultData;
  bool loading = false;

  void fetchResult() async {
    setState(() {
      loading = true;
      resultData = null;
    });

    String classVal = classController.text.trim();
    String yearVal = yearController.text.trim();
    String rollVal = rollController.text.trim();

    var url = Uri.parse(
        'http://YOUR_SERVER/get_result.php?class=$classVal&year=$yearVal&roll=$rollVal');

    try {
      var response = await http.get(url);
      var data = json.decode(response.body);
      setState(() {
        resultData = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        title: const Text(
          'Student Result',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [


                      const SizedBox(height: 10),
                      _buildInputField(
                        label: 'Year',
                        controller: yearController,
                        keyboardType: TextInputType.number,
                        icon: Icons.calendar_today,
                      ),

                      const SizedBox(height: 12),
                      _buildInputField(
                        label: 'Class',
                        controller: classController,
                        icon: Icons.class_,
                      ),

                      const SizedBox(height: 12),
                      _buildInputField(
                        label: 'Roll',
                        controller: rollController,
                        keyboardType: TextInputType.number,
                        icon: Icons.confirmation_number,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewResultScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Get Result',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      resultData != null
                          ? ResultDisplay(data: resultData!)
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (loading)
            Container(
              color: Colors.black38,
              child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  )),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    IconData icon = Icons.edit,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Icon(icon, color: Colors.blueGrey),
      ),
    );
  }
}

class ResultDisplay extends StatelessWidget {
  final Map<String, dynamic> data;
  const ResultDisplay({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.containsKey('error')) {
      return Card(
        elevation: 3,
        color: Colors.red[50],
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            data['error'],
            style:
            const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    var student = data['student'];
    var results = data['results'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${student['name']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  'Class: ${student['class']}  Year: ${student['year']}  Roll: ${student['roll']}',
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: results.length,
          itemBuilder: (context, index) {
            var r = results[index];
            Color color = r['marks'] >= 80
                ? Colors.green
                : r['marks'] >= 60
                ? Colors.orange
                : Colors.red;

            IconData icon;
            if (r['marks'] >= 80) {
              icon = Icons.emoji_events; // Gold star for excellent
            } else if (r['marks'] >= 60) {
              icon = Icons.thumb_up; // Good
            } else {
              icon = Icons.warning; // Low marks
            }

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Icon(icon, color: color),
                title: Text(r['subject'],
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: Text('${r['marks']}',
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            );
          },
        ),
      ],
    );
  }
}
