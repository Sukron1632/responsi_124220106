import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsi/login_scren.dart'; 
import 'package:responsi/register_screen.dart'; 
import 'package:responsi/screens/home_screen.dart'; 
import 'package:responsi/screens/favorite_screen.dart'; 
import 'package:responsi/screens/detail_screen.dart'; 
import 'package:responsi/models/amiibo_model.dart'; 
import 'package:responsi/user_model.dart';
import 'package:responsi/providers/favorite_provider.dart'; 

void main() async {
  // Pastikan binding widget sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  // Registrasi Adapter untuk AmiiboModel
  Hive.registerAdapter(AmiiboModelAdapter());

  // Membuka Box Hive untuk AmiiboModel
  await Hive.openBox<AmiiboModel>('amiiboBox');

  // Jalankan aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       
        ChangeNotifierProvider(
          create: (context) => FavoriteProvider(
            Hive.box<AmiiboModel>('amiiboBox'),  
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Amiibo App', 
        debugShowCheckedModeBanner: false, 

        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,

          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
          ),

          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.black87),
            bodyMedium: TextStyle(color: Colors.black54),
          ),
        ),

        // Rute awal
        initialRoute: '/login',

        // Definisi rute statis
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/favorites': (context) => const FavoriteScreen(),
        },

        // Rute dinamis untuk DetailScreen
        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            final amiibo = settings.arguments as AmiiboModel?;

            // Menangani detail AmiiboModel
            if (amiibo != null) {
              return MaterialPageRoute(
                builder: (context) => DetailScreen(amiibo: amiibo),
              );
            }

            // Fallback jika tidak ada data yang valid
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(
                  child: Text('Data tidak ditemukan atau argumen tidak valid.'),
                ),
              ),
            );
          }
          return null;
        },

        // Handler untuk rute yang tidak terdefinisi
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                child: Text('Halaman tidak ditemukan'),
              ),
            ),
          );
        },
      ),
    );
  }
}
