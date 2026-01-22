import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NoticeCarousel extends StatefulWidget {
  final List<String> noticeImages;
  final bool isNetwork;

  const NoticeCarousel({
    super.key,
    required this.noticeImages,
    this.isNetwork = false,
  });

  @override
  State<NoticeCarousel> createState() => _NoticeCarouselState();
}

class _NoticeCarouselState extends State<NoticeCarousel> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        viewportFraction: 1,
        enlargeCenterPage: false,
      ),
      items: widget.noticeImages.map((img) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: widget.isNetwork
              ? Image.network(
            img,
            width: double.infinity,
            fit: BoxFit.cover,
          )
              : Image.asset(
            img,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }
}
