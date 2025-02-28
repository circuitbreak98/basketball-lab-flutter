import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/general_board_model.dart';
import '../../services/base_report_service.dart';
import '../../services/general_board_service.dart';
import '../base/base_board_detail_view.dart';
import 'general_board_comment_view.dart';

class GeneralBoardDetailView extends BaseBoardDetailView<GeneralBoardModel> {
  GeneralBoardDetailView({super.key, required super.post});

  final GeneralBoardService _service = GeneralBoardService();

  @override
  Widget createCommentView(GeneralBoardModel post) => GeneralBoardCommentView(post: post);

  @override
  BaseReportService get reportService => _service;
} 