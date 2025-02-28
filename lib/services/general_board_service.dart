import 'base_comment_service.dart';
import 'base_report_service.dart';

class GeneralBoardService extends BaseCommentService with BaseReportService {
  @override
  String get collectionPath => "categories/general_board/posts";
} 