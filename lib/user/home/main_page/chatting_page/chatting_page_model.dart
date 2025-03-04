
class ChattingPageModel {
  final List<Map<String, String>> chatItems = List.generate(
    5,
        (index) => {
      'title': '그럼 명지대학교에서 봐유우',
      'time': '오후 9시 13분',
    },
  );
  String _selectedChatFilter = '전체';
  String getChatFilter() {
    return _selectedChatFilter;
  }
  void setChatFilter(String label) {
    _selectedChatFilter = label;
  }
}