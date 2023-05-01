import 'package:comercializadora_gremlins/models/models.dart';
import 'package:flutter/material.dart';

class PackedDetailFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DetalleEmpacado detalleEmpacado;

  PackedDetailFormProvider(this.detalleEmpacado);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
