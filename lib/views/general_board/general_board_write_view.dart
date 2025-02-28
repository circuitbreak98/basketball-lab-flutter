import 'package:flutter/material.dart';
import '../../models/general_board_model.dart';
import '../../repositories/general_board_repository.dart';
import '../base/base_board_write_view.dart';

class GeneralBoardWriteView extends BaseBoardWriteView<GeneralBoardModel> {
  const GeneralBoardWriteView({super.key, super.onPostCreated});

  @override
  BaseBoardWriteViewState<GeneralBoardModel> createState() => _GeneralBoardWriteViewState();
}

class _GeneralBoardWriteViewState extends BaseBoardWriteViewState<GeneralBoardModel> {
  final GeneralBoardRepository _repository = GeneralBoardRepository();

  @override
  GeneralBoardRepository get repository => _repository;
} 