import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart'; // Usando go_router para navegação
import 'package:qr_flutter/qr_flutter.dart'; // Importando para gerar QR code

class VisitorRegistrationScreen extends StatefulWidget {
  const VisitorRegistrationScreen({super.key});

  @override
  _VisitorRegistrationScreenState createState() =>
      _VisitorRegistrationScreenState();
}

class _VisitorRegistrationScreenState extends State<VisitorRegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController documentController = TextEditingController();

  // Função para salvar os dados temporários do visitante no Firestore
  Future<void> _saveVisitor() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você precisa estar logado!')),
        );
        return;
      }

      // Dados do visitante a ser registrado temporariamente
      final visitorData = {
        'nome': nameController.text,
        'documento': documentController.text,
        'horario_entrada': DateTime.now(), // Armazena o horário de entrada
        'uid': currentUser.uid, // Armazena o UID do usuário logado
        'status': 'pendente', // O status será "pendente" até aprovação do administrador
      };

      // Salva os dados na coleção 'visitantes_pendentes'
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('visitantes_pendentes')
          .add(visitorData);

      // Gerar o QR Code com os dados do visitante
      final visitorInfo = {
        'id': docRef.id, // ID do documento gerado
        'nome': nameController.text,
        'documento': documentController.text,
      };

      // Navegar para a tela de QR Code, passando os dados
      context.push(
        '/generateQrCode', // Usa o go_router para navegação
        extra: visitorInfo, // Passa os dados para a próxima tela
      );

      // Limpar os campos após o envio
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
