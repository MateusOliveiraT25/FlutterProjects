import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'home_screen.dart'; // Tela inicial
import 'visitor_registration_screen.dart'; // Tela de registro
import 'generate_qr_code_screen.dart'; // Tela de QR Code
import 'scanner_screen.dart'; // Tela de scanner

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/registerVisitor',
          builder: (context, state) => const VisitorRegistrationScreen(),
        ),
        GoRoute(
          path: '/generateQrCode',
          builder: (context, state) {
            final visitorInfo = state.extra as Map<String, dynamic>;
            return GenerateQrCodeScreen(visitorInfo: visitorInfo);
          },
        ),
        GoRoute(
          path: '/scanQrCode',
          builder: (context, state) => const ScannerScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
