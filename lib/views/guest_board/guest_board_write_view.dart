import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/guest_board_model.dart';
import '../../repositories/guest_board_repository.dart';
import '../base/base_board_write_view.dart';

class GuestBoardWriteView extends BaseBoardWriteView<GuestBoardModel> {
  const GuestBoardWriteView({super.key, super.onPostCreated});

  @override
  BaseBoardWriteViewState<GuestBoardModel> createState() => _GuestBoardWriteViewState();
}

class _GuestBoardWriteViewState extends BaseBoardWriteViewState<GuestBoardModel> {
  final GuestBoardRepository _repository = GuestBoardRepository();

  @override
  GuestBoardRepository get repository => _repository;
} 