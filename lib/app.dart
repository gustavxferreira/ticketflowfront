import 'package:flutter/material.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Sistema de Chamados',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        primaryColor: const Color(0xFF00A3E0),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00A3E0),
          secondary: Color(0xFF005F8A),
          surface: Color(0xFF001F3F),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
      ),
      initialRoute: initialRoute,
      routes: appRoutes,
    );
  }
}
