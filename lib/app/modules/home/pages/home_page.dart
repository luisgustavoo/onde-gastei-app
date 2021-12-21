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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            child: const Text('Get User Data'),
            onPressed: () async {
              await widget.homeController.fetchUserData();
            },
          ),
          // Selector<HomeControllerImpl, UserModel>(
          //   selector: (context, homeController) => homeController.userModel,
          //   builder: (context, userModel, _) => Text(userModel.name),
          // ),
        ],
      ),
    );
  }
}
