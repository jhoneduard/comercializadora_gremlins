import 'dart:convert';

DetalleEmpacado detalleEmpacadoFromJson(String str) =>
    DetalleEmpacado.fromJson(json.decode(str));

String detalleEmpacadoToJson(DetalleEmpacado data) =>
    json.encode(data.toJson());

class DetalleEmpacado {
  String? id;
  String idCliente;
  String idProducto;
  String descripcion;
  String direccion;
  String fechaEmpacado;
  String estado;
  double costoEnvio;
  int cantidadMercancia;

  DetalleEmpacado(
      {this.id,
      required this.idCliente,
      required this.idProducto,
      required this.descripcion,
      required this.direccion,
      required this.fechaEmpacado,
      required this.estado,
      required this.costoEnvio,
      required this.cantidadMercancia});

  factory DetalleEmpacado.fromJson(Map<String, dynamic> json) =>
      DetalleEmpacado(
          id: json["id"],
          idCliente: json["idCliente"],
          idProducto: json["idProducto"],
          descripcion: json["descripcion"],
          direccion: json["direccion"],
          fechaEmpacado: json['fechaEmpacado'],
          estado: json['estado'],
          costoEnvio: json['costoEnvio'],
          cantidadMercancia: json['cantidadMercancia']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "idCliente": idCliente,
        "idProducto": idProducto,
        "descripcion": descripcion,
        "direccion": direccion,
        "fechaEmpacado": fechaEmpacado,
        "estado": estado,
        "costoEnvio": costoEnvio,
        "cantidadMercancia": cantidadMercancia
      };

  DetalleEmpacado copy() {
    return DetalleEmpacado(
        id: id,
        idCliente: idCliente,
        idProducto: idProducto,
        descripcion: descripcion,
        direccion: direccion,
        fechaEmpacado: fechaEmpacado,
        estado: estado,
        costoEnvio: costoEnvio,
        cantidadMercancia: cantidadMercancia);
  }

  @override
  String toString() {
    return toJson()['id'];
  }
}
