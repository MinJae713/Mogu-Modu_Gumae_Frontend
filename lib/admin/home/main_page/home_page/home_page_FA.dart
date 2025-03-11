import 'package:flutter/material.dart';
import 'package:mogu_app/admin/home/main_page/common/search_results.dart';

class HomeMainPageFA extends StatefulWidget {
  const HomeMainPageFA({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageFA();
  }
}

class _HomePageFA extends State<HomeMainPageFA> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSort = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _searchQuery = '';
      _selectedSort = '최신순';
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropdownOptions = ['최신순', '조회수 높은순'];
    if (!dropdownOptions.contains(_selectedSort)) {
      _selectedSort = dropdownOptions.first;
    }
    SearchResults searchResults = SearchResults();
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
            child: ListView(
              padding: EdgeInsets.all(8),
              children: searchResults.build(_searchQuery),
            )
          )
        ],
      ),
    );
  }
}