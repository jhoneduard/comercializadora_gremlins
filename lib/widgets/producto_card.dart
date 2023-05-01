import 'package:comercializadora_gremlins/models/models.dart';
import 'package:comercializadora_gremlins/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Producto producto;

  const ProductCard({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    BoxDecoration _cardBorders() => BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, offset: Offset(0, 7), blurRadius: 10)
            ]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 200, // 400
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _ProductDetails(
                nombreProducto: producto.nombre,
                stock: producto.stock,
                id: producto.id!,
                idCategoria: producto.idCategoria),
            Positioned(
                top: 0,
                right: 0,
                child: _PriceTag(
                  precioProducto: producto.precio,
                )),
            if (!producto.estado)
              Positioned(top: 0, left: 0, child: _NotAvailable())
          ],
        ),
      ),
    );
  }
}

class _NotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: sort_child_properties_last
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('No disponible',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final double precioProducto;

  const _PriceTag({required this.precioProducto});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // ignore: sort_child_properties_last
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('\$$precioProducto',
                style: const TextStyle(color: Colors.white, fontSize: 20))),
      ),
      width: 100,
      height: 70,
      decoration: const BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final String nombreProducto;
  final int stock;
  final String id;
  final String idCategoria;
  const _ProductDetails(
      {required this.nombreProducto,
      required this.stock,
      required this.id,
      required this.idCategoria});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    List<CategoriaProducto> listaCategorias = productService.listaCategorias;
    CategoriaProducto categoriaProducto = listaCategorias
        .where((element) => element.id == idCategoria)
        .toList()
        .last;
    String categoriaNombre = categoriaProducto.nombre;

    // ignore: no_leading_underscores_for_local_identifiers
    BoxDecoration _buildBoxDecoration() => const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));

    return Padding(
      // Para realizar la separacion del lado derecho en el cuadrado azul
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 100,
        decoration: _buildBoxDecoration(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            nombreProducto,
            style: const TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text('Stock : $stock',
              style: const TextStyle(fontSize: 12, color: Colors.white)),
          Text('ID : $id',
              style: const TextStyle(fontSize: 12, color: Colors.white)),
          Text('Categoria : $categoriaNombre',
              style: const TextStyle(fontSize: 12, color: Colors.white))
        ]),
      ),
    );
  }
}
