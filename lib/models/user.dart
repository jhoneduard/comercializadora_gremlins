import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  String? id;
  String tipoDocumento;
  int identificacion;
  String nombre;
  String apellido;
  String correoElectronico;
  String direccion;
  String telefono;
  String categoriaUsuario;

  Usuario({
    this.id,
    required this.tipoDocumento,
    required this.identificacion,
    required this.nombre,
    required this.apellido,
    required this.correoElectronico,
    required this.direccion,
    required this.telefono,
    required this.categoriaUsuario,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        tipoDocumento: json["tipoDocumento"],
        identificacion: json["identificacion"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        correoElectronico: json["correoElectronico"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        categoriaUsuario: json["categoriaUsuario"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipoDocumento": tipoDocumento,
        "identificacion": identificacion,
        "nombre": nombre,
        "apellido": apellido,
        "correoElectronico": correoElectronico,
        "direccion": direccion,
        "telefono": telefono,
        "categoriaUsuario": categoriaUsuario,
      };

  @override
  String toString() {
    return toJson()['id'];
  }
  
}
