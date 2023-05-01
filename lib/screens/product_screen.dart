import 'package:comercializadora_gremlins/models/product.dart';
import 'package:comercializadora_gremlins/screens/screens.dart';
import 'package:comercializadora_gremlins/services/services.dart';
import 'package:comercializadora_gremlins/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
          title: const Text('Gestion de productos'),
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {}, icon: const Icon(Icons.card_giftcard)),
        );

    // llamamos el producto service donde podremos llamar a obtener productos
    final productService = Provider.of<ProductsService>(context);
    if (productService.isLoading) return LoadingScreen(appBar: appBar);

    return Scaffold(
        appBar: appBar,
        body: ListView.builder(
            itemCount: productService.listaProductos.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  productService.productoSeleccionado =
                      productService.listaProductos[index].copy();
                  Navigator.pushNamed(context, 'product');
                },
                child: ProductCard(
                  producto: productService.listaProductos[index],
                ))),
        floatingActionButton:
            CustomFloatingActions(productService: productService));
  }
}

class CustomFloatingActions extends StatelessWidget {
  final ProductsService productService;
  const CustomFloatingActions({super.key, required this.productService});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'home');
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined)),
        const SizedBox(width: 30),
        FloatingActionButton(
            onPressed: () {
              productService.productoSeleccionado = Producto(
                  estado: true,
                  nombre: '',
                  precio: 0.0,
                  stock: 0,
                  idCategoria: '');
              Navigator.pushNamed(context, 'product');
            },
            child: const Icon(Icons.add)),
      ],
    );
  }
}
