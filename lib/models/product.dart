import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
  Producto({
    this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.estado,
    required this.idCategoria,
  });

  String? id;
  String nombre;
  double precio;
  int stock;
  bool estado;
  String idCategoria;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
      id: json["id"],
      nombre: json["nombre"],
      precio: double.parse(json["precio"].toString()),
      stock: json["stock"],
      estado: json["estado"],
      idCategoria: json["idCategoria"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "precio": precio,
        "stock": stock,
        "estado": estado,
        "idCategoria": idCategoria,
      };

  Producto copy() {
    return Producto(
        id: id,
        nombre: nombre,
        precio: precio,
        stock: stock,
        estado: estado,
        idCategoria: idCategoria);
  }

  @override
  String toString() {
    return toJson()['id'];
  }
}
