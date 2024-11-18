import 'package:condominio_app/screens/generate_qr_code_screen.dart';
import 'package:flutter/material.dart';

class VisitorRegistrationScreen extends StatefulWidget {
  const VisitorRegistrationScreen({super.key});

  @override
  _VisitorRegistrationScreenState createState() =>
      _VisitorRegistrationScreenState();
}

class _VisitorRegistrationScreenState extends State<VisitorRegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController documentController = TextEditingController();

  // Função para passar as informações diretamente para a tela de QR Code
  void _generateQrCode() {
    // Verificando se os campos não estão vazios ou apenas com espaços em branco
    if (nameController.text.trim().isEmpty || documentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    // Informações para o QR Code
    final visitorInfo = {
      'nome': nameController.text.trim(),
      'documento': documentController.text.trim(),
    };

    // Navegar para a tela de geração de QR Code
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenerateQrCodeScreen(visitorInfo: visitorInfo),
      ),
    );

    // Limpar os campos de entrada
    nameController.clear();
    documentController.clear();

    // Mostrar mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('QR Code gerado com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Visitante'),
        backgroundColor: Colors.green, // Cor verde na barra de navegação
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo para nome
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
                hintText: 'Digite o nome do visitante',
              ),
            ),
            const SizedBox(height: 12),
            // Campo para documento
            TextField(
              controller: documentController,
              decoration: const InputDecoration(
                labelText: 'Documento',
                border: OutlineInputBorder(),
                hintText: 'Digite o documento do visitante',
              ),
            ),
            const SizedBox(height: 20),
            // Botão de gerar QR Code
            ElevatedButton(
              onPressed: _generateQrCode,
              child: const Text('Gerar QR Code'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green, // Largura do botão expandida
                textStyle: const TextStyle(fontSize: 16), // Cor verde no botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
