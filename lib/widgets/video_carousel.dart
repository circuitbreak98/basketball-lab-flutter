import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/video_model.dart';
import '../constants/app_constants.dart';
import '../repositories/video_repository.dart';
import '../widgets/youtube_thumbnail.dart';

class VideoCarousel extends StatelessWidget {
  final VideoRepository _repository;
  
  VideoCarousel({Key? key, VideoRepository? repository}) : 
    _repository = repository ?? VideoRepository(),
    super(key: key);

  static final CarouselOptions _carouselOptions = CarouselOptions(
    height: 200.0,
    aspectRatio: 16/9,
    viewportFraction: 0.8,
    initialPage: 0,
    enableInfiniteScroll: true,
    reverse: false,
    autoPlay: true,
    autoPlayInterval: Duration(seconds: 3),
    autoPlayAnimationDuration: Duration(milliseconds: 800),
    autoPlayCurve: Curves.fastOutSlowIn,
    enlargeCenterPage: true,
    scrollDirection: Axis.horizontal,
  );

  Future<void> _launchVideo(String videoId) async {
    final url = Uri.parse('${AppConstants.youtubeWatchUrl}$videoId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<VideoModel>>(
      stream: _repository.getFeaturedVideosStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(AppConstants.errorLoadingMessage));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final videos = snapshot.data!;

        if (videos.isEmpty) {
          return Center(child: Text(AppConstants.noVideosMessage));
        }

        return CarouselSlider(
          options: _carouselOptions,
          items: videos.map((video) {
            return GestureDetector(
              onTap: () => _launchVideo(video.videoId),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    children: [
                      YouTubeThumbnail(
                        videoId: video.videoId,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            video.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
} 