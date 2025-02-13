import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mogu_app/user/myPage/account_management_page/account_management_page_viewModel.dart';
import 'package:mogu_app/user/myPage/account_management_page/widgets/info_row.dart';
import 'package:provider/provider.dart';

class AccountManagementPage extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const AccountManagementPage({super.key, required this.userInfo});

  @override
  _AccountManagementPage createState() => _AccountManagementPage();
}

class _AccountManagementPage extends State<AccountManagementPage> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<AccountManagementPageViewModel>(context, listen: false);
    viewModel.initViewModel(widget.userInfo);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AccountManagementPageViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 돌아가기
          },
        ),
        title: Text(
          '계정관리',
          style: TextStyle(
            color: Color(0xFFFFD3F0),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InfoRow(
                title: '아이디',
                value: viewModel.model!.userId,
                showPasswordChangeDialog: () {
                  viewModel.showPasswordChangeDialog(context, widget.userInfo);
                }
              ),
              InfoRow(
                title: '비밀번호',
                value: viewModel.model!.password,
                showPasswordChangeDialog: () {
                  viewModel.showPasswordChangeDialog(context, widget.userInfo);
                },
                hasButton: true
              ),
              InfoRow(
                title: '이름',
                value: viewModel.model!.name,
                showPasswordChangeDialog: () {
                  viewModel.showPasswordChangeDialog(context, widget.userInfo);
                }
              ),
              InfoRow(
                title: '전화번호',
                value: viewModel.model!.phone,
                showPasswordChangeDialog: () {
                  viewModel.showPasswordChangeDialog(context, widget.userInfo);
                }
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    viewModel.showDeleteConfirmationDialog(context, widget.userInfo);
                  },
                  child: Text(
                    '회원탈퇴',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}