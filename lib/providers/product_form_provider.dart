import 'package:comercializadora_gremlins/models/models.dart';
import 'package:flutter/material.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Producto product;

  // Cada vez que llamamos el constructor de ese ProductFormProvider
  // Indicamos que recibimos el producto...
  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    product.estado = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
