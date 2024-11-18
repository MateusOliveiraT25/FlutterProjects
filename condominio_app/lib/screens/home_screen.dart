import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Para navegação entre telas

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bem-vindo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela de registro do visitante
                context.push('/registerVisitor');
              },
              child: const Text('Sou Visitante'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela de scanner do porteiro
                context.push('/scanQrCode');
              },
              child: const Text('Sou Porteiro'),
            ),
          ],
        ),
      ),
    );
  }
}
