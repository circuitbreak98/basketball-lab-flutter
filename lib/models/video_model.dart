class VideoModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoId;
  final String description;

  VideoModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoId,
    required this.description,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json, String id) {
    return VideoModel(
      id: id,
      title: json['title'] ?? '',
      thumbnailUrl: 'https://img.youtube.com/vi/${json['videoId']}/maxresdefault.jpg',
      videoId: json['videoId'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'videoId': videoId,
      'description': description,
    };
  }
} 