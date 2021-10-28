import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.homeController, Key? key}) : super(key: key);

  static const router = '/home';

  final HomeController homeController;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: Container(),
    );
  }
}
