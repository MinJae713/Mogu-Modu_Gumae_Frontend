import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mogu_app/admin/home/main_page/bottom/home_page_bottom_FA.dart';
import 'package:mogu_app/admin/home/main_page/common/search_results.dart';
import 'package:mogu_app/admin/home/main_page/complaint_management_page/inquiry_list.dart';
import 'package:mogu_app/admin/home/main_page/complaint_management_page/notice_list.dart';

import '../../../complaint/notice_create_page.dart';

class ComplaintManagementPage extends StatefulWidget {
  const ComplaintManagementPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ComplaintManagementPage();
  }
}

class _ComplaintManagementPage extends State<ComplaintManagementPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSort = '';

  @override
  void initState() {
    super.initState();
    if (_tabController == null) {
      _tabController = TabController(length: 3, vsync: this);
      _tabController?.addListener(() {
        setState(() {}); // 탭 변경 시 상태 업데이트
      });
      _selectedSort = _tabController?.index == 1 ?
        '신고 많은 순' : '최신순';
    }
    setState(() {
      _searchQuery = '';
      _selectedSort = _tabController?.index == 1 ? // 이게 좀 관건이누
        '신고 많은 순' : '최신순';
    });
  }

  // 원래 코드 - 민원관리 클릭 시 selectedSort 이거 신고 많은 순이 지정이 안되서 일단 남김유
  // bottomTab 누를 때 _tabController가 인스턴스가 초기화되서 그런듯유
  // 위에 if문 민원 관리 탭 누를 때 무조건 실행됨유
  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 3, vsync: this);
  //   _tabController?.addListener(() {
  //     setState(() {}); // 탭 변경 시 상태 업데이트
  //   });
  //   _selectedSort = _getInitialSortValue(); // 초기 정렬 값 설정
  // }
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //     _searchQuery = ''; // 탭을 변경할 때 검색어 초기화
  //     _selectedSort = _getInitialSortValue(); // 탭 변경 시 기본 정렬 옵션 설정
  //   });
  // }
  // String _getInitialSortValue() {
  //   if (_selectedIndex == 0) {
  //     return '최신순';
  //   } else if (_selectedIndex == 1) {
  //     return '신고 많은 순';
  //   } else if (_selectedIndex == 2 && _tabController?.index == 1) {
  //     return '신고 많은 순';
  //   } else {
  //     return '최신순';
  //   }
  // }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropdownOptions = _tabController?.index == 1 ?
      ['신고 많은 순', '최신순'] : ['최신순'];
    if (!dropdownOptions.contains(_selectedSort)) {
      _selectedSort = dropdownOptions.first;
    }
    SearchResults searchResults = SearchResults();
    InquiryList inquiryList = InquiryList();
    NoticeList noticeList = NoticeList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.reorder),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            print('Reorder button pressed');
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 30, // 검색창의 높이
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFFFBDE9),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          isDense: true,
                        ),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      splashColor: Colors.white.withOpacity(0.3), // 물결 효과 색상
                      onTap: () {
                        setState(() {
                          _searchQuery = _searchController.text;
                        });
                      },
                      child: Icon(
                        Icons.search,
                        color: Color(0xFFFFD3F0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.68, -0.73),
              end: Alignment(-0.68, 0.73),
              colors: const [Color(0xFFFFA7E1), Color(0xB29322CC)],
            ),
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            color: Colors.white, // 탭 배경색을 흰색으로 설정
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xFFB34FD1), // 선택된 탭의 글자 색상 (보라색)
              unselectedLabelColor: Colors.grey, // 선택되지 않은 탭의 글자 색상 (회색)
              indicatorColor: Color(0xFFB34FD1), // 선택된 탭의 하단 인디케이터 색상 (보라색)
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab, // 인디케이터 길이를 탭 전체로 설정
              tabs: const [
                Tab(text: '문의'),
                Tab(text: '신고'),
                Tab(text: '공지'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 110, // 드롭다운의 고정된 너비를 설정
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSort,
                    items: dropdownOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              value,
                              style: TextStyle(
                                color: Color(0xFFB34FD1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSort = newValue!;
                      });
                    },
                    style: TextStyle(color: Colors.purple), // 글자 색상
                    dropdownColor: Colors.white, // 드롭다운 배경색
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFFB34FD1)), // 기본 화살표 아이콘 추가
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _tabController?.index == 0
                ? ListView(
              padding: EdgeInsets.all(8),
              children: inquiryList.build(_searchQuery),
            )
                : _tabController?.index == 1
                ? ListView(
              padding: EdgeInsets.all(8),
              children: searchResults.build(_searchQuery),
            )
                : _tabController?.index == 2
                ? ListView(
              padding: EdgeInsets.all(8),
              children: noticeList.build(_searchQuery),
            )
                : TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text('문의 내용 표시')),
                Center(child: Text('신고 내용 표시')),
                Center(child: Text('공지 내용 표시')),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: _tabController?.index == 2 ?
      ClipOval(
        child: Material(
          color: Colors.white.withOpacity(0.1), // 버튼 배경색을 약간 불투명하게 설정
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.3), // 물결 효과 색상
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoticeCreatePage(),
                ), // PostCreatePage로 이동
              );
            },
            child: SizedBox(
              width: 56,
              height: 56,
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/post_create_button.svg",
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
      )
          : null,
      bottomNavigationBar: HomePageBottomFA(selectedIndex: 2),
    );
  }
}