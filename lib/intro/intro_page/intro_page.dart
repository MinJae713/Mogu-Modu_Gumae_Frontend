import 'package:flutter/material.dart';
import 'package:mogu_app/authentication/signUp/termsand_policy_page.dart';
import 'package:mogu_app/intro/intro_page/widgets/intro_page_button.dart';
import '../../authentication/signIn/login_page.dart';
import '../../authentication/signIn/social_login_page.dart'; // 추가

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: screenWidth,
                        height: screenHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.71, -0.71),
                            end: Alignment(-0.71, 0.71),
                            colors: const [Color(0xFFFFA7E1), Color(0xB29322CC)],
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.05,
                        top: screenHeight * 0.55,
                        child: SizedBox(
                          width: screenWidth * 0.9,
                          child: Column(
                            children: [
                              IntroPageButton(
                                text: '구글로 로그인',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          SocialLoginPage(), // SocialLoginPage로 이동
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
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              IntroPageButton(
                                text: '이메일로 로그인하기',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          LoginPage(),
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
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          TermsandPolicyPage(),
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
                                },
                                child: Text(
                                  '회원가입하기',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: (screenWidth - 113) / 2,
                        top: screenHeight * 0.3,
                        child: SizedBox(
                          width: 113,
                          height: 104,
                          child: Image.asset(
                            'assets/Mogulogo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}