import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/general_board_model.dart';
import '../../repositories/general_board_repository.dart';
import '../base/base_board_list_view.dart';
import 'general_board_detail_view.dart';
import 'general_board_write_view.dart';

class GeneralBoardListView extends BaseBoardListView<GeneralBoardModel> {
  const GeneralBoardListView({super.key});

  @override
  BaseBoardListViewState<GeneralBoardModel> createState() => _GeneralBoardListViewState();
}

class _GeneralBoardListViewState extends BaseBoardListViewState<GeneralBoardModel> {
  final GeneralBoardRepository _repository = GeneralBoardRepository();

  @override
  GeneralBoardRepository get repository => _repository;

  @override
  String get boardTitle => AppConstants.generalBoardName;

  @override
  Widget Function(GeneralBoardModel) get createDetailView => 
      (post) => GeneralBoardDetailView(post: post);

  @override
  Widget createWriteView({required VoidCallback onPostCreated}) => 
      GeneralBoardWriteView(onPostCreated: onPostCreated);
} 