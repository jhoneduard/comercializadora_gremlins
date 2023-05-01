import 'package:comercializadora_gremlins/models/models.dart';
import 'package:comercializadora_gremlins/screens/loading_screen.dart';
import 'package:comercializadora_gremlins/services/services.dart';
import 'package:comercializadora_gremlins/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PackedDetailScreen extends StatelessWidget {
  const PackedDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: const Text('Gestion de envio de Productos'),
      automaticallyImplyLeading: false,
      leading: IconButton(onPressed: () {}, icon: const Icon(Icons.gif_box)),
    );

    final packedDetailService = Provider.of<PackedDetailService>(context);
    if (packedDetailService.isLoading) {
      return LoadingScreen(appBar: appBar);
    }

    return Scaffold(
      appBar: appBar,
      body: ListView.builder(
        itemCount: packedDetailService.listaDetalleEmpacado.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            packedDetailService.detalleSeleccionado =
                packedDetailService.listaDetalleEmpacado[index].copy();
            Navigator.pushNamed(context, 'sends');
          },
          child: PackedDetailCard(
              detalleEmpacado: packedDetailService.listaDetalleEmpacado[index]),
        ),
      ),
      floatingActionButton: CustomFloatingActionsPackedDetail(
          packedDetailService: packedDetailService),
    );
  }
}

class CustomFloatingActionsPackedDetail extends StatelessWidget {
  final PackedDetailService packedDetailService;
  const CustomFloatingActionsPackedDetail(
      {super.key, required this.packedDetailService});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'home');
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined)),
        const SizedBox(width: 30),
        FloatingActionButton(
            onPressed: () {
              DateTime currentDate = DateTime.now();
              packedDetailService.detalleSeleccionado = DetalleEmpacado(
                  idCliente: '',
                  idProducto: '',
                  descripcion: '',
                  direccion: '',
                  fechaEmpacado: currentDate.toString(),
                  estado: '',
                  costoEnvio: 0.0,
                  cantidadMercancia: 0);
              Navigator.pushNamed(context, 'sends');
            },
            child: const Icon(Icons.add)),
      ],
    );
  }
}
