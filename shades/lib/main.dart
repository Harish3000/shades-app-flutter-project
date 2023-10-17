import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shades/shared/common_widgets/splash_screen.dart';

import 'core/auth/login_page.dart';
import 'core/auth/sign_up_page.dart';
import 'shared/common_widgets/BottomTabBar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      home: SplashScreen(
        child: LoginPage(),
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) =>
            BottomTabBar(), // Use the BottomTabBar widget here
      },
    );
  }
}
