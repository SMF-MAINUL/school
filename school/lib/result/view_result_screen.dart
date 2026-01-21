import 'package:flutter/material.dart';
import 'package:tatulbaria_school_website/result/subject_result_screen.dart';
import '../app_color.dart';

class ViewResultScreen extends StatefulWidget {
  @override
  State<ViewResultScreen> createState() => _ViewResultScreenState();
}

class _ViewResultScreenState extends State<ViewResultScreen> {
  final Map<String, dynamic> dummyAdmin = {
    "fullname": "Md. Jamil Hossain",
    "id": "10021",
    "username": "jamil_admin",
    "email": "jamil.admin@example.com",
    "phone": "01700000000",
    "mobile": "01900000000",
    "dob": "12-05-1990",
    "status": "approved",
    "created_at": "20-01-2024",
    "profile_image": "https://via.placeholder.com/150",
  };

  // ক্লাসের লিস্ট
  final List<String> highSchoolClasses = [
    "Class 6",
    "Class 7",
    "Class 8",
    "Class 9",
    "Class 10",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Student & Academic Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ================= HEADER SECTION =================
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: NetworkImage(
                            dummyAdmin["profile_image"],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),

                Text(
                  dummyAdmin["fullname"],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                _buildStatusBadge(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildInfoCard(
                        Icons.badge,
                        "Student ID",
                        dummyAdmin["id"],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        Icons.email,
                        "Email Address",
                        dummyAdmin["email"],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        Icons.phone,
                        "Phone Number",
                        dummyAdmin["phone"],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // ================= ACADEMIC RESULT SECTION (NEW) =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "High School Result Sheets (6-10)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // ক্লাস ভিত্তিক রেজাল্ট কার্ড গ্রিড
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // প্রতি সারিতে ২টা ক্লাস
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.5,
                            ),
                        itemCount: highSchoolClasses.length,
                        itemBuilder: (context, index) {
                          return _buildResultClassCard(
                            highSchoolClasses[index],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ================= PERSONAL INFO CARDS =================
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // রেজাল্ট ক্লাসের জন্য ডিজাইন
  Widget _buildResultClassCard(String className) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectResultScreen(className: className),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              className,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green, width: 1),
      ),
      child: const Text(
        "VERIFIED ADMIN",
        style: TextStyle(
          color: Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../app_color.dart';

class ViewResultScreen extends StatefulWidget {
  @override
  State<ViewResultScreen> createState() => _ViewResultScreenState();
}

class _ViewResultScreenState extends State<ViewResultScreen> {
  Map<String, dynamic>? admin;
  bool _loading = true;
  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  */
/*  Future<void> _fetchProfileData() async {
    try {
      String? adminId = await api.getSavedAdminId();

      if (adminId != null) {
        final response = await api.getProfileById(adminId);
        if (mounted) {
          setState(() {
            admin = response['admin'];
            _loading = false;
          });
        }
      } else {
        _showError("No login session found.");
        setState(() => _loading = false);
      }
    } catch (e) {
      _showError("Error loading profile");
      setState(() => _loading = false);
    }
  }*/ /*


  Future<void> _fetchProfileData() async {
    try {
      String? adminId = await api.getSavedAdminId();

      if (adminId == null) {
        if (!mounted) return;
        _showError("No login session found.");
        setState(() => _loading = false);
        return;
      }

      final response = await api.getProfileById(adminId);

      // ✅ SAFE CHECK
      if (response == null || response['admin'] == null) {
        if (!mounted) return;
        _showError("Profile data not found");
        setState(() => _loading = false);
        return;
      }

      if (!mounted) return;
      setState(() {
        admin = response['admin'];
        _loading = false;
      });
    } catch (e) {
      debugPrint("PROFILE ERROR: $e");
      if (!mounted) return;
      _showError("Error loading profile");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (admin == null) {
      return const Scaffold(
        body: Center(child: Text('Admin profile data missing')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Admin Profile"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ================= PROFILE HEADER =================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 58,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 54,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            backgroundImage:
                            (admin!["profile_image"] != null &&
                                admin!["profile_image"] != "")
                                ? NetworkImage(admin!["profile_image"])
                                : null,
                            child:
                            (admin!["profile_image"] == null ||
                                admin!["profile_image"] == "")
                                ? Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.primary,
                            )
                                : null,
                          ),
                        ),


                        const SizedBox(height: 16),

                        Text(
                          admin!["fullname"] ?? "Unknown",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: admin!["status"] == "approved"
                                ? Colors.green
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            admin!["status"].toString().toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ================= DETAILS CARD =================
                  Card(
                    elevation: 8,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _modernInfoRow(
                            Icons.badge,
                            "Admin ID",
                            "#${admin!["id"]}",
                            isMobile,
                          ),
                          _modernInfoRow(
                            Icons.person_outline,
                            "Username",
                            admin!["username"] ?? "N/A",
                            isMobile,
                          ),
                          _modernInfoRow(
                            Icons.email_outlined,
                            "Email",
                            admin!["email"] ?? "N/A",
                            isMobile,
                          ),
                          _modernInfoRow(
                            Icons.phone_outlined,
                            "Phone",
                            admin!["phone"] ?? "N/A",
                            isMobile,
                          ),
                          _modernInfoRow(
                            Icons.smartphone,
                            "Mobile",
                            admin!["mobile"] ?? "N/A",
                            isMobile,
                          ),
                          _modernInfoRow(
                            Icons.calendar_month_outlined,
                            "Date of Birth",
                            admin!["dob"] ?? "N/A",
                            isMobile,
                          ),
                          _modernInfoRow(
                            Icons.history,
                            "Joined At",
                            admin!["created_at"] ?? "N/A",
                            isMobile,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _modernInfoRow(
      IconData icon,
      String label,
      String value,
      bool isMobile,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String msg) {
    final bottomInset = MediaQuery.of(
      context,
    ).viewInsets.bottom; // keyboard height
    final marginBottom = bottomInset > 0 ? bottomInset + 16.0 : 16.0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: marginBottom, left: 16, right: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
*/
