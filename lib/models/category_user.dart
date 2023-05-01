import 'dart:convert';

CategoriaUsuario categoriaUsuarioFromJson(String str) =>
    CategoriaUsuario.fromJson(json.decode(str));

String categoriaUsuarioToJson(CategoriaUsuario data) =>
    json.encode(data.toJson());

class CategoriaUsuario {
  String ? id;
  String nombre;

  CategoriaUsuario({
    this.id,
    required this.nombre,
  });

  factory CategoriaUsuario.fromJson(Map<String, dynamic> json) =>
      CategoriaUsuario(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}
