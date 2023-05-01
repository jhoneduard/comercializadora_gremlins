import 'package:comercializadora_gremlins/router/app_routes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final menuOptions = AppRouter.menuOptions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema comercializadora gremmlins'),
        automaticallyImplyLeading: false,
        leading: IconButton(icon: Image.asset('assets/logo.jpg'), onPressed: ()=>{},),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          leading: Icon(menuOptions[index].icon,
              color: Theme.of(context).primaryColor),
          title: Text(menuOptions[index].name),
          onTap: () {
            Navigator.pushNamed(context, menuOptions[index].route);
          },
        ),
        separatorBuilder: (__, ___) => const Divider(),
        itemCount: menuOptions.length,
      ),
    );
  }
}
