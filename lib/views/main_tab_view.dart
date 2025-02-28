import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'general_board/general_board_list_view.dart';
import 'guest_board/guest_board_list_view.dart';
import 'profile/profile_view.dart';
import '../widgets/video_carousel.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({Key? key}) : super(key: key);

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  String _selectedBoard = AppConstants.generalBoard;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.appTitle),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            VideoCarousel(),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: AppConstants.generalBoard,
                  label: Text(AppConstants.generalBoardName),
                ),
                ButtonSegment(
                  value: AppConstants.guestBoard,
                  label: Text(AppConstants.guestBoardName),
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
                  _selectedBoard == AppConstants.generalBoard
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
              Tab(icon: Icon(Icons.list), text: AppConstants.boardTabLabel),
              Tab(icon: Icon(Icons.person), text: AppConstants.profileTabLabel),
            ],
          ),
        ),
      ),
    );
  }
} 