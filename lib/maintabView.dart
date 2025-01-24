import 'package:basketball_lab_flutter/profileView.dart';
import 'package:basketball_lab_flutter/postListView.dart';
import 'package:flutter/material.dart';

class MainTabView extends StatelessWidget {
  const MainTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // We have two tabs: Posts and Profile
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Main Tab View'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Posts'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // 1) The existing PostListView
            PostListView(),
            // 2) The placeholder MyProfileView
            ProfileView(),
          ],
        ),
      ),
    );
  }
}
