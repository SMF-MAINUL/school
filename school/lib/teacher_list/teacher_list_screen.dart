import 'package:flutter/material.dart';
// আপনার সঠিক পাথ অনুযায়ী TeacherDetailsScreen ইমপোর্ট নিশ্চিত করুন
import 'package:tatulbaria_school_website/teacher_list/details_teacher_screen.dart';
import '../app_color.dart';

class TeacherListScreen extends StatefulWidget {
  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  // ডামি টিচার লিস্ট ডাটা
  final List<Map<String, dynamic>> teachers = [
    {
      "name": "Ayesha Siddiqua",
      "designation": "Headmaster",
      "subject": "Mathematics",
      "image": "https://i.pravatar.cc/150?u=1",
      "phone": "017XXXXXXXX"
    },
    {
      "name": "Kamrul Islam",
      "designation": "Assistant Teacher",
      "subject": "Physics",
      "image": "https://i.pravatar.cc/150?u=2",
      "phone": "018XXXXXXXX"
    },
    {
      "name": "Sultana Razia",
      "designation": "Senior Teacher",
      "subject": "English",
      "image": "https://i.pravatar.cc/150?u=3",
      "phone": "019XXXXXXXX"
    },
    {
      "name": "Rafiqul Ahmed",
      "designation": "Assistant Teacher",
      "subject": "Chemistry",
      "image": "https://i.pravatar.cc/150?u=4",
      "phone": "015XXXXXXXX"
    },
    {
      "name": "Kalam Ahmed",
      "designation": "Assistant Teacher",
      "subject": "Chemistry",
      "image": "https://i.pravatar.cc/150?u=5",
      "phone": "015XXXXXXXX"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Our Teachers", style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white, letterSpacing: 1.2)),
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
              // ================= SEARCH BAR =================
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search teacher by name or subject...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                ),
              ),

              // ================= TEACHER LIST =================
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    final teacher = teachers[index];
                    return _buildTeacherCard(teacher);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= ফিক্সড কার্ড ডিজাইন (ক্লিক লজিক সহ) =================
  Widget _buildTeacherCard(Map<String, dynamic> teacher) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // কার্ডে ক্লিক করলে ডিটেইলস স্ক্রিনে নিয়ে যাবে
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherDetailsScreen(teacher: teacher),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // টিচার ইমেজ
              CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: NetworkImage(teacher["image"]),
              ),
              const SizedBox(width: 16),

              // টিচার ডিটেইলস
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher["name"],
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      teacher["designation"],
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    // সাবজেক্ট ট্যাগ
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        teacher["subject"],
                        style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // অ্যাকশন বাটন (কল ও ইমেইল)
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      // কল করার লজিক (URL Launcher দিয়ে করতে পারেন)
                    },
                    icon: const Icon(Icons.call_outlined, color: Colors.green),
                    style: IconButton.styleFrom(backgroundColor: Colors.green.withOpacity(0.1)),
                  ),
                  const SizedBox(height: 4),
                  IconButton(
                    onPressed: () {
                      // ইমেইল করার লজিক
                    },
                    icon: Icon(Icons.email_outlined, color: AppColors.primary),
                    style: IconButton.styleFrom(backgroundColor: AppColors.primary.withOpacity(0.1)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}









/*
import 'package:flutter/material.dart';
import 'package:tatulbaria_school_website/teacher_list/details_teacher_screen.dart';
import '../app_color.dart';

class TeacherListScreen extends StatefulWidget {
  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  // ডামি টিচার লিস্ট ডাটা
  final List<Map<String, dynamic>> teachers = [
    {
      "name": "Ayesha Siddiqua",
      "designation": "Headmaster",
      "subject": "Mathematics",
      "image": "https://i.pravatar.cc/150?u=1",
      "phone": "017XXXXXXXX"
    },
    {
      "name": "Kamrul Islam",
      "designation": "Assistant Teacher",
      "subject": "Physics",
      "image": "https://i.pravatar.cc/150?u=2",
      "phone": "018XXXXXXXX"
    },
    {
      "name": "Sultana Razia",
      "designation": "Senior Teacher",
      "subject": "English",
      "image": "https://i.pravatar.cc/150?u=3",
      "phone": "019XXXXXXXX"
    },
    {
      "name": "Rafiqul Ahmed",
      "designation": "Assistant Teacher",
      "subject": "Chemistry",
      "image": "https://i.pravatar.cc/150?u=4",
      "phone": "015XXXXXXXX"
    },
    {
      "name": "Rafiqul Ahmed",
      "designation": "Assistant Teacher",
      "subject": "Chemistry",
      "image": "https://i.pravatar.cc/150?u=4",
      "phone": "015XXXXXXXX"
    },
    {
      "name": "Rafiqul Ahmed",
      "designation": "Assistant Teacher",
      "subject": "Chemistry",
      "image": "https://i.pravatar.cc/150?u=4",
      "phone": "015XXXXXXXX"
    },
    {
      "name": "Kalam Ahmed",
      "designation": "Assistant Teacher",
      "subject": "Chemistry",
      "image": "https://i.pravatar.cc/150?u=4",
      "phone": "015XXXXXXXX"
    },
    {
      "name": " Ahmed",
      "designation": "Assistant Teacher",
      "subject": "Chemistry",
      "image": "https://i.pravatar.cc/150?u=4",
      "phone": "015XXXXXXXX"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Our Teachers", style: TextStyle(fontWeight: FontWeight.bold)),
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
              // ================= SEARCH BAR =================
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search teacher by name or subject...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                ),
              ),

              // ================= TEACHER LIST =================
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    final teacher = teachers[index];
                    return _buildTeacherCard(teacher);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherCard(Map<String, dynamic> teacher) {

    Widget _buildTeacherCard(Map<String, dynamic> teacher) {
      return InkWell(
        onTap: () {
          // কার্ডে ক্লিক করলে ডিটেইলস স্ক্রিনে নিয়ে যাবে
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherDetailsScreen(teacher: teacher),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          // ... বাকি কোড (যা আপনার আগের কার্ড ডিজাইনে ছিল)
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // টিচার ইমেজ
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: NetworkImage(teacher["image"]),
          ),
          const SizedBox(width: 16),

          // টিচার ডিটেইলস
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacher["name"],
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  teacher["designation"],
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 8),
                // সাবজেক্ট ট্যাগ
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    teacher["subject"],
                    style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // অ্যাকশন বাটন
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call_outlined, color: Colors.green),
                style: IconButton.styleFrom(backgroundColor: Colors.green.withOpacity(0.1)),
              ),
              const SizedBox(height: 4),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.email_outlined, color: AppColors.primary),
                style: IconButton.styleFrom(backgroundColor: AppColors.primary.withOpacity(0.1)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/
