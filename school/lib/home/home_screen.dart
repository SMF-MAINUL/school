import 'dart:async';
import 'dart:ui' as html hide window;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/foundation.dart' show kIsWeb; // Web check করার জন্য
import 'package:tatulbaria_school_website/admition/admition_screen.dart';
import 'package:tatulbaria_school_website/app_color.dart';
import 'package:tatulbaria_school_website/teacher_list/teacher_list_screen.dart';
import 'dart:html' as html; // Web-এ link open করার জন্য
import 'package:url_launcher/url_launcher.dart';

import '../result/result_search_screen.dart'; // Mobile জন্য

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bannerIndex = 0;

  Future<void> openUrl(String url) async {
    if (kIsWeb) {
      // Web: open link in new tab
      html.window.open(url, '_blank');
    } else {
      // Mobile/Desktop
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
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
            sectionTitle(
              "আমাদের শিক্ষক মন্ডলী",
              "যোগ্য ও অভিজ্ঞ শিক্ষকমন্ডলীর তালিকা",
            ),

            Container(
              height: 200, // মোট কন্টেইনারের উচ্চতা
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(color: Colors.grey[100]!),
              ),
              child: Center(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // অনুভূমিক স্ক্রলিং
                  itemCount: 4, // আপাতত ৪ জন শিক্ষকের ডামি ডাটা
                  itemBuilder: (context, index) {
                    // এখানে ডামি ডাটা দেওয়া হয়েছে
                    List<String> names = [
                      "মোঃ আবদুর রহমান",
                      "সালেহা খাতুন",
                      "জহিরুল ইসলাম",
                      "ফাতেমা জান্নাত",
                    ];
                    List<String> roles = [
                      "প্রধান শিক্ষক",
                      "সহকারী প্রধান শিক্ষক",
                      "সিনিয়র শিক্ষক",
                      "সহকারী শিক্ষক",
                    ];
                    List<String> imagePaths = [
                      'assets/road/kairul.jpg', // আপনার শিক্ষকের ছবির পাথ এখানে দিন
                      'assets/road/kairul.jpg',
                      'assets/road/kairul.jpg',
                      'assets/road/kairul.jpg',
                    ];
                
                    return _buildTeacherRowItem(
                      imagePaths[index],
                      names[index],
                      roles[index],
                    );
                  },
                ),
              ),
            ),

            // ================= ABOUT =================
            sectionTitle("আমাদের সম্পর্কে", "কলেজ পরিচিতি ও লক্ষ্য"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: const Text(
                "ABC Public High School একটি সরকার অনুমোদিত শিক্ষা প্রতিষ্ঠান, যা শিক্ষার্থীদের সর্বোত্তম শিক্ষা প্রদানের জন্য আধুনিক পরিবেশ নিশ্চিত করেছে। দীর্ঘ শিক্ষাগত ঐতিহ্য এবং গৌরবময় ইতিহাসের সাথে, এই কলেজ শিক্ষার্থীদের মানসম্মত শিক্ষায় এগিয়ে নিয়ে যায়। আমাদের লক্ষ্য হলো শিক্ষার্থীদের শৃঙ্খলা, মানবিক গুণাবলী এবং সার্বিক বিকাশ নিশ্চিত করা। কলেজে আধুনিক ভবন, সজ্জিত ক্লাসরুম, উন্নত ল্যাবরেটরি, সমৃদ্ধ লাইব্রেরি এবং খেলাধুলার সুযোগসহ সমৃদ্ধ অবকাঠামো রয়েছে, যা শিক্ষার্থীদের একটি সম্পূর্ণ শিক্ষাগত অভিজ্ঞতা প্রদান করে। এখানে শিক্ষার্থীরা কেবলমাত্র জ্ঞান অর্জন করে না, বরং নৈতিকতা, দায়িত্ববোধ এবং সামাজিক দায়িত্বের চেতনা শেখে। আমাদের উদ্দেশ্য শিক্ষার্থীদের এমনভাবে গড়ে তোলা যাতে তারা ভবিষ্যতে সমাজের জন্য মূল্যবান নাগরিক হিসেবে নিজেকে প্রতিষ্ঠা করতে পারে।",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.7,
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            googleMapSection(context),
            sectionGap(),

            // ================= COMPLAINT BOX SECTION =================
            sectionTitle("অভিযোগ বক্স", "আপনার মতামত বা অভিযোগ আমাদের জানান"),

            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: Colors.indigo.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "আমরা আপনার মতামতকে গুরুত্ব দেই। যেকোনো সমস্যা বা পরামর্শ এখানে লিখুন।",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),

                  // নাম ইনপুট
                  _buildComplaintField(
                    label: "আপনার নাম",
                    hint: "আপনার পূর্ণ নাম লিখুন",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

                  // মোবাইল নম্বর ইনপুট
                  _buildComplaintField(
                    label: "মোবাইল নম্বর",
                    hint: "যোগাযোগের জন্য নম্বর দিন",
                    icon: Icons.phone_android_outlined,
                  ),
                  const SizedBox(height: 16),

                  // অভিযোগের বিষয়
                  _buildComplaintField(
                    label: "অভিযোগ/মতামত",
                    hint: "বিস্তারিত এখানে লিখুন...",
                    icon: Icons.edit_note_rounded,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),

                  // সাবমিট বাটন
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // এখানে ডাটা পাঠানোর লজিক হবে
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded),
                          SizedBox(width: 10),
                          Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= CONTACT SECTION =================
            sectionTitle("যোগাযোগ", "Contact"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50]!,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildContactItem(
                    Icons.location_on_rounded,
                    "ঠিকানা",
                    "Tatulbaria, Gangni, Meherpur",
                  ),
                  const Divider(height: 20),
                  _buildContactItem(
                    Icons.phone_iphone_rounded,
                    "ফোন",
                    "01XXXXXXXXX",
                  ),
                  const Divider(height: 20),
                  _buildContactItem(
                    Icons.email_outlined,
                    "ইমেইল",
                    "info@tatulbariaschool.edu.bd",
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 100,
            ), // নিচের ফুটারের জন্য যথেষ্ট ফাঁকা জায়গা
            // ================= FOOTER SECTION =================
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo,
                    AppColors.primary,
                  ], // প্রফেশনাল গ্রাডিয়েন্ট লুক
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.school, color: Colors.white70, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        "TATULBARIA HIGH SCHOOL",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "© 2026 Tatulbaria High School | All Rights Reserved",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Developed by School Management System",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // কন্টাক্ট আইটেম তৈরির জন্য হেল্পার ফাংশন
          ],
        ),
      ),
    );
  }
}

// ================= NOTICE CAROUSEL WIDGET =================
class NoticeCarousel extends StatefulWidget {
  final List<String> noticeImages;

  const NoticeCarousel({super.key, required this.noticeImages});

  @override
  State<NoticeCarousel> createState() => _NoticeCarouselState();
}

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
          Icon(icon, size: 46, color: Colors.indigo),
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



Widget _buildTeacherRowItem(String imagePath, String name, String role) {
  return Container(
    width: 150, // প্রতিটি শিক্ষকের আইটেমের প্রস্থ
    margin: const EdgeInsets.symmetric(horizontal: 8),
    padding: const EdgeInsets.all(8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // শিক্ষকের ছবি
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.indigo.withOpacity(0.1),
          backgroundImage: AssetImage(imagePath), // অ্যাসেট ইমেজ
          // যদি অ্যাসেট ইমেজ না থাকে, তাহলে একটি আইকন দেখানো যেতে পারে:
          // child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
        const SizedBox(height: 8),
        
        // নাম
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 2),
        
        // পদবী
        Text(
          role,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.indigo[400], fontSize: 11),
        ),
      ],
    ),
  );
}