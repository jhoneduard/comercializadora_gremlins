import 'package:comercializadora_gremlins/models/models.dart';
import 'package:comercializadora_gremlins/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PackedDetailCard extends StatelessWidget {
  final DetalleEmpacado detalleEmpacado;

  const PackedDetailCard({super.key, required this.detalleEmpacado});

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
                _PackedDetails(
                  idCliente: detalleEmpacado.idCliente,
                  idProducto: detalleEmpacado.idProducto,
                  descripcion: detalleEmpacado.descripcion,
                  direccion: detalleEmpacado.direccion,
                  fechaEmpacado: detalleEmpacado.fechaEmpacado,
                  estado: detalleEmpacado.estado,
                  costoEnvio: detalleEmpacado.costoEnvio,
                  cantidadMercancia: detalleEmpacado.cantidadMercancia,
                )
              ],
            )));
  }
}

class _PackedDetails extends StatelessWidget {
  final String idCliente;
  final String idProducto;
  final String descripcion;
  final String direccion;
  final String fechaEmpacado;
  final String estado;
  final double costoEnvio;
  final int cantidadMercancia;

  const _PackedDetails({
    required this.idCliente,
    required this.idProducto,
    required this.descripcion,
    required this.direccion,
    required this.fechaEmpacado,
    required this.estado,
    required this.costoEnvio,
    required this.cantidadMercancia,
  });

  @override
  Widget build(BuildContext context) {
    final packedDetailService = Provider.of<PackedDetailService>(context);
    final productService = Provider.of<ProductsService>(context);
    DateTime fechaDateTime = DateTime.parse(fechaEmpacado);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatoFecha = formatter.format(fechaDateTime);

    Usuario cliente = packedDetailService.listaClientes
        .where((element) => element.id == idCliente)
        .toList()
        .last;

    Producto producto = productService.listaProductos
        .where((element) => element.id == idProducto)
        .toList()
        .last;

    // ignore: no_leading_underscores_for_local_identifiers
    BoxDecoration _buildBoxDecoration() => const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));

    return Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          width: double.infinity,
          height: 168,
          decoration: _buildBoxDecoration(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Fecha empacado : $formatoFecha',
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
                'Cliente : ${cliente.tipoDocumento} ${cliente.identificacion} - ${cliente.nombre}  ${cliente.apellido}',
                style: const TextStyle(fontSize: 12, color: Colors.white)),
            Text('Producto : $producto.nombre',
                style: const TextStyle(fontSize: 12, color: Colors.white)),
            Text('Descripcion : $descripcion',
                style: const TextStyle(fontSize: 12, color: Colors.white)),
            Text('Direccion : $direccion',
                style: const TextStyle(fontSize: 12, color: Colors.white)),
            Text('Estado : $estado',
                style: const TextStyle(fontSize: 12, color: Colors.white)),
            Text('Costo Envio : $costoEnvio',
                style: const TextStyle(fontSize: 12, color: Colors.white)),
            Text('Cantidad Mercancia : $cantidadMercancia',
                style: const TextStyle(fontSize: 12, color: Colors.white)),
          ]),
        ));
  }
}
