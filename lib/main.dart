import 'package:comercializadora_gremlins/router/app_routes.dart';
import 'package:comercializadora_gremlins/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

// Inyectamos el productService en el punto
// mas alto del contexto, en cualquier vista de la app
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsService(),
          // Lazy es cuando el usuario lo necesite...
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => PackedDetailService(),
          // Lazy es cuando el usuario lo necesite...
          lazy: true,
        )
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COMERCIALIZADORA GREMLINS',
      initialRoute: AppRouter.initialRoute,
      routes: AppRouter.getAppRoutes(),
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo, elevation: 0)),
    );
  }
}
