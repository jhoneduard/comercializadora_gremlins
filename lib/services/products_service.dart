import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:comercializadora_gremlins/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'comercializadora-gremlin-684db-default-rtdb.firebaseio.com';
  final List<Producto> listaProductos = [];

  final List<CategoriaProducto> listaCategorias = [];

  // Producto seleccionado previamente
  late Producto productoSeleccionado;

  bool isSaving = false;

  bool isLoading = true;

  // Cuando se llame al productService va llamar al loadProducts()
  ProductsService() {
    loadProducts();
    loadCategoryProducts();
  }

  Future<List<Producto>> loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, '/productos.json');
    final resp = await http.get(url);
    if (resp.body != 'null') {
      final Map<String, dynamic> productsMap = json.decode(resp.body);

      // Convertimos el hashMap a una lista de productos
      productsMap.forEach((key, value) {
        final tempProducto = Producto.fromJson(value);
        tempProducto.id = key;
        listaProductos.add(tempProducto);
      });
    }
    await Future.delayed(const Duration(seconds: 2));
    // Despues de dos segundos desaparecera el loading y mostrara los productos disponibles
    isLoading = false;
    notifyListeners();
    return listaProductos;
  }

  // Servicio que se encarga de actualizar o crear producto
  Future saveOrCreateProduct(Producto producto) async {
    isSaving = true;
    notifyListeners();
    // Validamos si el productoId es nulo
    if (producto.id == null) {
      // Es necesario crear
      await createProduct(producto);
    } else {
      // Es necesario Actualizar
      await updateProduct(producto);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> createProduct(Producto producto) async {
    final url = Uri.https(_baseUrl, 'productos.json');
    final resp = await http.post(url, body: json.encode(producto.toJson()));
    // convertimos la respuesta en un mapa con json.decode
    final decodedData = json.decode(resp.body);
    producto.id = decodedData['name'];
    listaProductos.add(producto);
    return producto.id!;
  }

  Future<String> updateProduct(Producto producto) async {
    final url = Uri.https(_baseUrl, 'productos/${producto.id}.json');
    await http.put(url, body: json.encode(producto.toJson()));
    // Obtenemos el indice del producto guardado en el listado
    final index =
        listaProductos.indexWhere((element) => element.id == producto.id);
    // La informacion del producto lo actualizo
    listaProductos[index] = producto;
    return producto.id!;
  }

  Future<List<CategoriaProducto>> loadCategoryProducts() async {
    final url = Uri.https(_baseUrl, '/categoria_productos.json');
    final resp = await http.get(url);
    final Map<String, dynamic> categoriaMaps = json.decode(resp.body);
    categoriaMaps.forEach((key, value) {
      final tempCategoria = CategoriaProducto.fromJson(value);
      tempCategoria.id = key;
      listaCategorias.add(tempCategoria);
    });
    return listaCategorias;
  }

  Future<String> createCategoryProduct(CategoriaProducto categoria) async {
    /*
                    productService.createCategoryProduct(CategoriaProducto(nombre: 'Ropa'));
                productService.createCategoryProduct(CategoriaProducto(nombre: 'Zapatos'));
                productService.createCategoryProduct(CategoriaProducto(nombre: 'Video juegos'));
                productService.createCategoryProduct(CategoriaProducto(nombre: 'Electrodomesticos'));
                productService.createCategoryProduct(CategoriaProducto(nombre: 'Alimentos'));
                productService.createCategoryProduct(CategoriaProducto(nombre: 'Herramientas'));
                productService.createCategoryProduct(CategoriaProducto(nombre: 'Bebidas'));
    */
    final url = Uri.https(_baseUrl, 'categoria_productos.json');
    final resp = await http.post(url, body: json.encode(categoria.toJson()));
    // converitimos la respuesta en un mapa con json.decode
    final decodedData = json.decode(resp.body);
    categoria.id = decodedData['name'];
    return categoria.id!;
  }

  Future<String> createCategoryUser(CategoriaUsuario categoria) async {
    /*
                        productService.createCategoryUser(CategoriaUsuario(nombre: 'Clientes'));
                productService.createCategoryUser(CategoriaUsuario(nombre: 'Administrador'));
                productService.createCategoryUser(CategoriaUsuario(nombre: 'Empacador'));
                productService.createCategoryUser(CategoriaUsuario(nombre: 'Distribuidores'));
                productService.createCategoryUser(CategoriaUsuario(nombre: 'Transportador'));
                productService.createCategoryUser(CategoriaUsuario(nombre: 'Herramientas'));
                productService.createCategoryUser(CategoriaUsuario(nombre: 'Recepcionista'));
    */
    final url = Uri.https(_baseUrl, 'categoria_usuarios.json');
    final resp = await http.post(url, body: json.encode(categoria.toJson()));
    // converitimos la respuesta en un mapa con json.decode
    final decodedData = json.decode(resp.body);
    categoria.id = decodedData['name'];
    return categoria.id!;
  }

  Future<String> createUser(Usuario usuario) async {
    /*
              // Usuario administrador
          productService.createUser(Usuario(
              tipoDocumento: 'C.C',
              identificacion: 123456789,
              nombre: 'Admin name',
              apellido: 'Admin surname',
              correoElectronico: 'admin@gmail.com',
              direccion: 'Bogota',
              telefono: '8721910',
              categoriaUsuario: '-NUAGzJfu_9lSJlHekji'));

          // Usuario Distribuidor
          productService.createUser(Usuario(
              tipoDocumento: 'C.C',
              identificacion: 987654321,
              nombre: 'Distribuidor name',
              apellido: 'Distribuidor surname',
              correoElectronico: 'distribuidor@gmail.com',
              direccion: 'Medellin',
              telefono: '3102946721',
              categoriaUsuario: '-NUAGzJfu_9lSJlHekjh'));

          // Usuario Transportador
          productService.createUser(Usuario(
              tipoDocumento: 'C.C',
              identificacion: 012345678,
              nombre: 'Transportador name',
              apellido: 'Transportador surname',
              correoElectronico: 'transportador@gmail.com',
              direccion: 'Cali',
              telefono: '3214310976',
              categoriaUsuario: '-NUAGzJfu_9lSJlHekjj'));

          // Usuario Empacador
          productService.createUser(Usuario(
              tipoDocumento: 'C.C',
              identificacion: 098765432,
              nombre: 'Empacador name',
              apellido: 'Empacador surname',
              correoElectronico: 'empacador@gmail.com',
              direccion: 'Facatativa',
              telefono: '3118234598',
              categoriaUsuario: '-NUAGzJg-qfemS4CX4Ac'));

          // Usuario cliente
          productService.createUser(Usuario(
              tipoDocumento: 'C.C',
              identificacion: 9876598765,
              nombre: 'cliente name',
              apellido: 'cliente surname',
              correoElectronico: 'cliente@gmail.com',
              direccion: 'Fusagasuga',
              telefono: '3219315474',
              categoriaUsuario: '-NUAGzJhHaWhzrZqfKet'));

          // Usuario recepcionista
          productService.createUser(Usuario(
              tipoDocumento: 'C.C',
              identificacion: 9876598765,
              nombre: 'Recepcionista name',
              apellido: 'Recepcionista surname',
              correoElectronico: 'recepcionista@gmail.com',
              direccion: 'Soacha',
              telefono: '31043198655',
              categoriaUsuario: '-NUAGzMrGrNu8lrr8smm'));
    */
    final url = Uri.https(_baseUrl, 'usuarios.json');
    final resp = await http.post(url, body: json.encode(usuario.toJson()));
    // converitimos la respuesta en un mapa con json.decode
    final decodedData = json.decode(resp.body);
    usuario.id = decodedData['name'];
    return usuario.id!;
  }
}
