import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mogu_app/user/home/main_page/home_page/home_page_viewModel.dart';
import 'package:mogu_app/user/home/main_page/home_page/widgets/home_post_card.dart';
import 'package:mogu_app/user/home/main_page/home_page/home_search_options.dart';
import 'package:provider/provider.dart';

import '../../menu_page/menu_page.dart';
import '../../notification_page/notification_page.dart';
import '../../post/post_create_page/post_create_page.dart';
import '../../search_page/search_page.dart';
import '../bottom/home_page_bottom.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeMainPage();
  }
}

class _HomeMainPage extends State<HomeMainPage> {
  late HomeMainPageViewModel viewModelForDispose;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<HomeMainPageViewModel>(context, listen: false);
    viewModel.initViewModel(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModelForDispose = Provider.of<HomeMainPageViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    viewModelForDispose.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeMainPageViewModel>(context);
    if (!viewModel.isInitialized)
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.reorder),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => MenuPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            ).then((value) {
              viewModel.filterByCategory(context, value);
            });
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
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Color(0xFFFFD3F0),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Color(0xFFFFD3F0),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      NotificationPage(userInfo: viewModel.userInfo),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          if (viewModel.model.isAdLoaded)
            Container(
              alignment: Alignment.center,
              width: viewModel.bannerAd!.size.width.toDouble(),
              height: viewModel.bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: viewModel.bannerAd!),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: SvgPicture.asset("assets/icons/search_filter.svg"),
                  onPressed: () {
                    HomeSearchOptions homeSearchOptions = HomeSearchOptions(
                      applySearchOptions: viewModel.applySearchOptions
                    );
                    homeSearchOptions.showSearchOptions(context);
                  },
                ),
                DropdownButton<String>(
                  value: viewModel.model.selectedSortOption,
                  items: viewModel.model.sortOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Color(0xFFB34FD1))),
                    );
                  }).toList(),
                  onChanged: viewModel.onSortOptionChanged,
                  iconEnabledColor: Color(0xFFB34FD1),
                  underline: SizedBox.shrink(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.model.posts.length,
              itemBuilder: (context, index) {
                return HomePostCard(
                  post: viewModel.model.posts[index],
                  userUid: viewModel.model.userUid
                );
              },
            )
          )
        ],
      ),
      bottomNavigationBar: HomePageBottom(selectedIndex: 0),
      floatingActionButton: ClipOval(
        child: Material(
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.3),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostCreatePage(
                    userInfo: viewModel.userInfo, // userInfo 전달
                  ),
                ),
              );

              if (result == true) {
                await viewModel.findAllPost(context);
              }
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
      ),
    );
  }
}