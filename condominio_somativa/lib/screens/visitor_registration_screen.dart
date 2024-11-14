import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // Para escolher imagens da galeria ou câmera
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class VisitorRegistrationScreen extends StatefulWidget {
  const VisitorRegistrationScreen({super.key});

  @override
  _VisitorRegistrationScreenState createState() => _VisitorRegistrationScreenState();
}

class _VisitorRegistrationScreenState extends State<VisitorRegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  String qrCodeResult = ""; // Resultado do QR code
  File? _image; // Imagem selecionada do QR code

  final picker = ImagePicker();

  Future<void> _scanQRCodeFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _processQRCode();
    }
  }

  Future<void> _scanQRCodeFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _processQRCode();
    }
  }

  Future<void> _processQRCode() async {
    // Aqui você deve implementar a lógica para processar o QR code da imagem `_image`
    // Para simplificação, estamos simulando o processamento
    qrCodeResult = "Resultado de exemplo"; // Substitua pelo processamento real
    setState(() {});
  }

  Future<void> _registerVisitor() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você precisa estar logado!')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('visitantes').add({
        'nome': nameController.text,
        'documento': documentController.text,
        'qr_code': qrCodeResult,
        'horario_entrada': DateTime.now(),
        'uid': currentUser.uid,
      });

      // Limpar os campos após o envio
      nameController.clear();
      documentController.clear();
      qrCodeResult = "";

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visitante registrado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar visitante: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Visitante')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _image != null
                    ? Image.file(_image!)
                    : const Text('Nenhuma imagem selecionada'),
                Text('Resultado: $qrCodeResult'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _scanQRCodeFromGallery,
                      child: const Text('Escolher da Galeria'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _scanQRCodeFromCamera,
                      child: const Text('Usar Câmera'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  TextField(
                    controller: documentController,
                    decoration: const InputDecoration(labelText: 'Documento'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _registerVisitor,
                    child: const Text('Registrar Visitante'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
  