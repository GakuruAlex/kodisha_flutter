import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ReusableCarousel<T> extends StatelessWidget {
  const ReusableCarousel({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.heightFactor = 0.5,
    this.autoPlay = true,
    this.enlargeCenterPage = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.viewportFractionSingle = 0.9,
    this.viewportFractionMultiple = 0.75,
    this.enableInfiniteScroll = true,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  final double heightFactor;
  final bool autoPlay;
  final bool enlargeCenterPage;
  final EdgeInsets padding;
  final double viewportFractionSingle;
  final double viewportFractionMultiple;
  final bool enableInfiniteScroll;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final height = MediaQuery.of(context).size.height * heightFactor;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: items.length,
        itemBuilder: (context, index, realIndex) {
          final item = items[index];

          return Padding(
            padding: padding,
            child: itemBuilder(context, item, index),
          );
        },
        options: CarouselOptions(
          height: height,
          enlargeCenterPage: enlargeCenterPage,
          viewportFraction: items.length == 1
              ? viewportFractionSingle
              : viewportFractionMultiple,
          enableInfiniteScroll:
              items.length > 1 && enableInfiniteScroll,
          autoPlay: autoPlay && items.length > 1,
          scrollDirection: Axis.horizontal,
          padEnds: true,
        ),
      ),
    );
  }
}