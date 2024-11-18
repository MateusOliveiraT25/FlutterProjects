import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrCodeScreen extends StatelessWidget {
  final Map<String, dynamic> visitorInfo;

  const GenerateQrCodeScreen({super.key, required this.visitorInfo});

  @override
  Widget build(BuildContext context) {
    final data = 'id:${visitorInfo['id']}, nome:${visitorInfo['nome']}, documento:${visitorInfo['documento']}';

    return Scaffold(
      appBar: AppBar(title: const Text('Gerar QR Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Escaneie o QR Code abaixo para confirmar o registro do visitante.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            QrImage(
              data: data, // Dados do visitante para gerar o QR Code
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);  // Voltar para a tela anterior
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
