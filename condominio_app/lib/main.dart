import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/visitor_registration_screen.dart';
import 'screens/scanner_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Visitantes',
      debugShowCheckedModeBanner: false,  // Desativa o banner de "debug" na tela
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/registerVisitor': (context) => const VisitorRegistrationScreen(),
        '/scanQrCode': (context) => const ScannerScreen(),
      },
    );
  }
}
