import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
class Carouselimage extends StatefulWidget {
  final List<String> imageLinks;
  const Carouselimage({
    super.key,
    required this.imageLinks});

  @override
  State<Carouselimage> createState() => _CarouselimageState();
}

class _CarouselimageState extends State<Carouselimage> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(items: widget.imageLinks.map((link) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Image.network(
                    link,
                    fit: BoxFit.contain,));
              },
              ).toList(),
              options: CarouselOptions(
                height: 400,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            Row(
              children: widget.imageLinks.asMap().entries.map((e) {
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(_current == e.key ? 0.9 : 0)
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ],
    );
  }
}