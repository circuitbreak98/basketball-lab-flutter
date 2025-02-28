import 'base_comment_service.dart';
import 'base_report_service.dart';

class GuestBoardService extends BaseCommentService with BaseReportService {
  @override
  String get collectionPath => "categories/guest_board/posts";
} 