class AppConstants {
  // Board Types
  static const String generalBoard = 'general_board';
  static const String guestBoard = 'guest_board';

  // Collection Paths
  static const String categoriesPath = 'categories';
  static const String postsPath = 'posts';
  static const String commentsPath = 'comments';
  static const String reportsPath = 'reports';
  static const String adminsPath = 'admins';
  static const String featuredVideosPath = 'featured_videos';

  // Firebase Field Names
  static const String dateCreatedField = 'dateCreated';
  static const String authorField = 'author';
  static const String titleField = 'title';
  static const String textField = 'text';
  static const String commentCountField = 'commentCount';
  static const String isResolvedField = 'isResolved';
  static const String videoDescriptionField = 'description';
  static const String videoIdField = 'videoId';

  // Error Messages
  static const String accessDeniedMessage = '접근이 거부되었습니다';
  static const String errorLoadingMessage = '오류가 발생했습니다';
  static const String noDataAvailableMessage = '데이터가 없습니다';

  // Form Validation Messages
  static const String postRequiredMessage = '제목과 내용을 입력해주세요';
  static const String videoRequiredMessage = '제목과 영상 ID를 입력해주세요';

  // Success Messages
  static const String reportSuccessMessage = '신고가 접수되었습니다';
  static const String postSuccessMessage = '게시글이 등록되었습니다';
  static const String commentSuccessMessage = '댓글이 등록되었습니다';
  static const String deleteSuccessMessage = '삭제되었습니다';
  static const String videoAddedMessage = '영상이 추가되었습니다';
  static const String videoDeletedMessage = '영상이 삭제되었습니다';

  // Empty State Messages
  static const String noVideosMessage = '등록된 영상이 없습니다';
  static const String noPostsMessage = '등록된 게시글이 없습니다';
  static const String noCommentsMessage = '등록된 댓글이 없습니다';
  static const String noReportedContent = '신고된 콘텐츠가 없습니다';

  // Navigation Text
  static const String boardTabLabel = '게시판';
  static const String profileTabLabel = '프로필';
  static const String appTitle = '농구연구소';

  // Board Names
  static const String generalBoardName = '자유게시판';
  static const String guestBoardName = '게스트 모집';

  // Post Related Text
  static const String writePostTitle = '게시글 작성';
  static const String postTitleLabel = '제목';
  static const String postContentLabel = '내용';
  static const String writeButtonLabel = '작성하기';
  static const String authorLabel = '작성자: ';

  // Comment Related Text
  static const String commentsTitle = '댓글';
  static const String writeCommentHint = '댓글을 작성해주세요...';
  static const String commentCountLabel = '댓글 수: ';

  // Video Related Text
  static const String videoManagementTitle = '영상 관리';
  static const String videoTitleLabel = '영상 제목';
  static const String videoIdLabel = '유튜브 영상 ID';
  static const String videoIdHelper = '예시: dQw4w9WgXcQ (유튜브 URL에서)';
  static const String videoDescriptionLabel = '설명';
  static const String videoAddButtonLabel = '영상 추가';
  static const String videoLoadErrorMessage = '영상을 불러오는 중 오류가 발생했습니다';

  // Report Related Text
  static const String reportPostTitle = '게시글 신고';
  static const String reportCommentTitle = '댓글 신고';
  static const String reportReasonLabel = '신고 사유';
  static const String reportReasonHint = '신고하시는 이유를 설명해주세요';
  static const String cancelButtonLabel = '취소';
  static const String reportButtonLabel = '신고';
  static const String reportedContentTitle = '신고된 콘텐츠';
  static const String reportedTypeLabel = '신고된 ';
  static const String reasonLabel = '사유: ';
  static const String contentLabel = '내용: ';

  // Date Related Text
  static const String dateLabel = '작성일: ';
  static const String reportDateLabel = '신고일: ';
  static const String dateFormatPattern = 'yyyy-MM-dd';
  static const String noDateText = '날짜 없음';

  // Action Tooltips
  static const String writePostTooltip = '게시글 작성';
  static const String viewPostTooltip = '게시글 보기';
  static const String reportPostTooltip = '게시글 신고';
  static const String sendCommentTooltip = '댓글 작성';
  static const String reportCommentTooltip = '댓글 신고';
  static const String videoDeleteTooltip = '영상 삭제';
  static const String viewContentTooltip = '내용 보기';
  static const String resolveReportTooltip = '해결 완료';
  static const String commentCountTooltip = '댓글 수';

  // YouTube Related
  static const String youtubeWatchUrl = 'https://www.youtube.com/watch?v=';
  static const String youtubeThumbnailUrl = 'https://img.youtube.com/vi/';
  static const String youtubeThumbnailQuality = 'maxresdefault.jpg';
} 