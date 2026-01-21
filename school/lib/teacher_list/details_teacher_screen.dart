import 'package:flutter/material.dart';
import '../app_color.dart';

class TeacherDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> teacher;

  const TeacherDetailsScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Modern light background
      appBar: AppBar(
        title: const Text("Profile Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600 , color: Colors.white, letterSpacing: 1.2), ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700), // Max Width Set
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [

                SizedBox(height: 50,),
                // ================= PROFILE HEADER =================
                _buildHeader(),

                const SizedBox(height: 25),

                // ================= QUICK ACTIONS =================
                _buildQuickActions(),

                const SizedBox(height: 25),

                // ================= INFO SECTION =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Professional Information",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),
                        _infoTile(Icons.auto_stories_outlined, "Department / Subject", teacher["subject"]),
                        _infoTile(Icons.alternate_email_rounded, "Official Email", "${teacher["name"].toLowerCase().replaceAll(' ', '.')}@school.edu.bd"),
                        _infoTile(Icons.verified_user_outlined, "Employee ID", "TS-${teacher["id"] ?? '2026-042'}"),
                        _infoTile(Icons.history_toggle_off_rounded, "Experience", "6+ Years Experience"),
                        _infoTile(Icons.location_on_outlined, "Residential Address", "Tatulbaria, Gangni, Meherpur"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // প্রফেশনাল হেডার ডিজাইন
  Widget _buildHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
              ),
            ),
            Hero(
              tag: teacher["name"], // Animation tag
              child: CircleAvatar(
                radius: 52,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(teacher["image"]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          teacher["name"],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        const SizedBox(height: 5),
        Text(
          teacher["designation"].toUpperCase(),
          style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600, letterSpacing: 1.2),
        ),
      ],
    );
  }

  // কুইক অ্যাকশন বাটন (Call, Message, Email)
  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _actionButton(Icons.call_rounded, "Call", Colors.green),
        const SizedBox(width: 20),
        _actionButton(Icons.chat_bubble_outline_rounded, "Chat", AppColors.primary),
        const SizedBox(width: 20),
        _actionButton(Icons.share_outlined, "Share", Colors.orange),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: Colors.black54),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





/*
import 'package:flutter/material.dart';
import '../app_color.dart';

class TeacherDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> teacher;

  const TeacherDetailsScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(teacher["name"]),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // প্রোফাইল হেডার
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 56,
                      backgroundImage: NetworkImage(teacher["image"]),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    teacher["name"],
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    teacher["designation"],
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // কন্টাক্ট এবং অন্যান্য ডিটেইলস
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _infoTile(Icons.book, "Subject", teacher["subject"]),
                  _infoTile(Icons.phone, "Mobile", teacher["phone"]),
                  _infoTile(Icons.email, "Email", "${teacher["name"].toLowerCase().replaceAll(' ', '.')}@school.com"),
                  _infoTile(Icons.location_on, "Address", "Tatulbaria, Gangni, Meherpur"),
                  _infoTile(Icons.calendar_month, "Joined At", "January 2020"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}*/
