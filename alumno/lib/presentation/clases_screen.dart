import 'dart:convert';
import 'package:alumno/presentation/payment_screen.dart';
import 'package:alumno/widget/custom_app_bar.dart';
import 'package:alumno/widget/custom_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:alumno/core/entities/Clase.dart';
import 'package:alumno/core/entities/Entrenador.dart';
import 'package:http/http.dart' as http;

class ClasesScreen extends StatelessWidget {
  static const String name = 'ClasesScreen';
  final DateTime date;
  final userManager = UserManager();
  final Clase? claseElegida;
  final bool? estadoOperacion;

  ClasesScreen({
    super.key,
    required this.date,
    this.claseElegida,
    this.estadoOperacion, 
  });

  @override
  Widget build(BuildContext context) {
    final usuario = userManager.getLoggedUser();
    final Entrenador? profesor = usuario?.getProfesor();
    final List<Clase> clasesDelDia = [];

    if (claseElegida != null && estadoOperacion == true) {
      userManager.reservarClase(claseElegida!.id);
      profesor?.agenda
          ?.firstWhere((element) => element.id == claseElegida!.id)
          .alumno = usuario;
      print(claseElegida);
    }

    if (profesor != null && profesor.agenda != null) {
      clasesDelDia.addAll(profesor.agenda!
          .where((clase) =>
              clase.horaInicio.year == date.year &&
              clase.horaInicio.month == date.month &&
              clase.horaInicio.day == date.day &&
              clase.alumno == null) // Filtrar clases con alumno == null
          .toList());
    }

    if (estadoOperacion == true && claseElegida != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showClaseDetailsDialog(context, claseElegida!);
      });
    } else if (estadoOperacion == false) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _showErrorDialog(context);
  });
}

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Clases del ${date.day}/${date.month}/${date.year}',
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      body: clasesDelDia.isNotEmpty
          ? ListView.builder(
              itemCount: clasesDelDia.length,
              itemBuilder: (context, index) {
                final clase = clasesDelDia[index];
                return Container(
                  color: Colors.green, // Solo renderiza clases disponibles
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hora de comienzo: ${clase.horaInicio.hour}:${clase.horaInicio.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Duración: ${clase.duracionHs} horas',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Precio: \$${clase.precio}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            // Crear el cuerpo de la solicitud con los datos de la clase
                            final body = {
                              'title': "", // Usa el campo correspondiente de la clase
                              'quantity':
                                  1, // Usualmente, la cantidad es 1 para reservas
                              'unit_price': clase.precio, // Precio de la clase
                              'currency_id':
                                  'ARS', // Ajusta según sea necesario
                            };

                            // Hacer la solicitud al backend
                            final response = await http.post(
                              Uri.parse(
                                  'http://10.0.2.2:3000/create_preferences'),
                              headers: {'Content-Type': 'application/json'},
                              body: json
                                  .encode(body), // Convertir el cuerpo a JSON
                            );
                            print(response.body);
                            if (response.statusCode == 200) {
                              final res = json.decode(response.body);
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PaymentScreen(
                                      url: res["url"],
                                      date: this.date,
                                      claseElegida: clase,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              print(
                                  'Error en la solicitud: ${response.statusCode}');
                            }
                          } catch (e) {
                            print('Error: $e');
                          }
                        },
                        child: const Text('RESERVAR'),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                'No hay clases programadas para esta fecha.',
              ),
            ),
    );
  }

  void _showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Reserva no procesada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Su clase no ha podido ser abonada a través de MercadoPago. Por favor, inténtelo de nuevo o comuníquese con su entrenador. Gracias!',
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}


  void _showClaseDetailsDialog(BuildContext context, Clase clase) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Muchas gracias por tu reserva!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tu clase será el ${date.day}/${date.month}/${date.year}'),
              Text('Hora: ${clase.horaInicio.hour}:${clase.horaInicio.minute.toString().padLeft(2, '0')}'),
              Text('Duración: ${clase.duracionHs} minutos'),
              Text('Precio: \$${clase.precio}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
