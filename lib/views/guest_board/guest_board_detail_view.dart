import 'package:flutter/material.dart';
import '../../models/guest_board_model.dart';
import '../../services/base_report_service.dart';
import '../../services/guest_board_service.dart';
import '../base/base_board_detail_view.dart';
import 'guest_board_comment_view.dart';

class GuestBoardDetailView extends BaseBoardDetailView<GuestBoardModel> {
  GuestBoardDetailView({super.key, required super.post});

  final GuestBoardService _service = GuestBoardService();

  @override
  Widget createCommentView(GuestBoardModel post) => GuestBoardCommentView(post: post);

  @override
  BaseReportService get reportService => _service;
} 