import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  String scannedData = '';

  // Função para parar a câmera e navegar para a página de dados escaneados
  void _openDataPage(String scannedData) {
    cameraController.stop(); // Parar a câmera ao navegar
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScannedDataPage(scannedData: scannedData),
      ),
    ).then((_) {
      // Limpar os dados escaneados ao voltar
      setState(() {
        scannedData = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Código QR'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Scanner de QR Code
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (BarcodeCapture capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? code = barcodes.first.rawValue;
                  if (code != null) {
                    setState(() {
                      scannedData = code; // Atualiza os dados escaneados
                    });
                    _openDataPage(scannedData); // Navega para a página com as informações e para a câmera
                  } else {
                    setState(() {
                      scannedData = "Código inválido";
                    });
                  }
                }
              },
            ),
          ),
          // Exibe o dado escaneado (apenas como indicação)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Código escaneado: $scannedData',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Página para exibir os dados escaneados
class ScannedDataPage extends StatelessWidget {
  final String scannedData;

  const ScannedDataPage({Key? key, required this.scannedData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados Escaneados'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Dados Escaneados:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              scannedData,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // Voltar para a tela anterior
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
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
