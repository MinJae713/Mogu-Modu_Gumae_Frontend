import 'package:flutter/material.dart';
import 'package:mogu_app/user/myPage/update_profile_page/update_profile_page_viewModel.dart';
import 'package:provider/provider.dart';

class UpdateProfilePage extends StatefulWidget {
  final String userId;
  final String nickname;
  final String profileImage;
  final double longitude;
  final double latitude;
  final String token;

  const UpdateProfilePage({
    super.key,
    required this.userId,
    required this.nickname,
    required this.profileImage,
    required this.longitude,
    required this.latitude,
    required this.token,
  });

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<UpdateProfilePageViewModel>(context, listen: false);
    viewModel.initViewModel(
      widget.nickname,
      widget.profileImage,
      widget.latitude,
      widget.longitude
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UpdateProfilePageViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Color(0xFFFFE9F8),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '프로필 수정',
          style: TextStyle(
            color: Color(0xFFFFE9F8),
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
        child: viewModel.address == null
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFB34FD1),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: viewModel.newProfileImage != null
                            ? FileImage(viewModel.newProfileImage!)
                            : (viewModel.profileImageUrl.isNotEmpty
                            ? NetworkImage(viewModel.profileImageUrl) as ImageProvider
                            : null),
                        child: viewModel.profileImageUrl.isEmpty
                            && viewModel.newProfileImage == null
                            ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                            : null,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: viewModel.pickImage,
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Color(0xFFB34FD1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      viewModel.editNickname(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                viewModel.nickname,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.edit,
                            color: Color(0xFFB34FD1),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: TextEditingController(text: viewModel.address),
              readOnly: true,
              decoration: InputDecoration(
                labelText: '주소',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.edit_location, color: Color(0xFFB34FD1)),
                  onPressed: () {
                    viewModel.openMapAndSelectLocation(context);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                viewModel.updateUser(
                  context,
                  widget.nickname,
                  widget.latitude,
                  widget.longitude,
                  widget.token
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text('수정 완료'),
            ),
          ],
        ),
      ),
    );
  }
}