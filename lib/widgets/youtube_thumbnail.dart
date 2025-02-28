import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class YouTubeThumbnail extends StatelessWidget {
  final String videoId;
  final BoxFit fit;
  final double? width;
  final double? height;

  const YouTubeThumbnail({
    Key? key,
    required this.videoId,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      '${AppConstants.youtubeThumbnailUrl}$videoId/${AppConstants.youtubeThumbnailQuality}',
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
} 