import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterProvider with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // UI 업데이트
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("CounterScreen build 실행됨");
    return Scaffold(
      appBar: AppBar(title: Text("Stateless + Provider")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<CounterProvider>(
              builder: (context, counter, child) {
                return Text("카운트: ${counter.count}", style: TextStyle(fontSize: 24));
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<CounterProvider>(context, listen: false).increment();
              },
              child: Text("증가"),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CounterProvider(),
      child: MaterialApp(home: CounterScreen()),
    ),
  );
}