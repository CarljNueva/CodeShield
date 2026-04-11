import 'package:flutter/material.dart';
import 'package:faker/faker.dart' hide Color, Image;

class CarouselItemData {
  final Color? color;
  final String? imagePath;
  final String? videoPath;
  final String title;
  final String? subtitle;
  final String details;
  String? _extraDetails;

  static const String assertMsg =
      "'CarouselItemData' must have at least a color, imagePath, or videoPath.";

  CarouselItemData({
    this.color,
    this.imagePath,
    this.videoPath,
    required this.title,
    this.subtitle,
    required this.details,
    String? extraDetails,
  }) : _extraDetails = extraDetails,
       assert(
         color != null || imagePath != null || videoPath != null,
         assertMsg,
       );

  String get extraDetails {
    _extraDetails ??= faker.lorem.sentences(30).join(" ");
    return _extraDetails!;
  }

  set extraDetails(String? value) => _extraDetails = value;

  String getAllDetails() => "$details\n$extraDetails";
}
