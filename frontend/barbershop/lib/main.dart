import 'package:barbershop/app/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Pacote intl para datas localizadas

void main() {
  // Inicializa as configurações de data em português
  initializeDateFormatting('pt_BR', null).then((_) {
    runApp(MyApp());
  });
}
