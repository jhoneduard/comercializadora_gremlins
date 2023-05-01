import 'dart:convert';

CategoriaProducto categoriaProductoFromJson(String str) =>
    CategoriaProducto.fromJson(json.decode(str));

String categoriaProductoToJson(CategoriaProducto data) =>
    json.encode(data.toJson());

class CategoriaProducto {
  String? id;
  String nombre;

  CategoriaProducto({
    this.id,
    required this.nombre,
  });

  factory CategoriaProducto.fromJson(Map<String, dynamic> json) =>
      CategoriaProducto(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };

  @override
  String toString() {
    return toJson()['id'];
  }
}
