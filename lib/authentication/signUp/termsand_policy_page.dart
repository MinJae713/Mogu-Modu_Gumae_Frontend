import 'package:flutter/material.dart';
import 'package:mogu_app/authentication/signUp/sign_up_page.dart';

class TermsandPolicyPage extends StatefulWidget {
  const TermsandPolicyPage({super.key});

  @override
  _TermsandPolicyPageState createState() => _TermsandPolicyPageState();
}

class _TermsandPolicyPageState extends State<TermsandPolicyPage> {
  List<bool> _isChecked = List.generate(5, (_) => false);
  bool get _buttonActive =>
      _isChecked.sublist(1, 4).every((element) => element);

  void _updateCheckState(int index, bool? value) {
    setState(() {
      if (index == 0) {
        bool isAllChecked = !_isChecked.every((element) => element);
        _isChecked = List.generate(5, (i) => isAllChecked);
      } else {
        _isChecked[index] = value ?? false;
        bool allChecked = _isChecked.sublist(1, 5).every((element) => element);
        _isChecked[0] = allChecked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.all(20),
                  child: Text.rich(
                    TextSpan(children: const [
                      TextSpan(
                        text: '안녕하세요!\n',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: '약관동의',
                        style: TextStyle(
                          color: Color(0xFF9932CC),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: '가 필요해요',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.5, // 줄 간격 조정
                        ),
                      ),
                    ]),
                  )),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                          BorderSide(width: 1, color: Color(0xFF908D8D)),
                        ),
                      ),
                      child: _buildCheckboxWithText(
                          '전체동의',
                          _isChecked[0],
                              (value) => _updateCheckState(0, value),
                          Color(0xFF9932CC)),
                    ),
                    const SizedBox(height: 13),
                    _buildCheckboxWithText('[필수] 모구 이용 약관 동의', _isChecked[1],
                            (value) => _updateCheckState(1, value), Colors.black),
                    _buildCheckboxWithText('[필수] 개인정보 처리 방침 동의', _isChecked[2],
                            (value) => _updateCheckState(2, value), Colors.black),
                    _buildCheckboxWithText(
                        '[필수] 개인정보 제 3자 제공 동의',
                        _isChecked[3],
                            (value) => _updateCheckState(3, value),
                        Colors.black),
                    _buildCheckboxWithText('[선택] 광고, 혜택 수신 동의', _isChecked[4],
                            (value) => _updateCheckState(4, value), Colors.black),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                    _buttonActive ? Color(0xFFB34FD1) : Colors.grey,
                    minimumSize: Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _buttonActive
                      ? () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SignUpPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0); // 오른쪽에서 시작
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  }
                      : null,
                  child: Text(
                    '동의하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 13),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxWithText(String text, bool isChecked,
      ValueChanged<bool?> onChanged, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17.0),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              checkColor: Color(0xFFB34FD1),
              fillColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return Colors.transparent; // 체크박스 배경색을 투명하게 설정
                },
              ),
              value: isChecked,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}