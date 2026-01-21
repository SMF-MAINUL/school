import 'package:flutter/material.dart';
import '../app_color.dart';

class AdmissionFormScreen extends StatefulWidget {
  @override
  State<AdmissionFormScreen> createState() => _AdmissionFormScreenState();
}

class _AdmissionFormScreenState extends State<AdmissionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // ড্রপডাউন এর জন্য লিস্ট
  final List<String> classes = ["Class 6", "Class 7", "Class 8", "Class 9", "Class 10"];
  String? selectedClass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Student Admission Form", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ============= ফর্ম হেডার আইকন =============
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.school_rounded, size: 50, color: AppColors.primary),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "New Student Registration",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // ============= ইনপুট কার্ড =============
                  Card(
                    elevation: 4,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("Student Information"),
                          const SizedBox(height: 15),
                          _buildTextField("Full Name", Icons.person_outline),
                          const SizedBox(height: 15),

                          // ক্লাস সিলেক্ট ড্রপডাউন
                          DropdownButtonFormField<String>(
                            decoration: _inputDecoration("Select Class", Icons.class_outlined),
                            items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (val) => setState(() => selectedClass = val),
                          ),

                          const SizedBox(height: 30),
                          _buildSectionTitle("Guardian Information"),
                          const SizedBox(height: 15),
                          _buildTextField("Father's Name", Icons.family_restroom),
                          const SizedBox(height: 15),
                          _buildTextField("Mobile Number", Icons.phone_android, keyboardType: TextInputType.phone),
                          const SizedBox(height: 15),
                          _buildTextField("Email (Optional)", Icons.email_outlined),

                          const SizedBox(height: 30),
                          _buildSectionTitle("Address"),
                          const SizedBox(height: 15),
                          _buildTextField("Present Address", Icons.location_on_outlined, maxLines: 3),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ============= সাবমিট বাটন =============
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Submit logic
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                      ),
                      child: const Text("Submit Application", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // সেকশন টাইটেল ডিজাইন
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  // টেক্সট ফিল্ড মেকার
  Widget _buildTextField(String label, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, icon),
      validator: (value) => value!.isEmpty ? "This field is required" : null,
    );
  }

  // ইনপুট ডেকোরেশন (স্টাইলিশ লুকের জন্য)
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 1.5)),
    );
  }
}