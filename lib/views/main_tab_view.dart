import 'package:flutter/material.dart';
import 'post/post_list_view.dart';
import 'profile/profile_view.dart';
import '../widgets/video_carousel.dart';

class MainTabView extends StatelessWidget {
  const MainTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Basketball Lab'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            const VideoCarousel(),
            const SizedBox(height: 16),
            const Expanded(
              child: TabBarView(
                children: [
                  PostListView(),
                  ProfileView(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).primaryColor,
          child: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Posts'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
} 