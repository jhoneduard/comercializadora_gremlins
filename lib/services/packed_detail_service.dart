import 'dart:convert';
import 'package:comercializadora_gremlins/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PackedDetailService extends ChangeNotifier {
  final String _baseUrl =
      'comercializadora-gremlin-684db-default-rtdb.firebaseio.com';

  final List<DetalleEmpacado> listaDetalleEmpacado = [];

  final List<Usuario> listaClientes = [];

  late DetalleEmpacado detalleSeleccionado;

  final List<Producto> listaProductos = [];

  bool isSaving = false;

  bool isLoading = true;

  PackedDetailService() {
    loadPackedDetails();
    loadClients();
    loadProducts();
  }

  Future<List<DetalleEmpacado>> loadPackedDetails() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, '/detalle_envio.json');
    final resp = await http.get(url);
    if (resp.body != 'null') {
      final Map<String, dynamic> packedDetailMap = json.decode(resp.body);
      // Convertimos el hashMap a una lista de productos
      packedDetailMap.forEach((key, value) {
        final tempDetalle = DetalleEmpacado.fromJson(value);
        tempDetalle.id = key;
        listaDetalleEmpacado.add(tempDetalle);
      });
    }
    await Future.delayed(const Duration(seconds: 6));
    // Despues de dos segundos desaparecera el loading y mostrara los productos disponibles
    isLoading = false;
    notifyListeners();
    return listaDetalleEmpacado;
  }

  Future<List<Usuario>> loadClients() async {
    final queryParameters = {
      'orderBy': "\"categoriaUsuario\"",
      'equalTo': "\"-NUAGzJhHaWhzrZqfKet\"",
    };

    final url = Uri.https(_baseUrl, '/usuarios.json', queryParameters);
    final resp = await http.get(url);
    final Map<String, dynamic> clientsMaps = json.decode(resp.body);
    clientsMaps.forEach((key, value) {
      //print('cliente : $key - $value');
      final tempClient = Usuario.fromJson(value);
      tempClient.id = key;
      listaClientes.add(tempClient);
    });
    return listaClientes;
  }

  Future<List<Producto>> loadProducts() async {
    final url = Uri.https(_baseUrl, '/productos.json');

    final resp = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(resp.body);

    // Convertimos el hashMap a una lista de productos
    productsMap.forEach((key, value) {
      final tempProducto = Producto.fromJson(value);
      tempProducto.id = key;
      listaProductos.add(tempProducto);
    });
    return listaProductos;
  }

  Future saveOrCreatePackedDetail(DetalleEmpacado detalleEmpacado) async {
    isSaving = true;
    notifyListeners();
    if (detalleEmpacado.id == null) {
      await createPackedDetail(detalleEmpacado);
    } else {
      await updatePackedDetail(detalleEmpacado);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> createPackedDetail(DetalleEmpacado detalleEmpacado) async {
    final url = Uri.https(_baseUrl, 'detalle_envio.json');
    final resp =
        await http.post(url, body: json.encode(detalleEmpacado.toJson()));
    // convertimos la respuesta en un mapa con json.decode
    final decodedData = json.decode(resp.body);
    detalleEmpacado.id = decodedData['name'];
    listaDetalleEmpacado.add(detalleEmpacado);
    return detalleEmpacado.id!;
  }

  Future<String> updatePackedDetail(DetalleEmpacado detalleEmpacado) async {
    final url =
        Uri.https(_baseUrl, 'detalle_envio/${detalleEmpacado.id}.json');
    await http.put(url, body: json.encode(detalleEmpacado.toJson()));
    // Obtenemos el indice del producto guardado en el listado
    final index = listaDetalleEmpacado
        .indexWhere((element) => element.id == detalleEmpacado.id);
    // La informacion del producto lo actualizo
    listaDetalleEmpacado[index] = detalleEmpacado;
    return detalleEmpacado.id!;
  }
}
