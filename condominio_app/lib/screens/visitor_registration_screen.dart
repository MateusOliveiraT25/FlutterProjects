import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class VisitorRegistrationScreen extends StatefulWidget {
  const VisitorRegistrationScreen({super.key});

  @override
  _VisitorRegistrationScreenState createState() =>
      _VisitorRegistrationScreenState();
}

class _VisitorRegistrationScreenState extends State<VisitorRegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController documentController = TextEditingController();

  Future<void> _saveVisitor() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você precisa estar logado!')),
        );
        return;
      }

      final visitorData = {
        'nome': nameController.text,
        'documento': documentController.text,
        'horario_entrada': DateTime.now(),
        'status': 'pendente', // Status pendente até ser aprovado
      };

      // Salvar os dados no Firestore
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('visitantes_pendentes')
          .add(visitorData);

      // Navegar para a tela de geração de QR Code
      final visitorInfo = {
        'id': docRef.id,
        'nome': nameController.text,
        'documento': documentController.text,
      };

      context.push(
        '/generateQrCode',
        extra: visitorInfo,
      );

      nameController.clear();
      documentController.clear();

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
      body: Padding(
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
              onPressed: _saveVisitor,
              child: const Text('Registrar Visitante'),
            ),
          ],
        ),
      ),
    );
  }
}
