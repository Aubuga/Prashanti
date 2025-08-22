// admin_page.dart
import 'package:flutter/material.dart';
import 'admin_despensa.dart'; //

class AdministradorPage extends StatelessWidget {
  const AdministradorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador - Prashanti Coliving'),
        centerTitle: true,
      ),
body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Despensa'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminDespensaPage(),
                ),
              );
            },
          ),
          // 🔜 Future buttons for other modules can go here
        ],
      ),
    );
  }
}