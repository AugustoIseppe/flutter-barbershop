import 'package:barbershop/app/utils/colors_palletes.dart';
import 'package:flutter/material.dart';

class BarberDetails extends StatelessWidget {
  const BarberDetails({super.key, required this.barber});

  final Map<String, dynamic> barber;

  // Função para abrir o WhatsApp com o número do barbeiro
  // void _launchWhatsApp(String phoneNumber) async {
  //   final Uri whatsappUrl = Uri(
  //     scheme: 'https',
  //     host: 'wa.me',
  //     path: phoneNumber,
  //   );
  //   // if (await canLaunchUrl(whatsappUrl)) {
  //   //   await launchUrl(whatsappUrl);
  //   // } else {
  //   //   throw 'Could not launch WhatsApp';
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    ColorsPalletes colorsPalletes = ColorsPalletes();
    return Scaffold(
      backgroundColor: colorsPalletes.primaryColor,
      appBar: AppBar(
        title: Text(
          barber["barbername"],
          style:  TextStyle(fontWeight: FontWeight.bold, color: colorsPalletes.white),
        ),
        backgroundColor: const Color(0xFF6f1610), // Cor personalizada
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Margem para o conteúdo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinhamento à esquerda
          children: [
            // Imagem do barbeiro
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0), // Borda arredondada
                child: Image.network(
                  "http://10.0.2.2:8800/users/uploads/${barber["barberimage"]}",
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0), // Espaçamento entre os elementos
            // Nome do barbeiro
            Text(
              barber["barbername"],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorsPalletes.white
              ),
            ),
            const SizedBox(height: 8.0), // Espaçamento entre os textos
            // Email do barbeiro
            Row(
              children: [
                const Icon(Icons.email, color: Colors.grey),
                const SizedBox(width: 8.0),
                Text(
                  barber["barberemail"],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Quantidade de serviços
            Row(
              children: [
                const Icon(Icons.build, color: Colors.grey),
                const SizedBox(width: 8.0),
                Text(
                  "${barber["barberqtdservices"]} Services",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // WhatsApp do barbeiro
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.grey),
                const SizedBox(width: 8.0),
                Text(
                  barber["barberwhatsapp"],
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Botão para WhatsApp
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message),
                label: const Text("Contact via WhatsApp"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6f1610), // Cor personalizada
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
