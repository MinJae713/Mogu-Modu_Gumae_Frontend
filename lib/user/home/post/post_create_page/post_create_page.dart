import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mogu_app/user/home/post/post_create_page/post_create_page_viewModel.dart';
import 'package:mogu_app/user/home/post/post_create_page/widgets/detail_row.dart';
import 'package:mogu_app/user/home/post/post_create_page/widgets/person_input_row.dart';
import 'package:mogu_app/user/home/post/post_create_page/widgets/price_input_row.dart';
import 'package:mogu_app/user/home/post/post_create_page/widgets/share_condition_row.dart';
import 'package:provider/provider.dart';

class PostCreatePage extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const PostCreatePage({super.key, required this.userInfo});

  @override
  _PostCreatePageState createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<PostCreatePageViewModel>(context, listen: false);
    viewModel.initViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PostCreatePageViewModel>(context);
    if (!viewModel.isInitialized)
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            Navigator.pop(context);
          },
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
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '제목',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: viewModel.model.titleController,
                  focusNode: viewModel.model.titleFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(viewModel.model.contentFocusNode);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: viewModel.model.isTitleValid ? null : "제목을 입력하세요",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB34FD1)),
                    ),
                  ),
                  cursorColor: Color(0xFFB34FD1),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내용',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: viewModel.model.contentController,
                  focusNode: viewModel.model.contentFocusNode,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: viewModel.model.isContentValid ? null : "내용을 입력하세요",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB34FD1)),
                    ),
                  ),
                  cursorColor: Color(0xFFB34FD1),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('사진등록', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                GestureDetector(
                  onTap: () => viewModel.pickImage(context),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 40),
                        SizedBox(height: 4),
                        Text('${viewModel.model.selectedImages.length}/${viewModel.model.maxImages}'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: viewModel.model.selectedImages
                          .map((imageData) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            imageData,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            DetailRow(
              title: '상품 카테고리',
              value: viewModel.model.selectedCategory,
              onTap: () => viewModel.selectCategory(context)
            ),
            DetailRow(
              title: '상품 구매',
              value: viewModel.model.purchaseStatus,
              onTap: () => viewModel.selectPurchaseStatus(context)
            ),
            DetailRow(
              title: '마감 기한',
              value: DateFormat('yyyy/MM/dd').format(viewModel.model.selectedDate),
              onTap: () => viewModel.selectDate(context)
            ),
            PriceInputRow(
              title: '상품 구매 가격',
              controller: viewModel.model.priceController,
              focusNode: viewModel.model.priceFocusNode,
              isProductPrice: true,
              personFocusNode: viewModel.model.personFocusNode
            ),
            if (!viewModel.model.isPriceValid)
              Row(
                children: [
                  Expanded(child: Container()),
                  Text(
                    "가격을 입력하세요",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            PersonInputRow(
              title: '모구 인원',
              controller: viewModel.model.personController,
              personFocusNode: viewModel.model.personFocusNode
            ),
            if (!viewModel.model.isPersonValid)
              Row(
                children: [
                  Expanded(child: Container()),
                  Text(
                    "인원을 입력하세요",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            ShareConditionRow(
              getShareConditionEqual: viewModel.model.getShareConditionEqual,
              toggleShareCondition: viewModel.toggleShareCondition
            ),
            if (!viewModel.model.isShareConditionEqual)
              PriceInputRow(
                title: '인당 가격 설정',
                controller: viewModel.model.customPriceController,
                focusNode: viewModel.model.customerPriceFocusNode,
                isProductPrice: false,
                personFocusNode: viewModel.model.personFocusNode
              ),
            if (!viewModel.model.isCustomPriceValid &&
                viewModel.model.showCustomPriceError)
              Row(
                children: [
                  Expanded(child: Container()),
                  Text(
                    "인당 가격을 입력하세요",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ]
              ),
            DetailRow(
              title: '할인된 가격',
              value: viewModel.model.chiefPrice,
              onTap: null,
              showArrow: false
            ),
            if (viewModel.model.showDiscountError)
              Row(
                children: [
                  Expanded(child: Container()),
                  Text(
                    "할인된 가격은 상품 구매 가격보다 낮아야 합니다",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            DetailRow(
                title: '모임 장소',
                value: viewModel.model.meetingPlace.isNotEmpty ?
                  viewModel.model.meetingPlace : "구매를 위한 모임 장소",
                onTap: () => viewModel.selectLocation(context)),
            if (!viewModel.model.isLocationValid)
              Row(
                children: [
                  Expanded(child: Container()),
                  Text(
                    "모임 장소를 설정하세요",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => viewModel.submitPost(context, widget.userInfo),
          child: Container(
            width: double.infinity,
            height: 70,
            padding: const EdgeInsets.only(top: 9, left: 11, right: 12, bottom: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Color(0x14737373),
                    blurRadius: 4,
                    offset: Offset(0, -4),
                    spreadRadius: 0),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Material(
                    color: Color(0xFFB34FD1),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => viewModel.submitPost(context, widget.userInfo),
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            '등록하기',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}