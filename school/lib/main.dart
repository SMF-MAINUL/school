import 'package:flutter/material.dart';
import 'package:tatulbaria_school_website/home/home_screen.dart';

void main() {
  runApp(const SchoolApp());
}


class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context,
      Widget child,
      ScrollableDetails details,
      ) {
    return child; //  no scrollbar
  }
}


class SchoolApp extends StatelessWidget {
  const SchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoScrollbarBehavior(), // add no scrollbar
      title: 'School',

      // ✅ GLOBAL TEXT SCALE CONTROL (BIG COMPANY STANDARD)
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: const TextScaler.linear(1.0), // clamp text size
          ),
          child: child!,
        );
      },

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade100,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff0066FF),
          primary: const Color(0xff0066FF),
          secondary: const Color(0xff00C853),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // ✅ DESIGN SYSTEM TEXT THEME
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ),

      home: const HomeScreen(),
      
    );
  }
}










/*
// main.dart
// PROFESSIONAL FLUTTER WEB DESIGN – SCHOOL PUBLIC WEBSITE
// Interactive Roadmap Style Home Page

import 'package:flutter/material.dart';

void main() {
  runApp(const SchoolWebApp());
}

class SchoolWebApp extends StatelessWidget {
  const SchoolWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ABC High School',
      theme: ThemeData(
        primaryColor: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xfff5f6fa),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

// ================= HOME PAGE =================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<String> roadImages = [
    'assets/road/image1.jpg',
    'assets/road/image1.jpg',
    'assets/road/image1.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ABC High School'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ----------- ROADMAP BANNER -----------
            Stack(
              children: [
                Container(
                  height: 420,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(roadImages[currentIndex]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // RIGHT ARROW
                if (currentIndex < roadImages.length - 1)
                  Positioned(
                    right: 20,
                    top: 180,
                    child: arrowButton(Icons.arrow_forward, () {
                      setState(() => currentIndex++);
                    }),
                  ),

                // LEFT ARROW
                if (currentIndex > 0)
                  Positioned(
                    left: 20,
                    top: 180,
                    child: arrowButton(Icons.arrow_back, () {
                      setState(() => currentIndex--);
                    }),
                  ),
              ],
            ),

            const SizedBox(height: 30),

            // ----------- MOTTO -----------
            const Text(
              'Education | Discipline | Humanity',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            // ----------- SECTIONS -----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 1,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  SectionCard(title: 'About School', icon: Icons.school),
                  SectionCard(title: 'Teachers', icon: Icons.people),
                  SectionCard(title: 'Notice Board', icon: Icons.notifications),
                  SectionCard(title: 'Events & Gallery', icon: Icons.photo_library),
                  SectionCard(title: 'Contact & Map', icon: Icons.map),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // ----------- FOOTER -----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.indigo,
              child: const Text(
                '© 2026 ABC High School | All Rights Reserved',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ARROW BUTTON =================
Widget arrowButton(IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      radius: 32,
      backgroundColor: Colors.black54,
      child: Icon(icon, color: Colors.white, size: 30),
    ),
  );
}

// ================= SECTION CARD =================
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.indigo),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
*/
