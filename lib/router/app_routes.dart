import 'package:comercializadora_gremlins/models/models.dart';
import 'package:comercializadora_gremlins/screens/screens.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const initialRoute = 'home';
  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'products',
        name: 'Productos',
        icon: Icons.card_giftcard_outlined,
        screen: const ProductScreen()),
    MenuOption(
        route: 'envios',
        name: 'Envio de productos',
        icon: Icons.send,
        screen: const PackedDetailScreen()),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes.addAll({'home': (BuildContext context) => const HomeScreen()});
    appRoutes
        .addAll({'product': (BuildContext context) => const ProductForm()});
    appRoutes
        .addAll({'sends': (BuildContext context) => const PackedDetailForm()});

    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }
    return appRoutes;
  }
}
