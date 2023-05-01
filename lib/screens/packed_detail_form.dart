import 'dart:io';

import 'package:comercializadora_gremlins/models/models.dart';
import 'package:comercializadora_gremlins/screens/alert_screen.dart';
import 'package:comercializadora_gremlins/screens/screens.dart';
import 'package:comercializadora_gremlins/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PackedDetailForm extends StatelessWidget {
  const PackedDetailForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final packedDetailService = Provider.of<PackedDetailService>(context);

    return ChangeNotifierProvider(
        create: (_) =>
            PackedDetailFormProvider(packedDetailService.detalleSeleccionado),
        child:
            _PackedDetailScreenBody(packedDetailService: packedDetailService));
  }
}

class _PackedDetailScreenBody extends StatelessWidget {
  const _PackedDetailScreenBody({required this.packedDetailService});
  final PackedDetailService packedDetailService;

  @override
  Widget build(BuildContext context) {
    List<Producto> listaProductos = packedDetailService.listaProductos;
    List<Usuario> listaClientes = packedDetailService.listaClientes;
    final packedDetailForm = Provider.of<PackedDetailFormProvider>(context);
    String titulo = packedDetailService.detalleSeleccionado.id == null
        ? 'Registro de envio'
        : 'Edicion de envio';

    return Scaffold(
        appBar: AppBar(title: Text(titulo)),
        body: SingleChildScrollView(
            child: Column(children: [
          _DetalleEmpacadoFormulario(
              listaClientes: listaClientes, listaProductos: listaProductos),
          const SizedBox(height: 100)
        ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          child: (packedDetailService.detalleSeleccionado.id == null)
              ? const Icon(Icons.save)
              : const Icon(Icons.save_as_rounded),
          onPressed: () async {
            // Si el boton no es valido que no continue
            if (!packedDetailForm.isValidForm()) {
              return;
            }

            if (packedDetailForm.detalleEmpacado.idCliente == '') {
              packedDetailForm.detalleEmpacado.idCliente =
                  listaClientes.first.id!;
            }

            if (packedDetailForm.detalleEmpacado.idProducto == '') {
              packedDetailForm.detalleEmpacado.idProducto =
                  listaProductos.first.id!;
            }

            packedDetailService
                .saveOrCreatePackedDetail(packedDetailForm.detalleEmpacado);
            // Si la opcion es de guardar
            if (packedDetailService.detalleSeleccionado.id == null) {
              Platform.isAndroid
                  ? AlertScreen.displayDialogAndroid(
                      context: context,
                      titulo: 'Registro creado con exito',
                      text: 'Se ha registrado con exito el empaquetado',
                      url: 'envios')
                  : AlertScreen.displayDialogIOS(
                      context: context,
                      titulo: 'Registro creado con exito',
                      text: 'Se ha registrado con exito el empaquetado',
                      url: 'envios');
            } else {
              Platform.isAndroid
                  ? AlertScreen.displayDialogAndroid(
                      context: context,
                      titulo: 'Registro actualizado con exito',
                      text: 'Se ha actualizado con exito el empaquetado',
                      url: 'envios')
                  : AlertScreen.displayDialogIOS(
                      context: context,
                      titulo: 'Registro actualizado con exito',
                      text: 'Se ha actualizado con exito el empaquetado',
                      url: 'envios');
            }
          },
        ));
  }
}

class _DetalleEmpacadoFormulario extends StatefulWidget {
  const _DetalleEmpacadoFormulario(
      {required this.listaProductos, required this.listaClientes});

  @override
  _DetalleEmpacadoFormularioState createState() =>
      // ignore: no_logic_in_create_state
      _DetalleEmpacadoFormularioState(
          listaProductos: listaProductos, listaClientes: listaClientes);
  final List<Producto> listaProductos;
  final List<Usuario> listaClientes;
}

class _DetalleEmpacadoFormularioState
    extends State<_DetalleEmpacadoFormulario> {
  final List<Producto> listaProductos;
  final List<Usuario> listaClientes;

  Future<String> _selectDate(BuildContext context, String fechaEmpacado) async {
    DateTime currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(fechaEmpacado),
        firstDate: DateTime(2020),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        fechaEmpacado = currentDate.toString();
      });
    }
    return fechaEmpacado;
  }

  _DetalleEmpacadoFormularioState(
      {required this.listaProductos, required this.listaClientes});
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

  @override
  Widget build(BuildContext context) {
    final packedDetailForm = Provider.of<PackedDetailFormProvider>(context);
    final detalleEmpacado = packedDetailForm.detalleEmpacado;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            decoration: _buildBoxDecoration(),
            child: Form(
              key: packedDetailForm.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: const [Icon(Icons.category), Text('Clientes')],
                  ),

                  DropdownButtonFormField(
                      value: (detalleEmpacado.id == null)
                          ? listaClientes.first
                          : listaClientes
                              .where((element) =>
                                  element.id == detalleEmpacado.idCliente)
                              .toList()
                              .last,
                      items: listaClientes
                          .map((usuario) => DropdownMenuItem<Usuario>(
                              value: usuario,
                              child: Text(
                                  '${usuario.tipoDocumento} ${usuario.identificacion} - ${usuario.nombre} ${usuario.apellido}')))
                          .toList(),
                      onChanged: (value) {
                        detalleEmpacado.idCliente = value.toString();
                      }),
                  //
                  const SizedBox(height: 10),
                  Row(
                    children: const [Icon(Icons.add_box), Text('Productos')],
                  ),
                  DropdownButtonFormField(
                      value: (detalleEmpacado.id == null)
                          ? listaProductos.first
                          : listaProductos
                              .where((element) =>
                                  element.id == detalleEmpacado.idProducto)
                              .toList()
                              .last,
                      items: listaProductos
                          .map((producto) => DropdownMenuItem<Producto>(
                              value: producto,
                              child: Text(
                                  '${producto.nombre} - precio : \$${producto.precio}')))
                          .toList(),
                      onChanged: (value) {
                        detalleEmpacado.idProducto = value.toString();
                      }),

                  const SizedBox(height: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Icon(Icons.book),
                            Text('Descripcion')
                          ],
                        ),
                        TextFormField(
                            maxLines: 3,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            initialValue: detalleEmpacado.direccion,
                            validator: (value) {
                              if (value == null) {
                                return 'El campo descripcion es requerido';
                              }
                              if (value.length < 3) {
                                return 'Minimo de tres digitos ';
                              }
                              if (value.length > 130) {
                                return 'Maximo de 130 digitos';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              detalleEmpacado.descripcion = value;
                            }),
                        const SizedBox(height: 10),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El precio de envio es requerido';
                              }

                              if (int.tryParse(value) != null &&
                                  double.parse(value) == 0) {
                                return 'El precio de envio debe ser mayor a cero';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.price_change),
                                hintText: '\$0.0',
                                labelText: 'Precio de envio: '),
                            initialValue: '${detalleEmpacado.costoEnvio}',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^(\d+)?\.?\d{0,2}'))
                            ],
                            onChanged: (value) {
                              // Validamos si se puede parsear el valor a double
                              // Si es igual a nulo, signifca que no se puede parsear...
                              if (double.tryParse(value) == null) {
                                detalleEmpacado.costoEnvio = 0;
                              } else {
                                detalleEmpacado.costoEnvio =
                                    double.parse(value);
                              }
                            }),
                        const SizedBox(height: 10),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'La cantidad de mercancia es requerida';
                              }

                              if (int.tryParse(value) != null &&
                                  int.parse(value) == 0) {
                                return 'La cantidad de mercancia debe ser mayor a cero';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.numbers),
                                hintText: '',
                                labelText: 'Stock : '),
                            initialValue:
                                '${detalleEmpacado.cantidadMercancia}',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'\d'))
                            ],
                            onChanged: (value) {
                              if (int.tryParse(value) == null) {
                                detalleEmpacado.cantidadMercancia = 0;
                              } else {
                                detalleEmpacado.cantidadMercancia =
                                    int.parse(value);
                              }
                            }),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Icon(Icons.directions),
                            Text('Direcion')
                          ],
                        ),
                        TextFormField(
                            maxLines: 3,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            initialValue: detalleEmpacado.descripcion,
                            validator: (value) {
                              if (value == null) {
                                return 'El campo direccion es requerido';
                              }
                              if (value.length < 3) {
                                return 'Minimo de tres digitos ';
                              }
                              if (value.length > 60) {
                                return 'Maximo de 60 digitos';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              detalleEmpacado.direccion = value;
                            }),
                        const SizedBox(height: 15),
                        Row(
                          children: const [
                            Icon(Icons.calendar_month),
                            Text('Fecha envio')
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            detalleEmpacado.fechaEmpacado = await _selectDate(
                                context, detalleEmpacado.fechaEmpacado);
                          },
                          child: const Text('Seleccionar'),
                        ),
                        const SizedBox(height: 10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 10),
                              Row(
                                children: const [
                                  Icon(Icons.bookmark),
                                  Text('Estado')
                                ],
                              ),
                              DropdownButtonFormField<String>(
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'Empacado',
                                        child: Text('Empacado')),
                                    DropdownMenuItem(
                                        value: 'Enviado',
                                        child: Text('Enviado')),
                                    DropdownMenuItem(
                                        value: 'Cancelado',
                                        child: Text('Cancelado')),
                                    DropdownMenuItem(
                                        value: 'Recibido',
                                        child: Text('Recibido')),
                                  ],
                                  value: (detalleEmpacado.id == null)
                                      ? 'Empacado'
                                      : detalleEmpacado.estado,
                                  onChanged: (value) {
                                    detalleEmpacado.estado = value!;
                                  })
                            ])
                      ]),
                ],
              ),
            )));
  }
}
