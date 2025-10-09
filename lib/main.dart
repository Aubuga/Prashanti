import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'despensa.dart';
import 'admin_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv; // optional, safe if not used at build time
// These read values passed with --dart-define at compile time (preferred for CI)
const _supabaseUrlFromDefine = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKeyFromDefine = String.fromEnvironment('SUPABASE_ANON_KEY');

// read from --dart-define
const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_supabaseUrl.isEmpty || _supabaseAnonKey.isEmpty) {
    throw Exception(
      'Supabase credentials missing. Run with --dart-define or set in launch.json.',
    );
  }

  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LandingPage(),
        ),
        GoRoute(
          path: '/despensa',
          builder: (context, state) => const DespensaPage(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdministradorPage(),
        ),
      ],
    );

    
    return MaterialApp.router(
      title: 'Prashanti Coliving',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5EFE9),
        fontFamily: 'Sans',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6C8F6B), // olive green
          secondary: Color(0xFF9B8F6C), // earthy gold
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C8F6B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C8F6B),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFF4A4A4A),
          ),
        ),
      ),
      //home: const LandingPage(), comented out after changing to materialapp.router
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  void _askPassword(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Ingrese la contraseña",
            style: TextStyle(color: Color(0xFF6C8F6B)),
          ),
          content: TextField(
            controller: _controller,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Contraseña",
              filled: true,
              fillColor: const Color(0xFFF5EFE9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Color(0xFF9B8F6C)),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_controller.text == "bananitadolca") {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdministradorPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Contraseña incorrecta")),
                  );
                }
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Color(0xFF6C8F6B)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf3ebe2) ,//COLOR FROM LOGO TO THE BACKGROUND
      appBar: AppBar(
        title: Text(''),
        
        backgroundColor: const Color(0xFF6C8F6B),
        elevation: 4,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6C8F6B),
              ),
              child: Center(
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.login, color: Color(0xFF9B8F6C)),
              title: const Text('Login'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings,
                  color: Color(0xFF9B8F6C)),
              title: const Text('Administrador'),
              onTap: () {
                Navigator.pop(context);
                _askPassword(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        // Constrain the image to a maximum height and width
  ConstrainedBox(
    constraints: const BoxConstraints(
      maxHeight: 200, // adjust as needed
      maxWidth: 200,  // adjust as needed
    ),
    child: Image.asset(
      'assets/images/logo_circular.jpg', //IMAGEN DE PRASHANTI LOGO
      fit: BoxFit.contain,
    ),
  ),
            
            const SizedBox(height: 20),
            const Text(
              '',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9B8F6C),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
        onPressed: () {
    context.push('/despensa'); // instead of Navigator.push
  },
              child: const Text('Despensa'),
            ),
          ],
        ),
      ),
    );
  }
}
