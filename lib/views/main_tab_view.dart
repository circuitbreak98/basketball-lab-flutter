import 'package:flutter/material.dart';
import 'general_board/general_board_list_view.dart';
import 'profile/profile_view.dart';
import '../widgets/video_carousel.dart';
import 'guest_board/guest_board_list_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({Key? key}) : super(key: key);

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  String _selectedBoard = 'general_board';

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
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'general_board',
                  label: Text('General Board'),
                ),
                ButtonSegment(
                  value: 'guest_board',
                  label: Text('Guest Board'),
                ),
              ],
              selected: {_selectedBoard},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedBoard = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  _selectedBoard == 'general_board'
                      ? const GeneralBoardListView()
                      : const GuestBoardListView(),
                  const ProfileView(),
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