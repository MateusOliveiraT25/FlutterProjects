import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  String scannedData = '';

  Future<void> _approveVisitor(String scannedId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('visitantes_pendentes')
          .doc(scannedId)
          .get();

      if (snapshot.exists) {
        await FirebaseFirestore.instance
            .collection('visitantes_aprovados')
            .doc(scannedId)
            .set(snapshot.data()!);

        await FirebaseFirestore.instance
            .collection('visitantes_pendentes')
            .doc(scannedId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visitante aprovado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visitante não encontrado!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao aprovar visitante: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (barcode, args) {
                if (barcode.rawValue != null) {
                  setState(() {
                    scannedData = barcode.rawValue!;
                  });
                  _approveVisitor(scannedData);  // Aprovar o visitante após escanear
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Código escaneado: $scannedData',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
