import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrCodeScreen extends StatelessWidget {
  final Map<String, dynamic> visitorInfo;

  const GenerateQrCodeScreen({super.key, required this.visitorInfo});

  @override
  Widget build(BuildContext context) {
    // Removendo o 'id' do conteúdo do QR Code
    final data =
        'nome:${visitorInfo['nome']}, documento:${visitorInfo['documento']}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerar QR Code'),
        backgroundColor: Colors.orange,
      ),
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
            QrImageView(
              data: data, // QR Code sem o 'id'
              version: QrVersions.auto,
              size: 250.0,
              gapless: false,
              backgroundColor: Colors.white,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Voltar', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
