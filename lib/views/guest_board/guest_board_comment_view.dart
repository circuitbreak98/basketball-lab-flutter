import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/guest_board_model.dart';
import '../../services/base_comment_service.dart';
import '../../services/base_report_service.dart';
import '../../services/guest_board_service.dart';
import '../base/base_board_comment_view.dart';

class GuestBoardCommentView extends BaseBoardCommentView<GuestBoardModel> {
  const GuestBoardCommentView({super.key, required super.post});

  @override
  BaseBoardCommentViewState<GuestBoardModel> createState() => _GuestBoardCommentViewState();
}

class _GuestBoardCommentViewState extends BaseBoardCommentViewState<GuestBoardModel> {
  final GuestBoardService _service = GuestBoardService();

  @override
  BaseCommentService get service => _service;

  @override
  BaseReportService get reportService => _service;
} 