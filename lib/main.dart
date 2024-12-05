import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsi/favorite_provider.dart';
import 'package:responsi/home_screen.dart';
import 'package:responsi/favorite_screen.dart';
import 'package:responsi/detail_screen.dart';
import 'package:responsi/amiibo_model.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<AmiiboModel>('amiiboBox'); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) {
            final box = Hive.box<AmiiboModel>('amiiboBox'); 
            return FavoriteProvider(box); 
          },
        ),
      ],
      child: MaterialApp(
        title: 'Amiibo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/favorite': (context) => const FavoriteScreen(),
          '/detail': (context) {
            final amiibo =
                ModalRoute.of(context)?.settings.arguments as AmiiboModel?;
            if (amiibo == null) {
              return const HomeScreen();
            }
            return DetailScreen(amiibo: amiibo);
          },
        },
      ),
    );
  }
}
