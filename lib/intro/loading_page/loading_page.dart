import 'package:flutter/material.dart';
import 'package:mogu_app/intro/loading_page/loading_page_viewModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../intro_page/intro_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<LoadingPageViewModel>(context, listen: false);
    viewModel.requestPermissions(context).then((_) {
      viewModel.navigateToNextPage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.71, -0.71),
            end: Alignment(-0.71, 0.71),
            colors: const [Color(0xFFFFA7E1), Color(0xB29322CC)],
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 113,
            height: 104,
            child: Image.asset(
              'assets/Mogulogo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}