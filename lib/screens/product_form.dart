import 'dart:io';

import 'package:comercializadora_gremlins/models/models.dart';
import 'package:comercializadora_gremlins/providers/product_form_provider.dart';
import 'package:comercializadora_gremlins/screens/alert_screen.dart';
import 'package:comercializadora_gremlins/services/services.dart';
import 'package:comercializadora_gremlins/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProductForm extends StatelessWidget {
  const ProductForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    // ignore: unnecessary_null_comparison
    return ChangeNotifierProvider(
        create: (_) => ProductFormProvider(productService.productoSeleccionado),
        child: _ProductScreenBody(productService: productService));
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({required this.productService});
  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    List<CategoriaProducto> listaCategorias = productService.listaCategorias;

    final productForm = Provider.of<ProductFormProvider>(context);
    String titulo = productService.productoSeleccionado.id == null
        ? 'Creacion de producto'
        : 'Edicion de producto';

    return Scaffold(
        appBar: AppBar(title: Text(titulo)),
        body: SingleChildScrollView(
            child: Column(children: [
          _ProductoFormulario(listaCategorias: listaCategorias),
          const SizedBox(height: 100)
        ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          child: (productService.productoSeleccionado.id == null)
              ? const Icon(Icons.save)
              : const Icon(Icons.save_as_rounded),
          onPressed: () async {
            // Si el boton no es valido que no continue
            if (!productForm.isValidForm()) {
              return;
            }

            if (productForm.product.idCategoria == '') {
              productForm.product.idCategoria = listaCategorias.first.id!;
            }

            productService.saveOrCreateProduct(productForm.product);
            // Si la opcion es de guardar
            if (productService.productoSeleccionado.id == null) {
              Platform.isAndroid
                  ? AlertScreen.displayDialogAndroid(
                      context: context,
                      titulo: 'Registro creado con exito',
                      text: 'Se ha creado con exito el producto',
                      url: 'products')
                  : AlertScreen.displayDialogIOS(
                      context: context,
                      titulo: 'Registro creado con exito',
                      text: 'Se ha creado con exito el producto',
                      url: 'products');
            } else {
              Platform.isAndroid
                  ? AlertScreen.displayDialogAndroid(
                      context: context,
                      titulo: 'Registro actualizado con exito',
                      text: 'Se ha actualizado con exito el producto',
                      url: 'products')
                  : AlertScreen.displayDialogIOS(
                      context: context,
                      titulo: 'Registro actualizado con exito',
                      text: 'Se ha actualizado con exito el producto',
                      url: 'products');
            }
          },
        ));
  }
}

class _ProductoFormulario extends StatelessWidget {
  const _ProductoFormulario({required this.listaCategorias});
  final List<CategoriaProducto> listaCategorias;
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    BoxDecoration _buildBoxDecoration() => BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 5),
                  blurRadius: 5)
            ]);
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: _buildBoxDecoration(),
          child: Form(
            key: productForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(height: 10),
                CustomInputField(
                  labelText: 'Nombre',
                  hintText: 'Nombre del producto',
                  icon: Icons.card_giftcard_outlined,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null) return 'El campo nombre es requerido';
                    if (value.length < 3) return 'Minimo de tres digitos ';
                    if (value.length > 40) return 'Maximo de 40 digitos';
                    return null;
                  },
                  onChanged: (value) {
                    product.nombre = value;
                  },
                  initValue: product.nombre,
                ),
                const SizedBox(height: 10),
                TextFormField(
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El precio es requerido';
                      }

                      if (int.tryParse(value) != null &&
                          double.parse(value) == 0) {
                        return 'El precio debe ser mayor a cero';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.price_change),
                        hintText: '\$0.0',
                        labelText: 'Precio : '),
                    initialValue: '${product.precio}',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    onChanged: (value) {
                      // Validamos si se puede parsear el valor a double
                      // Si es igual a nulo, signifca que no se puede parsear...
                      if (double.tryParse(value) == null) {
                        product.precio = 0;
                      } else {
                        product.precio = double.parse(value);
                      }
                    }),
                const SizedBox(height: 10),
                TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La cantidad es requerida';
                      }

                      if (int.tryParse(value) != null &&
                          int.parse(value) == 0) {
                        return 'La cantidad debe ser mayor a cero';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.inventory),
                        hintText: '',
                        labelText: 'Stock : '),
                    initialValue: '${product.stock}',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'\d'))
                    ],
                    onChanged: (value) {
                      if (int.tryParse(value) == null) {
                        product.stock = 0;
                      } else {
                        product.stock = int.parse(value);
                      }
                    }),
                const SizedBox(height: 10),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Row(
                        children: const [Icon(Icons.bookmark), Text('Estado')],
                      ),
                      DropdownButtonFormField<bool>(
                          items: const [
                            DropdownMenuItem(
                              value: true,
                              child: Text('Activo'),
                            ),
                            DropdownMenuItem(
                              value: false,
                              child: Text('Inactivo'),
                            )
                          ],
                          value: (product.id == null) ? true : product.estado,
                          onChanged: (value) {
                            product.estado = value!;
                          }),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(Icons.category),
                          Text('Categoria')
                        ],
                      ),
                      DropdownButtonFormField(
                          value: (product.id == null)
                              ? listaCategorias.first
                              : listaCategorias
                                  .where((element) =>
                                      element.id == product.idCategoria)
                                  .toList()
                                  .last,
                          items: listaCategorias
                              .map((categoria) =>
                                  DropdownMenuItem<CategoriaProducto>(
                                      value: categoria,
                                      child: Text(categoria.nombre)))
                              .toList(),
                          onChanged: (value) {
                            product.idCategoria = value.toString();
                          })
                    ])
              ],
            ),
          ),
        ));
  }
}
