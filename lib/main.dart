import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'despensa.dart';
import 'admin_page.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hpxkgyajpzxhnzrcmreu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhweGtneWFqcHp4aG56cmNtcmV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1OTQxNjQsImV4cCI6MjA3MDE3MDE2NH0.nNz2Oq62Le-L-PDSWn44mUugD2O_MGhcCmOSVB5bDcw',
  );




  runApp(
  
      const MyApp(),
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prashanti Coliving',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5EFE9), // background like your logo
        fontFamily: 'Sans', // we'll add custom fonts later if you want
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  //generates the burger icon and the 'app' visual
      title: const Text('Prashanti Coliving'),
      backgroundColor: const Color(0xFF6C8F6B), // green from your logo
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openEndDrawer(); // opens right-side menu
            },
          ),
        ),
      ],
    ),
    endDrawer: Drawer( //uses the burger icon
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Color(0xFF6C8F6B),
        ),
        child: Text(
          'Menú',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.login),
        title: const Text('Login'),
        onTap: () {
          Navigator.pop(context); // close drawer
          // TODO: add login navigation later
        },
      ),
      ListTile(
        leading: const Icon(Icons.admin_panel_settings),
        title: const Text('Administrador'),
        onTap: () {
          Navigator.pop(context); // close drawer
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdministradorPage()),
          );
        },
      ),
    ],
  ),
),
      body:Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Your logo (we'll add the actual image later)
          const Icon(Icons.eco, size: 80, color: Color(0xFF6C8F6B)), // placeholder for now
          const SizedBox(height: 20),

          const Text(
            'Prashanti Coliving',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF6C8F6B),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),



          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DespensaPage()), //The underscore _ is just a throwaway variable when you're not using the context inside the builder. Since Flutter passes the BuildContext, but you don't use it in the builder
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C8F6B), // green
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Despensa'),
          ),
          const SizedBox(height: 20),
           
        ],
      ),
    ));
  }
}








class AdministradorLogin extends StatefulWidget {
  const AdministradorLogin({super.key});

  @override
  State<AdministradorLogin> createState() => _AdministradorLoginState();
}

class _AdministradorLoginState extends State<AdministradorLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador'),
        backgroundColor: const Color(0xFF6C8F6B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AdministradorPage()),
  );
  //               final username = _usernameController.text.trim();
  //               final password = _passwordController.text.trim();

  // if (!isValidEmail(username)) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => const AlertDialog(
  //       title: Text('Error'),
  //       content: Text('Por favor, ingrese un email válido.'),
  //     ),
  //   );
  //   return;
  // }

  // if (!isValidPassword(password)) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => const AlertDialog(
  //       title: Text('Error'),
  //       content: Text('La contraseña debe tener al menos 6 caracteres.'),
  //     ),
  //   );
  //   return;
  // }

  // // Si pasa validación:
  // showDialog(
  //   context: context,
  //   builder: (_) => const AlertDialog(
  //     title: Text('Éxito'),
  //     content: Text('Acceso válido (aún no se hace nada más).'),
  //   ),
  // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B8F6C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Entrar'),
              
            ),
          ],
        ),
      ),
    );
  }
}
