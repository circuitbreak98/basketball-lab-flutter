import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/general_board_model.dart';
import '../../services/base_comment_service.dart';
import '../../services/base_report_service.dart';
import '../../services/general_board_service.dart';
import '../base/base_board_comment_view.dart';

class GeneralBoardCommentView extends BaseBoardCommentView<GeneralBoardModel> {
  const GeneralBoardCommentView({super.key, required super.post});

  @override
  BaseBoardCommentViewState<GeneralBoardModel> createState() => _GeneralBoardCommentViewState();
}

class _GeneralBoardCommentViewState extends BaseBoardCommentViewState<GeneralBoardModel> {
  final GeneralBoardService _service = GeneralBoardService();

  @override
  BaseCommentService get service => _service;

  @override
  BaseReportService get reportService => _service;
} 