import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF25A3E4); // Deep Purple
  static const Color white = Color(0xFFFFFFFF); // Orange
  static const Color secondary = Color(0xFFFFA726); // Orange
  static const Color background = Color(0xFFF5F5F5); // Light Grey
  static const Color textDark = Color(0xFF212121); // Dark Text
  static const Color textLight = Color(0xFFFFFFFF); // White Text

  // নতুন গ্রাডিয়েন্ট প্রপার্টি
  static const LinearGradient subscriptionGradient = LinearGradient(
    colors: [
      Color(0xFF4A6CF7), // হালকা উজ্জ্বল নীল
      Color(0xFF1A7E7E), // আপনার দেওয়া কালার কোড (Opacity ছাড়া কনস্ট্যান্ট রাখা ভালো)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  // নতুন গ্রাডিয়েন্ট প্রপার্টি
  static const LinearGradient teacherCardGradient = LinearGradient(
  colors: [
    Color(0xFF6A11CB), // Deep Indigo
    Color(0xFF2575FC), // Royal Blue
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
}
