import 'dart:async';
import 'dart:ui' as html hide window;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/foundation.dart' show kIsWeb; // Web check করার জন্য
import 'package:tatulbaria_school_website/admition/admition_screen.dart';
import 'package:tatulbaria_school_website/app_color.dart';
import 'package:tatulbaria_school_website/teacher_list/teacher_list_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../notice/notice_carousel.dart';
import '../notice/notice_service.dart';
import '../notice/student_notice_model.dart';
import '../result/result_search_screen.dart'; // Mobile জন্য

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  int bannerIndex = 0;
  int _pageIndex = 0; // কারেন্ট পেজ ইনডেক্স রাখার জন্য
  // কম্পলেইন বক্সের জন্য কন্ট্রোলারসমূহ
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();
  final NoticeService _service = NoticeService("https://threestarambulance.com/");

  // ইনপুট ফিল্ড খালি কি না তা চেক করার লজিক
  bool get isNameFilled => _nameController.text.isNotEmpty;
  bool get isPhoneFilled => _phoneController.text.isNotEmpty;
  bool get isMsgFilled => _msgController.text.isNotEmpty;
  bool get isAllFilled => isNameFilled && isPhoneFilled && isMsgFilled;

  // আপনার স্টেটফুল উইজেটের ভেতরে এগুলো ডিক্লেয়ার করুন
  late PageController _teacherPageController;
  int _currentTeacherIndex = 0;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // viewportFraction 0.6 দিলে স্ক্রিনে একসাথে দেড়খানা কার্ড দেখা যাবে, যা ইউজারকে স্ক্রল করতে উৎসাহিত করে
    _teacherPageController = PageController(
      viewportFraction: 0.6,
      initialPage: 0,
    );

    _startAutoScroll();
  }

  void _startAutoScroll() {
    Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_teacherPageController.hasClients) {
        if (_currentTeacherIndex < 3) {
          _currentTeacherIndex++;
        } else {
          _currentTeacherIndex = 0; // শেষে পৌঁছে গেলে আবার শুরুতে জাম্প করবে
        }

        _teacherPageController.animateToPage(
          _currentTeacherIndex,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  @override
  void dispose() {
    _teacherPageController.dispose(); // মেমোরি লিক রোধে ডিসপোজ করা জরুরি
    super.dispose();
  }



  // Future<void> openUrl(String url) async {
  //   if (kIsWeb) {
  //     // Web: open link in new tab
  //     html.window.open(url, '_blank');
  //   } else {
  //     // Mobile/Desktop
  //     final Uri uri = Uri.parse(url);
  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri, mode: LaunchMode.externalApplication);
  //     } else {
  //       throw 'Could not launch $url';
  //     }
  //   }
  // }


Future<void> openUrl(String url) async {
  final Uri uri = Uri.parse(url);
  
  // launchUrl ফাংশনটি স্মার্ট; এটি ওয়েব এবং মোবাইল উভয় জায়গায় কাজ করে।
  // mode: LaunchMode.externalApplication দিলে এটি ব্রাউজারে ওপেন হবে।
  try {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  } catch (e) {
    debugPrint("Error launching URL: $e");
  }
}
  Widget _buildContactItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.indigo, size: 20),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  // ================= GOOGLE MAP SECTION =================
  Widget googleMapSection(BuildContext context) {
    final double mapHeight = MediaQuery.of(context).size.width > 900
        ? 400
        : 250;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'আমাদের অবস্থান',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: mapHeight,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(23.8103, 90.4125),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('school'),
                    position: const LatLng(23.8103, 90.4125),
                    infoWindow: InfoWindow(
                      title: 'TatulBaria High School',
                      snippet: 'Tap here to open in Google Maps',
                      onTap: () {
                        openUrl('https://maps.app.goo.gl/UTERYUfRG3YtbTyu5');
                      },
                    ),
                  ),
                },
                zoomControlsEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<BannerInfo> banners = [
    BannerInfo(
      mainImage: 'assets/road/image1.jpg',
      left: 'none',
      front: 'assets/road/image2.webp',
      right: 'assets/road/image3.webp',
      back: 'none',
    ),
    BannerInfo(
      mainImage: 'assets/road/image2.webp',
      left: 'assets/road/image1.jpg',
      front: 'assets/road/image4.webp',
      right: 'none',
      back: 'none',
    ),
    BannerInfo(
      mainImage: 'assets/road/image3.webp',
      left: 'assets/road/image2.webp',
      front: 'assets/road/image4.webp',
      right: 'none',
      back: 'assets/road/image5.webp',
    ),
    BannerInfo(
      mainImage: 'assets/road/image4.webp',
      left: 'assets/road/image2.webp',
      front: 'assets/road/image5.webp',
      right: 'none',
      back: 'assets/road/image6.webp',
    ),
    BannerInfo(
      mainImage: 'assets/road/image5.webp',
      left: 'assets/road/image2.webp',
      front: 'assets/road/image6.webp',
      right: 'none',
      back: 'assets/road/image7.webp',
    ),
    BannerInfo(
      mainImage: 'assets/road/image6.webp',
      left: 'assets/road/image2.webp',
      front: 'assets/road/image7.webp',
      right: 'none',
      back: 'assets/road/image11.webp',
    ),
    BannerInfo(
      mainImage: 'assets/road/image7.webp',
      left: 'assets/road/image8.webp',
      front: 'assets/road/image4.webp',
      right: 'none',
      back: 'assets/road/image1.jpg',
    ),
    BannerInfo(
      mainImage: 'assets/road/image8.webp',
      left: 'assets/road/image2.webp',
      front: 'assets/road/image9.webp',
      right: 'none',
      back: 'assets/road/image11.webp',
    ),
    BannerInfo(
      mainImage: 'assets/road/image9.webp',
      left: 'assets/road/image10.webp',
      front: 'none',
      right: 'assets/road/image6.webp',
      back: 'assets/road/image3.webp',
    ),
    BannerInfo(
      mainImage: 'assets/road/image10.webp',
      left: 'assets/road/image11.webp',
      front: 'assets/road/image7.webp',
      right: 'none',
      back: 'assets/road/image9.webp',
    ),
    BannerInfo(
      mainImage: 'assets/road/image11.webp',
      left: 'assets/road/image8.webp',
      front: 'assets/road/image9.webp',
      right: 'none',
      back: 'assets/road/image10.webp',
    ),
  ];

  

  bool isWeb(BuildContext context) => MediaQuery.of(context).size.width > 900;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Mini Map Size
    final double mapSize = isWeb(context) ? 250 : 180;
    final double neighborSize = isWeb(context) ? 60 : 45;
    final double center = mapSize / 2 - neighborSize / 2;

    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),

      appBar: AppBar(
        title: const Text('TatulBaria High School'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 2,
        iconTheme: const IconThemeData(color: AppColors.textLight),
        titleTextStyle: const TextStyle(
          color: AppColors.textLight,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Home')),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Teacher List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherListScreen()),
                );
              },
            ),
            ListTile(leading: Icon(Icons.school), title: Text('About')),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Administration'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdmissionFormScreen(),
                  ),
                );
              },
            ),
            ListTile(leading: Icon(Icons.menu_book), title: Text('Academics')),
            ListTile(leading: Icon(Icons.notifications), title: Text('Notice')),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Result'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultSearchScreen()),
                );
              },
            ),
            ListTile(leading: Icon(Icons.contact_page), title: Text('Contact')),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= NOTICE SECTION =================
            sectionTitle("নোটিশ", ''),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'শিক্ষার্থীদের অবগতির জন্য জানানো যাচ্ছে যে, প্রতিষ্ঠানের সকল একাডেমিক কার্যক্রম, পরীক্ষা সংক্রান্ত তথ্য ও গুরুত্বপূর্ণ ঘোষণাসমূহ এই নোটিশ বোর্ডের মাধ্যমে নিয়মিত প্রকাশ করা হবে।',
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),

            AspectRatio(
              aspectRatio: MediaQuery.of(context).size.width > 900
                  ? 16 / 6
                  : 16 / 8,
              child: NoticeCarousel(
                noticeImages: [
                  'assets/road/image8.webp',
                  'assets/road/image9.webp',
                  'assets/road/image10.webp',
                ],
              ),
            ),


            FutureBuilder<List<StudentNotice>>(
              future: _service.fetchStudentNotices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {


                  return const Center(child: Text("No Notice Found" ));
                }

                final notices = snapshot.data!;

                // ✅ Image list (attachmentUrl থেকে)
                final images = notices
                    .where((n) => n.attachmentUrl != null && n.attachmentUrl!.isNotEmpty)
                    .map((n) => n.attachmentUrl!)
                    .toList();

                return Column(
                  children: [

                    // ✅ Carousel (যদি image থাকে)
                    if (images.isNotEmpty)
                      AspectRatio(
                        aspectRatio: MediaQuery.of(context).size.width > 900 ? 16 / 6 : 16 / 8,
                        child: NoticeCarousel(
                          noticeImages: images,
                          isNetwork: true,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // ✅ Notice List (Title + Description)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        final n = notices[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(
                              n.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(n.description),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 80),

            // ================= HERO BANNER =================
            Stack(
              clipBehavior: Clip.none,
              children: [
                AspectRatio(
                  aspectRatio: isWeb(context) ? 16 / 6 : 16 / 8,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(banners[bannerIndex].mainImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // // Left Arrow
                // if (banners[bannerIndex].left != 'none')
                //   Positioned(
                //     left: 10,
                //     top: isWeb(context) ? 180 : 100,
                //     child: arrowBtn(Icons.arrow_back, () {
                //       setState(() => bannerIndex--);
                //     }),
                //   ),

                // // Right Arrow
                // if (banners[bannerIndex].right != 'none')
                //   Positioned(
                //     right: 10,
                //     top: isWeb(context) ? 180 : 100,
                //     child: arrowBtn(Icons.arrow_forward, () {
                //       setState(() => bannerIndex++);
                //     }),
                //   ),
              ],
            ),

            Padding(
              padding: EdgeInsetsGeometry.only(left: 10, right: 10),
              child: Center(child: Text("My name is Mainul")),
            ),

            const SizedBox(height: 20), // Banner আর Map এর মধ্যে gap

            Center(
              child: Text(
                'School RodMap',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold, // ✅ এখানে বোল্ড যুক্ত
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ================= Mini Map Compass =================
            Center(
              child: Container(
                width: mapSize,
                height: mapSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Vertical line
                    Positioned(
                      top: neighborSize / 2,
                      bottom: neighborSize / 2,
                      left: mapSize / 2 - 1,
                      child: Container(
                        width: 2,
                        color: Colors.blueAccent.withOpacity(0.5),
                      ),
                    ),

                    // Horizontal line
                    Positioned(
                      top: mapSize / 2 - 1,
                      left: neighborSize / 2,
                      right: neighborSize / 2,
                      child: Container(
                        height: 2,
                        color: Colors.blueAccent.withOpacity(0.5),
                      ),
                    ),

                    // Top Neighbor
                    Positioned(
                      top: 10,
                      left: mapSize / 2 - neighborSize / 2,
                      child: neighborImageWidget(
                        banners[bannerIndex].front,
                        () {
                          if (banners[bannerIndex].front != 'none') {
                            setState(() {
                              bannerIndex = banners.indexWhere(
                                (b) =>
                                    b.mainImage == banners[bannerIndex].front,
                              );
                            });
                          }
                        },
                        size: neighborSize,
                      ),
                    ),

                    // Left Neighbor
                    Positioned(
                      top: mapSize / 2 - neighborSize / 2,
                      left: 10,
                      child: neighborImageWidget(banners[bannerIndex].left, () {
                        if (banners[bannerIndex].left != 'none') {
                          setState(() {
                            bannerIndex = banners.indexWhere(
                              (b) => b.mainImage == banners[bannerIndex].left,
                            );
                          });
                        }
                      }, size: neighborSize),
                    ),

                    // Right Neighbor
                    Positioned(
                      top: mapSize / 2 - neighborSize / 2,
                      right: 10,
                      child: neighborImageWidget(
                        banners[bannerIndex].right,
                        () {
                          if (banners[bannerIndex].right != 'none') {
                            setState(() {
                              bannerIndex = banners.indexWhere(
                                (b) =>
                                    b.mainImage == banners[bannerIndex].right,
                              );
                            });
                          }
                        },
                        size: neighborSize,
                      ),
                    ),

                    // Bottom Neighbor
                    Positioned(
                      bottom: 10,
                      left: mapSize / 2 - neighborSize / 2,
                      child: neighborImageWidget(banners[bannerIndex].back, () {
                        if (banners[bannerIndex].back != 'none') {
                          setState(() {
                            bannerIndex = banners.indexWhere(
                              (b) => b.mainImage == banners[bannerIndex].back,
                            );
                          });
                        }
                      }, size: neighborSize),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ================= TEACHERS / TEAM SECTION (Horizontal Row) =================
            // sectionTitle(
            //   "আমাদের শিক্ষক মন্ডলী",
            //   "যোগ্য ও অভিজ্ঞ শিক্ষকমন্ডলীর তালিকা",
            // ),

            // // ================= TEACHERS SECTION (Title inside Card + Auto Scroll) =================
            // Container(
            //   height:
            //       430, // উচ্চতা বাড়ানো হয়েছে টাইটেল এবং ইন্ডিকেটর রাখার জন্য
            //   margin: const EdgeInsets.symmetric(horizontal: 24),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(25),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.05),
            //         blurRadius: 20,
            //         offset: const Offset(0, 10),
            //       ),
            //     ],
            //     border: Border.all(color: Colors.grey[100]!),
            //   ),
            //   child: Column(
            //     children: [
            //       // --- টাইটেল এখন কার্ডের ভেতরে ---
            //       Padding(
            //         padding: const EdgeInsets.only(top: 20, bottom: 10),
            //         child: Column(
            //           children: [
            //             sectionTitle(
            //               "আমাদের শিক্ষক মন্ডলী",
            //               "যোগ্য ও অভিজ্ঞ শিক্ষকমন্ডলীর তালিকা",
            //             ),
            //           ],
            //         ),
            //       ),

            //       // --- স্লাইডিং লিস্ট ---
            //       Expanded(
            //         child: PageView.builder(
            //           controller: _teacherPageController,
            //           itemCount: 4,
            //           onPageChanged: (index) {
            //             setState(() => _currentTeacherIndex = index);
            //           },
            //           itemBuilder: (context, index) {
            //             List<String> names = [
            //               "মোঃ আবদুর রহমান",
            //               "সালেহা খাতুন",
            //               "জহিরুল ইসলাম",
            //               "ফাতেমা জান্নাত",
            //             ];
            //             List<String> roles = [
            //               "প্রধান শিক্ষক",
            //               "সহকারী প্রধান শিক্ষক",
            //               "সিনিয়র শিক্ষক",
            //               "সহকারী শিক্ষক",
            //             ];

            //             return Padding(
            //               padding: const EdgeInsets.symmetric(
            //                 horizontal: 10,
            //                 vertical: 10,
            //               ),
            //               child: _buildTeacherRowItem(
            //                 'assets/road/kairul.jpg',
            //                 names[index],
            //                 roles[index],
            //               ),
            //             );
            //           },
            //         ),
            //       ),

            //       // --- কানেক্টেড ইন্ডিকেটর রেখা ---
            //       Padding(
            //         padding: const EdgeInsets.only(bottom: 20, top: 10),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: List.generate(4, (index) {
            //             bool isActive = _currentTeacherIndex == index;
            //             return AnimatedContainer(
            //               duration: const Duration(milliseconds: 300),
            //               margin: const EdgeInsets.symmetric(horizontal: 2),
            //               height: 4,
            //               width: isActive ? 30 : 15, // একটিভ হলে রেখা লম্বা হবে
            //               decoration: BoxDecoration(
            //                 color: isActive
            //                     ? const Color(
            //                         0xFF6A11CB,
            //                       ) // একটিভ কালার (Indigo)
            //                     : Colors.grey.shade300, // ইন-অ্যাক্টিভ কালার
            //                 borderRadius: BorderRadius.circular(10),
            //               ),
            //             );
            //           }),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // ================= TEACHERS SECTION (Title inside Card + Scroll) =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.only(bottom: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: Colors.grey[100]!),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // এটি অটো হাইট নিবে
                children: [
                  // --- টাইটেল ---
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: sectionTitle(
                      "আমাদের শিক্ষক মন্ডলী",
                      "যোগ্য ও অভিজ্ঞ শিক্ষকমন্ডলীর তালিকা",
                    ),
                  ),

                  // --- স্লাইডিং লিস্ট (এখানেই উইথ কন্ট্রোল হবে) ---
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // ডানে-বামে সরানোর জন্য
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "মোঃ আবদুর রহমান",
                          "প্রধান শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "সালেহা খাতুন",
                          "সহকারী প্রধান শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "জহিরুল ইসলাম",
                          "সিনিয়র শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                        _buildTeacherRowItem(
                          context,
                          'assets/road/kairul.jpg',
                          "ফাতেমা জান্নাত",
                          "সহকারী শিক্ষক",
                        ),
                      ],
                    ),
                  ),
                  minisectionGap(),
                ],
              ),
            ),

            // Container(
            //   height: 240, // মোট কন্টেইনারের উচ্চতা
            //   margin: const EdgeInsets.symmetric(horizontal: 24),
            //   // padding: const EdgeInsets.symmetric(vertical: 10),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(15),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.05),
            //         blurRadius: 15,
            //         offset: const Offset(0, 5),
            //       ),
            //     ],
            //     border: Border.all(color: Colors.grey[100]!),
            //   ),
            //   child: Center(
            //     child: ListView.builder(
            //       scrollDirection: Axis.horizontal, // অনুভূমিক স্ক্রলিং
            //       itemCount: 4, // আপাতত ৪ জন শিক্ষকের ডামি ডাটা
            //       itemBuilder: (context, index) {
            //         // এখানে ডামি ডাটা দেওয়া হয়েছে
            //         List<String> names = [
            //           "মোঃ আবদুর রহমান",
            //           "FutureBuilderসালেহা খাতুন",
            //           "জহিরুল ইসলাম",
            //           "ফাতেমা জান্নাত",
            //         ];
            //         List<String> roles = [
            //           "প্রধান শিক্ষক",
            //           "সহকারী প্রধান শিক্ষক",
            //           "সিনিয়র শিক্ষক",
            //           "সহকারী শিক্ষক",
            //         ];
            //         List<String> imagePaths = [
            //           'assets/road/kairul.jpg', // আপনার শিক্ষকের ছবির পাথ এখানে দিন
            //           'assets/road/kairul.jpg',
            //           'assets/road/kairul.jpg',
            //           'assets/road/kairul.jpg',
            //         ];

            //         return _buildTeacherRowItem(
            //           imagePaths[index],
            //           names[index],
            //           roles[index],
            //         );
            //       },
            //     ),
            //   ),
            // ),

            // // ================= ABOUT =================
            // sectionTitle("আমাদের সম্পর্কে", "কলেজ পরিচিতি ও লক্ষ্য"),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
            //   child: const Text(
            //     "ABC Public High School একটি সরকার অনুমোদিত শিক্ষা প্রতিষ্ঠান, যা শিক্ষার্থীদের সর্বোত্তম শিক্ষা প্রদানের জন্য আধুনিক পরিবেশ নিশ্চিত করেছে। দীর্ঘ শিক্ষাগত ঐতিহ্য এবং গৌরবময় ইতিহাসের সাথে, এই কলেজ শিক্ষার্থীদের মানসম্মত শিক্ষায় এগিয়ে নিয়ে যায়। আমাদের লক্ষ্য হলো শিক্ষার্থীদের শৃঙ্খলা, মানবিক গুণাবলী এবং সার্বিক বিকাশ নিশ্চিত করা। কলেজে আধুনিক ভবন, সজ্জিত ক্লাসরুম, উন্নত ল্যাবরেটরি, সমৃদ্ধ লাইব্রেরি এবং খেলাধুলার সুযোগসহ সমৃদ্ধ অবকাঠামো রয়েছে, যা শিক্ষার্থীদের একটি সম্পূর্ণ শিক্ষাগত অভিজ্ঞতা প্রদান করে। এখানে শিক্ষার্থীরা কেবলমাত্র জ্ঞান অর্জন করে না, বরং নৈতিকতা, দায়িত্ববোধ এবং সামাজিক দায়িত্বের চেতনা শেখে। আমাদের উদ্দেশ্য শিক্ষার্থীদের এমনভাবে গড়ে তোলা যাতে তারা ভবিষ্যতে সমাজের জন্য মূল্যবান নাগরিক হিসেবে নিজেকে প্রতিষ্ঠা করতে পারে।",
            //     style: TextStyle(
            //       fontSize: 16,
            //       color: Colors.black87,
            //       height: 1.7,
            //     ),
            //     textAlign: TextAlign.justify,
            //   ),
            // ),

            // ================= ABOUT SECTION (Modern Style) =================
            // Container(
            //   margin: const EdgeInsets.all(24),
            //   padding: const EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(30),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.05),
            //         blurRadius: 20,
            //         offset: const Offset(0, 10),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     children: [
            //       sectionTitle("আমাদের সম্পর্কে", "কলেজ পরিচিতি ও লক্ষ্য"),
            //       const SizedBox(height: 20),

            //       // ইমেজ এবং কন্টেন্ট এর জন্য রো (পিসিতে ডানে-বামে, মোবাইলে উপরে-নিচে)
            //       LayoutBuilder(
            //         builder: (context, constraints) {
            //           bool isMobile = constraints.maxWidth < 600;

            //           return Flex(
            //             direction: isMobile ? Axis.vertical : Axis.horizontal,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               // বাম দিকের ইমেজ (আপনার ইমেজের মতো থ্রিডি স্টাইল দিতে পারেন)
            //               Expanded(
            //                 flex: isMobile ? 0 : 1,
            //                 child: Container(
            //                   height: 250,
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(20),
            //                     gradient: const LinearGradient(
            //                       colors: [
            //                         Color(0xFF6A11CB),
            //                         Color(0xFF2575FC),
            //                       ],
            //                     ),
            //                   ),
            //                   child: const Center(
            //                     child: Icon(
            //                       Icons.school_rounded,
            //                       size: 100,
            //                       color: Colors.white,
            //                     ),
            //                     // এখানে আপনার কলেজের মেইন ইমেজ দিতে পারেন
            //                   ),
            //                 ),
            //               ),

            //               if (!isMobile)
            //                 const SizedBox(width: 30)
            //               else
            //                 const SizedBox(height: 20),

            //               // ডান দিকের টেক্সট কন্টেন্ট
            //               Expanded(
            //                 flex: isMobile ? 0 : 1,
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     const Text(
            //                       "গৌরবময় ইতিহাসের সাথে আধুনিক শিক্ষা",
            //                       style: TextStyle(
            //                         fontSize: 20,
            //                         fontWeight: FontWeight.bold,
            //                         color: Color(0xFF333333),
            //                       ),
            //                     ),
            //                     const SizedBox(height: 15),
            //                     const Text(
            //                       "ABC Public High School একটি সরকার অনুমোদিত শিক্ষা প্রতিষ্ঠান। আমাদের লক্ষ্য হলো শিক্ষার্থীদের শৃঙ্খলা, মানবিক গুণাবলী এবং সার্বিক বিকাশ নিশ্চিত করা। এখানে আধুনিক ল্যাবরেটরি, সমৃদ্ধ লাইব্রেরি এবং খেলাধুলার সকল সুযোগ বিদ্যমান।",
            //                       style: TextStyle(
            //                         fontSize: 15,
            //                         color: Colors.black54,
            //                         height: 1.6,
            //                       ),
            //                       textAlign: TextAlign.justify,
            //                     ),
            //                     const SizedBox(height: 20),

            //                     // একটি ছোট বাটন (আপনার ইমেজের মতো)
            //                     ElevatedButton(
            //                       onPressed: () {},
            //                       style: ElevatedButton.styleFrom(
            //                         backgroundColor: const Color(0xFF6A11CB),
            //                         foregroundColor: Colors.white,
            //                         shape: RoundedRectangleBorder(
            //                           borderRadius: BorderRadius.circular(12),
            //                         ),
            //                         padding: const EdgeInsets.symmetric(
            //                           horizontal: 25,
            //                           vertical: 15,
            //                         ),
            //                       ),
            //                       child: const Text("আরও জানুন"),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           );
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              height: 450, // হাইট আপনার প্রয়োজনমতো অ্যাডজাস্ট করতে পারেন
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: const Color(
                  0xFF1A1F3D,
                ), // কার্ডের মেইন ডার্ক ব্যাকগ্রাউন্ড (ইমেজের মতো)
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // ১. বাম পাশের ঢেউ বা ওয়েভ কালার (Blue Gradient Wave)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: ClipPath(
                      clipper: AboutWaveClipper(),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [Color(0xFF4EEBFF), Color(0xFF00ADFF)],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ২. কন্টেন্ট (ইমেজ এবং টেক্সট)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        bool isMobile = constraints.maxWidth < 700;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // বাম পাশে স্কুলের ইমেজ বা ক্যারেক্টার
                            if (!isMobile)
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Image.asset(
                                    'assets/school_catagory.png', // আপনার ইমেজ পাথ
                                    height: 350,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),

                            const SizedBox(width: 20),

                            // ডান পাশে বর্ণনা ও টেক্সট
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "KNOW ME MORE",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "ABC Public High School",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "আমাদের লক্ষ্য হলো শিক্ষার্থীদের শৃঙ্খলা, মানবিক গুণাবলী এবং সার্বিক বিকাশ নিশ্চিত করা। এখানে আধুনিক ভবন, সজ্জিত ক্লাসরুম এবং উন্নত ল্যাবরেটরি রয়েছে যা শিক্ষার্থীদের একটি সম্পূর্ণ শিক্ষাগত অভিজ্ঞতা প্রদান করে।",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      height: 1.6,
                                    ),
                                  ),
                                  const SizedBox(height: 30),

                                  // আপনার ইমেজের মতো বাটন
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "ABOUT ME »",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // googleMapSection(context),
            // sectionGap(),
            sectionGap(),

            // ================= COMPLAINT BOX SECTION =================
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 850, // ডেস্কটপে সর্বোচ্চ চওড়া ৮৫০ পিক্সেল হবে
                ),
                child: Container(
                  // লজিক: বড় স্ক্রিনে মার্জিন ২৪, কিন্তু স্ক্রিন ছোট হলে ডানে-বামে অটো অ্যাডজাস্ট হবে
                  margin: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  padding: const EdgeInsets.all(
                    32,
                  ), // প্যাডিং কিছুটা বাড়িয়ে প্রফেশনাল করা হয়েছে
                  decoration: BoxDecoration(
                    // এখানে হালকা প্রফেশনাল গ্রাডিয়েন্ট ব্যবহার করা হয়েছে
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white, // উপরের বাম দিকে সলিড সাদা
                        Color(
                          0xFFF8FAFF,
                        ), // নিচের দিকে হালকা নীলচে ভাব (Professional off-white)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    // হালকা প্রফেশনাল শ্যাডো এবং বর্ডার
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(
                          0.06,
                        ), // ব্র্যান্ড কালারের হালকা শ্যাডো
                        blurRadius: 40,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      sectionTitle("অভিযোগ বক্স", "আপনার মতামত আমাদের জানান"),
                      xlminisectionGap(),

                      // ১. নাম ইনপুট
                      _buildConnectedField(
                        controller: _nameController,
                        label: "আপনার নাম",
                        icon: Icons.person_outline,
                        isActive: isNameFilled,
                        showLine: true,
                      ),

                      // ২. মোবাইল নম্বর
                      _buildConnectedField(
                        controller: _phoneController,
                        label: "মোবাইল নম্বর",
                        icon: Icons.phone_android_outlined,
                        isActive: isPhoneFilled,
                        showLine: true,
                      ),

                      // ৩. অভিযোগের বিষয়
                      _buildConnectedField(
                        controller: _msgController,
                        label: "অভিযোগ/মতামত",
                        icon: Icons.edit_note_rounded,
                        isActive: isMsgFilled,
                        showLine: true,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 15),

                      // ৪. সাবমিট বাটন (প্রফেশনাল গ্রাডিয়েন্ট)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: isAllFilled
                              ? [
                                  BoxShadow(
                                    color: Colors.indigo.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : [],
                          gradient: isAllFilled
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF3949AB),
                                    Color(0xFF5C6BC0),
                                  ], // প্রফেশনাল ব্লু গ্রাডিয়েন্ট
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.grey.shade300,
                                    Colors.grey.shade400,
                                  ],
                                ),
                        ),
                        child: ElevatedButton(
                          onPressed: isAllFilled
                              ? () => print("Submitted")
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 1.1,
                              color: isAllFilled
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ================= ADAPTIVE SOCIAL & CONTACT SECTION =================
            LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth;

                // রেসপনসিভ ভ্যালু সেটআপ
                double iconSize = width < 600 ? 24 : (width < 1000 ? 32 : 40);
                double iconPadding = width < 600
                    ? 10
                    : (width < 1000 ? 15 : 20);
                double itemSpacing = width < 600 ? 8 : (width < 1000 ? 15 : 25);
                double fontSize = width < 600 ? 13 : (width < 1000 ? 16 : 18);

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      sectionTitle(
                        "সামাজিক যোগাযোগ মাধ্যম",
                        'শেখার প্রয়োজনে আমাদের সাথে যোগাযোগ করুন',
                      ),

                      // --- সোশ্যাল আইকন রো (Adaptive) ---
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: itemSpacing, // আইকনগুলোর মাঝের গ্যাপ রেসপনসিভ
                        runSpacing: 15,
                        children: [
                          _buildResponsiveHoverButton(
                            icon: Icons.facebook,
                            color: const Color(0xFF1877F2),
                            size: iconSize,
                            padding: iconPadding,
                            onTap: () => _launchURL("https://facebook.com"),
                          ),
                          _buildResponsiveHoverButton(
                            icon: Icons.camera_alt_rounded,
                            color: const Color(0xFFE4405F),
                            size: iconSize,
                            padding: iconPadding,
                            onTap: () => _launchURL("https://instagram.com"),
                          ),
                          _buildResponsiveHoverButton(
                            icon: Icons.play_circle_fill,
                            color: const Color(0xFFFF0000),
                            size: iconSize,
                            padding: iconPadding,
                            onTap: () => _launchURL("https://youtube.com"),
                          ),
                          _buildResponsiveHoverButton(
                            icon: Icons.chat_bubble_rounded,
                            color: const Color(0xFF25D366),
                            size: iconSize,
                            padding: iconPadding,
                            onTap: () => _launchURL("https://wa.me/number"),
                          ),
                        ],
                      ),

                      minisectionGap(),

                      // --- জিমেইল ও ফোন নাম্বার (Adaptive) ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 15,
                          children: [
                            _buildContactPill(
                              icon: Icons.email_rounded,
                              label: "info@college.edu.bd",
                              fontSize: fontSize,
                              isMobile: width < 600,
                            ),
                            _buildContactPill(
                              icon: Icons.phone_android_rounded,
                              label: "+880 1617963617",
                              fontSize: fontSize,
                              isMobile: width < 600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // // ================= FOOTER SECTION =================
            // Container(
            //   width: double.infinity,
            //   decoration: const BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [
            //         Colors.indigo,
            //         AppColors.primary,
            //       ], // প্রফেশনাল গ্রাডিয়েন্ট লুক
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //     ),
            //   ),
            //   padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            //   child: Column(
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           const Icon(Icons.school, color: Colors.white70, size: 20),
            //           const SizedBox(width: 10),
            //           Text(
            //             "TATULBARIA HIGH SCHOOL",
            //             style: TextStyle(
            //               color: Colors.white.withOpacity(0.9),
            //               fontWeight: FontWeight.bold,
            //               letterSpacing: 1.2,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 12),
            //       Text(
            //         "© 2026 Tatulbaria High School | All Rights Reserved",
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           color: Colors.white.withOpacity(0.6),
            //           fontSize: 12,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       Text(
            //         "Developed by School Management System",
            //         style: TextStyle(
            //           color: Colors.white.withOpacity(0.4),
            //           fontSize: 10,
            //           fontStyle: FontStyle.italic,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // ================= MODERN FOOTER SECTION =================
            // ================= FLOATING SUBSCRIPTION FOOTER =================
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // --- মেইন ফুটার কার্ড (সাদা অংশ) ---
                Container(
                  margin: const EdgeInsets.only(
                    top: 80,
                  ), // উপরের বক্সটির জন্য জায়গা
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                  child: Column(
                    children: [
                      // মিডল সেকশন (লোগো এবং ইনফো)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          bool isMobile = constraints.maxWidth < 600;
                          return Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 40,
                            runSpacing: 30,
                            children: [
                              _buildFooterBrandInfo(isMobile),
                              _buildFooterLinks("Company", [
                                "About us",
                                "Services",
                                "Community",
                              ]),
                              _buildFooterLinks("Contact", [
                                "+880 19XXX",
                                "info@school.edu.bd",
                              ]),
                            ],
                          );
                        },
                      ),
                      xlminisectionGap(),

                      const Divider(color: Colors.black12),
                      const SizedBox(height: 15),
                      // বটম লাইন
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // ৩০০-৪০০ পিক্সেল স্ক্রিনে Row এর বদলে Column হবে যাতে লেখা ওভারল্যাপ না করে
                            bool isSmall = constraints.maxWidth < 500;

                            return isSmall
                                ? Column(
                                    // ছোট স্ক্রিনের জন্য
                                    children: [
                                      const Text(
                                        "© 2026 Tatulbaria High School",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 15,
                                        children: [
                                          _bottomLink("Privacy"),
                                          _bottomLink("Terms"),
                                          _bottomLink("Legal"),
                                        ],
                                      ),
                                    ],
                                  )
                                : Row(
                                    // বড় স্ক্রিনের জন্য
                                    children: [
                                      // বাম পাশের টেক্সট
                                      const Text(
                                        "© 2026 Tatulbaria High School. All rights reserved.",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),

                                      const Spacer(), // এটি বাম এবং ডানের মাঝে সবটুকু খালি জায়গা দখল করে নেবে
                                      // ডান পাশের তিনটি টেক্সট/লিঙ্ক
                                      _bottomLink("Privacy Policy"),
                                      const SizedBox(width: 20),
                                      _bottomLink("Terms of Use"),
                                      const SizedBox(width: 20),
                                      _bottomLink("Site Map"),
                                    ],
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 0,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 850),
                    child: MouseRegion(
                      onEnter: (_) =>
                          setState(() => _isSubscriptionHovered = true),
                      onExit: (_) =>
                          setState(() => _isSubscriptionHovered = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        width: MediaQuery.of(context).size.width * 0.92,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          // হোভার করলে গ্রাডিয়েন্ট উল্টে যাবে
                          gradient: LinearGradient(
                            colors: AppColors.subscriptionGradient.colors,
                            begin: _isSubscriptionHovered
                                ? Alignment.bottomRight
                                : Alignment.topLeft,
                            end: _isSubscriptionHovered
                                ? Alignment.topLeft
                                : Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              // হোভার করলে শ্যাডো আরও উজ্জ্বল হবে
                              color: const Color(
                                0xFF4A6CF7,
                              ).withOpacity(_isSubscriptionHovered ? 0.6 : 0.4),
                              blurRadius: _isSubscriptionHovered ? 35 : 25,
                              offset: Offset(
                                0,
                                _isSubscriptionHovered ? 15 : 10,
                              ),
                            ),
                          ],
                        ),
                        child: LayoutBuilder(
                          builder: (context, boxConstraints) {
                            bool isWide = boxConstraints.maxWidth > 600;

                            return Row(
                              children: [
                                // ১. বাম পাশের পোস্ট বক্স আইকন (মর্ডান ডিজাইন)
                                if (isWide)
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    padding: const EdgeInsets.all(20),
                                    margin: const EdgeInsets.only(right: 30),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(
                                        _isSubscriptionHovered ? 0.25 : 0.15,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    // হোভার করলে আইকনটি হালকা বড় হবে
                                    child: Transform.scale(
                                      scale: _isSubscriptionHovered ? 1.1 : 1.0,
                                      child: SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: Image.asset(
                                          'assets/road/mailbox.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),

                                // ২. ডান পাশের টেক্সট এবং ইনপুট ফিল্ড
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: isWide
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Subscribe to our newsletter for updates.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      // ইনপুট বক্স ডিজাইন
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          boxShadow: [
                                            if (_isSubscriptionHovered)
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                ),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Enter your email",
                                                    border: InputBorder.none,
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // সাবস্ক্রাইব বাটন
                                            AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: _isSubscriptionHovered
                                                    ? LinearGradient(
                                                        colors: [
                                                          AppColors.secondary,
                                                          Colors.orange,
                                                        ],
                                                      )
                                                    : null,
                                                color: _isSubscriptionHovered
                                                    ? null
                                                    : const Color(0xFF4A6CF7),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  foregroundColor: Colors.white,
                                                  shape: const StadiumBorder(),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 12,
                                                      ),
                                                ),
                                                child: const Text(
                                                  "Subscribe",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // ৪. এখানে CurvedNavigationBar বসাতে হবে
      // bottomNavigationBar: CurvedNavigationBar(
      //   index: _pageIndex,
      //   height: 65.0,
      //   items: const <Widget>[
      //     Icon(Icons.home, size: 30, color: Colors.purple),
      //     Icon(Icons.bar_chart, size: 30, color: Colors.purple),
      //     Icon(Icons.person, size: 30, color: Colors.purple),
      //   ],
      //   color: Colors.white,
      //   buttonBackgroundColor: Colors.white,
      //   backgroundColor: const Color(0xFFEFE5F5), // পেছনের ব্যাকগ্রাউন্ড (বডির সাথে মিলাতে পারেন)
      //   animationCurve: Curves.easeInOut,
      //   animationDuration: const Duration(milliseconds: 600),
      //   onTap: (index) {
      //     setState(() {
      //       _pageIndex = index; // বাটন ক্লিক করলে ইনডেক্স আপডেট হবে
      //     });
      //   },
      //   letIndexChange: (index) => true,
      // ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   index: _pageIndex,
      //   height: 70.0,
      //   items: <Widget>[
      //     _pageIndex == 0
      //         ? Image.asset(
      //             'assets/bottom/apartment.png', // আপনার ইমেজের সঠিক পাথ নিশ্চিত করুন
      //             width: 40,
      //             height: 40,
      //           )
      //         : Image.asset(
      //           'assets/bottom/apartment_0.png',
      //            width: 30,
      //            height: 30
      //         ),
      //     _pageIndex == 1
      //         ? Image.asset(
      //             'assets/bottom/about.png',
      //             width: 40,
      //             height: 40,
      //           )
      //         : Image.asset(
      //           'assets/bottom/about_1.png',
      //            width: 30,
      //            height: 30
      //         ),
      //     _pageIndex == 2
      //         ? Image.asset(
      //             'assets/bottom/teacher.png',
      //             width: 40,
      //             height: 40,
      //           )
      //         : Image.asset(
      //           'assets/bottom/teacher_1.png',
      //            width: 30,
      //            height: 30
      //         ),
      //     _pageIndex == 3
      //         ? Image.asset(
      //             'assets/bottom/notice.png',
      //             width: 40,
      //             height: 40,
      //           )
      //         : Image.asset(
      //           'assets/bottom/notice_1.png',
      //            width: 30,
      //            height: 30
      //         ),
      //     _pageIndex == 4
      //         ? Image.asset(
      //             'assets/bottom/academics.png',
      //             width: 40,
      //             height: 40,
      //           )
      //         : Image.asset(
      //           'assets/bottom/academics_1.png',
      //            width: 40,
      //            height: 40),
      //   ],
      //   color: AppColors.primary,
      //   buttonBackgroundColor: const html.Color.fromARGB(255, 219, 174, 246),
      //   backgroundColor: Colors.transparent,
      //   // backgroundColor: AppColors.background.withOpacity(0.0),

      //   // সংশোধিত অ্যানিমেশন কার্ভ
      //   animationCurve: Curves.easeInOutCubicEmphasized,

      //   animationDuration: const Duration(milliseconds: 500),
      //   onTap: (index) {
      //     setState(() {
      //       _pageIndex = index;
      //     });
      //   },
      // ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          // ✅ Screen Width
          double w = constraints.maxWidth;

          // ✅ Responsive sizes
          bool isMobile = w < 600;
          bool isTablet = w >= 600 && w < 1000;

          double activeSize = isMobile
              ? 34
              : isTablet
              ? 38
              : 42;
          double inactiveSize = isMobile
              ? 26
              : isTablet
              ? 30
              : 34;

          return CurvedNavigationBar(
            index: _pageIndex,
            height: isMobile ? 62 : 72,

            items: <Widget>[
              Image.asset(
                _pageIndex == 0
                    ? 'assets/bottom/apartment.png'
                    : 'assets/bottom/apartment_0.png',
                width: _pageIndex == 0 ? activeSize : inactiveSize,
                height: _pageIndex == 0 ? activeSize : inactiveSize,
              ),
              Image.asset(
                _pageIndex == 1
                    ? 'assets/bottom/about.png'
                    : 'assets/bottom/about_1.png',
                width: _pageIndex == 1 ? activeSize : inactiveSize,
                height: _pageIndex == 1 ? activeSize : inactiveSize,
              ),
              Image.asset(
                _pageIndex == 2
                    ? 'assets/bottom/teacher.png'
                    : 'assets/bottom/teacher_1.png',
                width: _pageIndex == 2 ? activeSize : inactiveSize,
                height: _pageIndex == 2 ? activeSize : inactiveSize,
              ),
              Image.asset(
                _pageIndex == 3
                    ? 'assets/bottom/notice.png'
                    : 'assets/bottom/notice_1.png',
                width: _pageIndex == 3 ? activeSize : inactiveSize,
                height: _pageIndex == 3 ? activeSize : inactiveSize,
              ),
              Image.asset(
                _pageIndex == 4
                    ? 'assets/bottom/academics.png'
                    : 'assets/bottom/academics_1.png',
                width: _pageIndex == 4 ? activeSize : inactiveSize,
                height: _pageIndex == 4 ? activeSize : inactiveSize,
              ),
            ],

            color: AppColors.primary,

            // ✅ Selected icon background responsive color (no html.Color)
            buttonBackgroundColor: const html.Color.fromARGB(
              255,
              174,
              239,
              246,
            ),

            // ✅ Background transparent
            backgroundColor: Colors.transparent,

            animationCurve: Curves.easeInOutCubicEmphasized,
            animationDuration: const Duration(milliseconds: 500),

            onTap: (index) {
              setState(() {
                _pageIndex = index;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildConnectedField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isActive,
    bool showLine = false,
    int maxLines = 1,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // কানেক্টিং লাইন এবং ডট লজিক
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: isActive ? Colors.indigo : Colors.grey.shade300,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              if (showLine)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 2,
                    color: isActive ? Colors.indigo : Colors.grey.shade200,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          // ইনপুট ফিল্ড
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  maxLines: maxLines,
                  onChanged: (value) {
                    setState(() {}); // এখানে setState এখন কাজ করবে
                  },
                  decoration: InputDecoration(
                    labelText: label,
                    prefixIcon: Icon(
                      icon,
                      color: isActive ? Colors.indigo : Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isActive
                        ? Colors.indigo.withOpacity(0.05)
                        : Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= NOTICE CAROUSEL WIDGET =================
/*
class NoticeCarousel extends StatefulWidget {
  final List<String> noticeImages;

  const NoticeCarousel({super.key, required this.noticeImages});

  @override
  State<NoticeCarousel> createState() => _NoticeCarouselState();
}
*/




class _NoticeCarouselState extends State<NoticeCarousel> {
  int currentIndex = 0;
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // PageView build হওয়ার পরে auto slide শুরু
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAutoSlide();
    });
  }

  void startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_pageController.hasClients) return;

      currentIndex = (currentIndex + 1) % widget.noticeImages.length;

      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Notice Image
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.noticeImages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final isWeb = MediaQuery.of(context).size.width > 900;
                  final double imagePadding = isWeb ? 24 : 10;
                  return AspectRatio(
                    aspectRatio: isWeb ? 16 / 6 : 16 / 8,
                    child: Padding(
                      padding: EdgeInsets.all(imagePadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          widget.noticeImages[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.noticeImages.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentIndex == index ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? Colors.indigo
                    : Colors.indigo.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ================= Helper Widget =================
Widget neighborImageWidget(
  String image,
  VoidCallback onTap, {
  double size = 50,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300]?.withOpacity(0.3),
      ),
      child: image != 'none'
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                image,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            )
          : null,
    ),
  );
}

class BannerInfo {
  final String mainImage;
  final String left;
  final String front;
  final String right;
  final String back;

  BannerInfo({
    required this.mainImage,
    this.left = 'none',
    this.front = 'none',
    this.right = 'none',
    this.back = 'none',
  });
}

// ================= COMMON WIDGETS =================

Widget sectionTitle(String title, String subtitle) {
  return Column(
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 6),
      if (subtitle != '') ...[
        Text(
          subtitle,
          style: const TextStyle(color: Colors.black54, fontSize: 16),
        ),
        const SizedBox(height: 30),
      ],
    ],
  );
}

Widget sectionGap() => const SizedBox(height: 80);
Widget minisectionGap() => const SizedBox(height: 30);
Widget xlminisectionGap() => const SizedBox(height: 20);

Widget grid(BuildContext context, List<Widget> children) {
  final width = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width > 900 ? 80 : 20),
    child: GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: width > 1100
          ? 4
          : width > 700
          ? 2
          : 1,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      children: children,
    ),
  );
}

Widget infoCard(IconData icon, String title, String desc) {
  return Card(
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 46, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    ),
  );
}

Widget _buildComplaintField({
  required String label,
  required String hint,
  required IconData icon,
  int maxLines = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.indigo, size: 20),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 1.5),
          ),
        ),
      ),
    ],
  );
}

Widget arrowBtn(IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      radius: 26,
      backgroundColor: Colors.black54,
      child: Icon(icon, color: Colors.white),
    ),
  );
}

// Widget _buildTeacherRowItem(String imagePath, String name, String role) {
//   return Container(
//     width: 150, // প্রতিটি শিক্ষকের আইটেমের প্রস্থ
//     margin: const EdgeInsets.symmetric(horizontal: 8),
//     padding: const EdgeInsets.all(8),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // শিক্ষকের ছবি
//         CircleAvatar(
//           radius: 40,
//           backgroundColor: Colors.indigo.withOpacity(0.1),
//           backgroundImage: AssetImage(imagePath), // অ্যাসেট ইমেজ
//           // যদি অ্যাসেট ইমেজ না থাকে, তাহলে একটি আইকন দেখানো যেতে পারে:
//           // child: Image.asset(imagePath, fit: BoxFit.cover),
//         ),
//         const SizedBox(height: 8),

//         // নাম
//         Text(
//           name,
//           textAlign: TextAlign.center,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//         ),
//         const SizedBox(height: 2),

//         // পদবী
//         Text(
//           role,
//           textAlign: TextAlign.center,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(color: Colors.indigo[400], fontSize: 11),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildTeacherRowItem(String imagePath, String name, String role) {
//   return Container(
//     width: 150, // প্রতিটি কার্ডের প্রস্থ
//     margin: const EdgeInsets.only(right: 16, left: 8, top: 10, bottom: 10),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 10,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//       children: [
//         // ওপরের অংশ - যেখানে কালার ডিজাইন থাকবে
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               height: 70,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF6A4BCF), // আপনার থিম কালার দিন
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                   bottomLeft: Radius.circular(50),
//                   bottomRight: Radius.circular(50),
//                 ),
//               ),
//             ),
//             // শিক্ষকের ছবি (CircleAvatar)
//             Container(
//               margin: const EdgeInsets.only(top: 30),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.white, width: 3),
//               ),
//               child: CircleAvatar(
//                 radius: 35,
//                 backgroundColor: Colors.grey[200],
//                 backgroundImage: AssetImage(imagePath),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         // শিক্ষকের নাম
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           child: Text(
//             name,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//               color: Color(0xFF2D2D2D),
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         const SizedBox(height: 4),
//         // পদবী
//         Text(
//           role,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildTeacherRowItem(String imagePath, String name, String role) {
//   return Container(
//     width: 160,
//     margin: const EdgeInsets.only(right: 18, left: 5, top: 10, bottom: 10),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(25),
//       boxShadow: [
//         BoxShadow(
//           color: const Color(0xFF6A4BCF).withOpacity(0.15),
//           blurRadius: 20,
//           offset: const Offset(0, 10),
//         ),
//       ],
//     ),
//     child: Stack(
//       clipBehavior: Clip.none,
//       children: [
//         // ১. উপরের গ্রাডিয়েন্ট শেপ
//         Container(
//           height: 90,
//           decoration: const BoxDecoration(
//             gradient: AppColors.subscriptionGradient,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(25),
//               topRight: Radius.circular(25),
//               bottomLeft: Radius.circular(15),
//               bottomRight: Radius.circular(60), // স্টাইলিশ কার্ভ
//             ),
//           ),
//         ),

//         // ২. কন্টেন্ট কলাম
//         Column(
//           children: [
//             const SizedBox(height: 45), // ইমেজকে উপরে ভাসিয়ে রাখার জন্য
//             // ৩. প্রফেশনাল বর্ডারসহ প্রোফাইল পিকচার
//             Center(
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
//                 ),
//                 child: CircleAvatar(
//                   radius: 40,
//                   backgroundImage: AssetImage(imagePath),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 12),

//             // ৪. নাম (Bold & Modern Font)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Text(
//                 name,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w900,
//                   fontSize: 15,
//                   color: Color(0xFF333333),
//                   letterSpacing: -0.5,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),

//             const SizedBox(height: 5),

//             // ৫. পদবী (Capsule Style)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF6A4BCF).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 role,
//                 style: const TextStyle(
//                   fontSize: 11,
//                   color: Color(0xFF4A00E0),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildTeacherRowItem(String imagePath, String name, String role) {
//   return Container(
//     width: 160,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(20),
//       gradient: const LinearGradient(
//         colors: [
//           Color(0xFF6A11CB), // Royal Purple/Indigo
//           Color(0xFF2575FC), // Professional Blue
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: const Color(0xFF2575FC).withOpacity(0.3),
//           blurRadius: 8,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // ছবির চারপাশে রিফ্লেকশন রিং
//         Container(
//           padding: const EdgeInsets.all(3),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
//           ),
//           child: CircleAvatar(
//             radius: 35,
//             backgroundColor: Colors.white24,
//             backgroundImage: AssetImage(imagePath),
//           ),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           name,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(height: 6),
//         // গ্লাস-মর্ফিজম ট্যাগ
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Text(
//             role,
//             style: const TextStyle(color: Colors.white70, fontSize: 10),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildTeacherRowItem(String imagePath, String name, String role) {
//   return Container(
//     width: 160,
//     margin: const EdgeInsets.only(right: 18, left: 5, top: 10, bottom: 10),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(25),
//       boxShadow: [
//         BoxShadow(
//           color: const Color(0xFF6A4BCF).withOpacity(0.15),
//           blurRadius: 20,
//           offset: const Offset(0, 10),
//         ),
//       ],
//     ),
//     child: Stack(
//       clipBehavior: Clip.none,
//       children: [
//         // ১. উপরের গ্রাডিয়েন্ট শেপ (স্টাইলিশ কার্ভ সহ)
//         Container(
//           height: 100,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF6A4BCF), Color(0xFF4A00E0)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(25),
//               topRight: Radius.circular(25),
//               bottomLeft: Radius.circular(15),
//               bottomRight: Radius.circular(60),
//             ),
//           ),
//         ),

//         // ২. কন্টেন্ট কলাম
//         Column(
//           children: [
//             const SizedBox(
//               height: 45,
//             ), // ইমেজকে গ্রাডিয়েন্টের উপরে ভাসিয়ে রাখার জন্য
//             // ৩. প্রফেশনাল বর্ডারসহ প্রোফাইল পিকচার
//             Center(
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 10,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: CircleAvatar(
//                   radius: 40,
//                   backgroundColor: Colors.grey[200],
//                   backgroundImage: AssetImage(imagePath),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 12),

//             // ৪. নাম
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Text(
//                 name,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w900,
//                   fontSize: 15,
//                   color: Color(0xFF333333),
//                   letterSpacing: -0.5,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),

//             const SizedBox(height: 8),

//             // ৫. পদবী (Capsule Style)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF6A4BCF).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 role,
//                 style: const TextStyle(
//                   fontSize: 11,
//                   color: Color(0xFF4A00E0),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

Widget _buildTeacherRowItem(
  BuildContext context,
  String imagePath,
  String name,
  String role,
) {
  // রেসপনসিভ উইথ নির্ধারণ (মোবাইলে স্ক্রিনের ৪২%, পিসিতে ১৮০)
  double screenWidth = MediaQuery.of(context).size.width;
  double cardWidth = screenWidth < 600 ? screenWidth * 0.42 : 180.0;

  return Container(
    width: cardWidth,
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6A4BCF).withOpacity(0.15),
          blurRadius: 20,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // ১. উপরের গ্রাডিয়েন্ট শেপ
        Container(
          height: 90,
          decoration: const BoxDecoration(
            gradient: AppColors.teacherCardGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(60),
            ),
          ),
        ),

        // ২. কন্টেন্ট কলাম
        Column(
          mainAxisSize:
              MainAxisSize.min, // কন্টেন্ট অনুযায়ী হাইট নিবে (অটো হাইট)
          children: [
            const SizedBox(height: 45),

            // ৩. প্রোফাইল পিকচার
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: screenWidth < 600 ? 35 : 40,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: AssetImage(imagePath),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ৪. নাম
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: screenWidth < 600 ? 13 : 15,
                  color: const Color(0xFF333333),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 8),

            // ৫. পদবী (নিচে গ্যাপসহ)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF6A4BCF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                role,
                style: TextStyle(
                  fontSize: screenWidth < 600 ? 9 : 11,
                  color: const Color(0xFF4A00E0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // এই লাইনটি পদবীকে কার্ডের নিচের বর্ডারের সাথে মিশে যেতে বাধা দিবে
            const SizedBox(height: 20),
          ],
        ),
      ],
    ),
  );
}

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw 'Could not launch $url';
  }
}

bool _isSubscriptionHovered = false;

// কন্ট্রোলারগুলো ডিফাইন করুন
final TextEditingController _nameController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
final TextEditingController _msgController = TextEditingController();

bool get isNameFilled => _nameController.text.isNotEmpty;
bool get isPhoneFilled => _phoneController.text.isNotEmpty;
bool get isMsgFilled => _msgController.text.isNotEmpty;
bool get isAllFilled => isNameFilled && isPhoneFilled && isMsgFilled;

// Widget _buildInfoCard({
//   required IconData icon,
//   required String text,
//   required Color color,
//   required bool isTiny,
// }) {
//   return Container(
//     padding: EdgeInsets.symmetric(vertical: 12, horizontal: isTiny ? 10 : 20),
//     decoration: BoxDecoration(
//       color: Colors.grey[100],
//       borderRadius: BorderRadius.circular(30),
//       border: Border.all(color: Colors.grey[300]!),
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.min, // টেক্সট অনুযায়ী বক্স ছোট হবে
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, size: isTiny ? 18 : 22, color: color),
//         const SizedBox(width: 10),
//         Flexible(
//           child: Text(
//             text,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: isTiny ? 12 : 15,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// class _buildHoverSocialButton extends StatefulWidget {
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;

//   const _buildHoverSocialButton({
//     super.key,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   State<_buildHoverSocialButton> createState() =>
//       _buildHoverSocialButtonState();
// }

// class _buildHoverSocialButtonState extends State<_buildHoverSocialButton> {
//   bool isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => isHovered = true),
//       onExit: (_) => setState(() => isHovered = false),
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: widget.onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: isHovered
//                     ? widget.color.withOpacity(0.4)
//                     : Colors.black.withOpacity(0.05),
//                 blurRadius: isHovered ? 15 : 8,
//                 offset: isHovered ? const Offset(0, 5) : const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Icon(widget.icon, color: widget.color, size: 28),
//         ),
//       ),
//     );
//   }
// }

class _buildResponsiveHoverButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double padding;
  final VoidCallback onTap;

  const _buildResponsiveHoverButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.padding,
    required this.onTap,
  });

  @override
  State<_buildResponsiveHoverButton> createState() =>
      _buildResponsiveHoverButtonState();
}

class _buildResponsiveHoverButtonState
    extends State<_buildResponsiveHoverButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(widget.padding),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? widget.color.withOpacity(0.4)
                    : Colors.black.withOpacity(0.05),
                blurRadius: isHovered ? 20 : 10,
                offset: isHovered ? const Offset(0, 8) : const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(widget.icon, color: widget.color, size: widget.size),
        ),
      ),
    );
  }
}

Widget _buildContactPill({
  required IconData icon,
  required String label,
  required double fontSize,
  required bool isMobile,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: isMobile ? 10 : 15,
      horizontal: isMobile ? 15 : 25,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(50),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: fontSize + 4, color: Colors.blueGrey),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}

// ব্র্যান্ড ইনফো (লোগো + বর্ণনা)
Widget _buildFooterBrandInfo(bool isMobile) {
  return SizedBox(
    width: 250,
    child: Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school, color: Colors.blue.shade700, size: 30),
            const SizedBox(width: 10),
            const Text(
              "THS College",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          "A thriving community where students learn, grow, and innovate together.",
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    ),
  );
}

// লিঙ্ক লিস্ট (Company/Contact)
Widget _buildFooterLinks(String title, List<String> links) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 15),
      ...links.map(
        (link) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            link,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ),
    ],
  );
}

Widget _bottomLink(String label) {
  return InkWell(
    onTap: () {}, // আপনার লিঙ্ক লজিক এখানে দিন
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}


// এই ক্লাসটি আপনার উইজেট ফাইলের সবার নিচে পেস্ট করুন
class AboutWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // ডিজাইন অনুযায়ী পাথ তৈরি
    path.lineTo(0, size.height); // বাম-নিচ কোণা

    // নিচ থেকে মাঝখান পর্যন্ত
    path.lineTo(size.width * 0.4, size.height);

    // সুন্দর একটি ঢেউ (Wave) তৈরি যা নিচ থেকে উপরের ডানে যাবে
    path.quadraticBezierTo(
      size.width * 0.75, // কন্ট্রোল পয়েন্ট X
      size.height * 0.95, // কন্ট্রোল পয়েন্ট Y
      size.width, // শেষ পয়েন্ট X (ডান পাশে)
      size.height * 0.2, // শেষ পয়েন্ট Y (উপরের দিকে)
    );

    path.lineTo(size.width, 0); // ডান-উপর কোণা
    path.lineTo(0, 0); // বাম-উপর কোণা
    path.close(); // পাথ বন্ধ করা

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
