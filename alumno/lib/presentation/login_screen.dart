// // ignore_for_file: prefer_const_constructors
// import 'package:alumno/core/entities/User.dart';
// import 'package:alumno/core/entities/UserManager.dart';
// import 'package:alumno/presentation/calendar_screen.dart';
// import 'package:alumno/presentation/register_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class LoginScreen extends StatelessWidget {
//   static const String name = 'LoginScreen';

//   LoginScreen({super.key});

//   final TextEditingController _userTextFieldController =
//       TextEditingController();
//   final TextEditingController _passwordTextFieldController =
//       TextEditingController();
//   final UserManager userManager = UserManager();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Color.fromARGB(255, 255, 255, 255),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset(
//                   'assets/image/gofit-logo.jpg',
//                   width: 200,
//                   height: 200,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: TextField(
//                   controller: _userTextFieldController,
//                   decoration: InputDecoration(
//                     fillColor: Color.fromARGB(255, 92, 92, 92),
//                     label: Text('Email')
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: TextField(
//                   controller: _passwordTextFieldController,
//                   obscureText: true, 
//                   decoration: InputDecoration(
//                     fillColor: Color.fromARGB(255, 92, 92, 92),
//                     label: Text('Contraseña'),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               SizedBox(
//                 width: 200,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color.fromARGB(255, 22, 22, 180),
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                   ),
//                   onPressed: () async {
//                     if (_userTextFieldController.text.isEmpty ||
//                         _passwordTextFieldController.text.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Por favor, ingrese los dos campos!'),
//                           backgroundColor: Color.fromARGB(255, 206, 28, 28),
//                         ),
//                       );
//                     } else {
//                       bool loginSuccess = await userManager.login(_userTextFieldController.text,
//                           _passwordTextFieldController.text);
//                       Usuario? usuario = userManager.getLoggedUser();
//                       if (loginSuccess && usuario != null) {
//                         context.goNamed(CalendarioScreen.name);
//                         userManager.setLoggedUser(usuario);
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                                 'Las credenciales no coinciden con ningun usuario registrado!'),
//                             backgroundColor: Color.fromARGB(255, 206, 28, 28),
//                           ),
//                         );
//                       }
//                     }
//                   },
//                   child: const Text(
//                     'INICIAR SESIÓN',
//                     style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 30),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       '¿No tenes una cuenta? ',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         context.goNamed(RegisterScreen.name);
//                       },
//                       child: const Text('Regístrate', style: TextStyle(decoration: TextDecoration.underline ,fontSize: 16, color: Color.fromARGB(255, 22, 22, 180), fontWeight: FontWeight.bold)),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:alumno/core/entities/User.dart';
import 'package:alumno/core/entities/UserManager.dart';
import 'package:alumno/presentation/calendar_screen.dart';
import 'package:alumno/presentation/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userTextFieldController = TextEditingController();
  final TextEditingController _passwordTextFieldController = TextEditingController();
  final UserManager userManager = UserManager();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/image/gofit-logo.jpg',
                  width: 200,
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: _userTextFieldController,
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 92, 92, 92),
                    label: Text('Email'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: _passwordTextFieldController,
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 92, 92, 92),
                    label: Text('Contraseña'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 22, 22, 180),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    if (_userTextFieldController.text.isEmpty ||
                        _passwordTextFieldController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, ingrese los dos campos!'),
                          backgroundColor: Color.fromARGB(255, 206, 28, 28),
                        ),
                      );
                    } else {
                      bool loginSuccess = await userManager.login(
                          _userTextFieldController.text,
                          _passwordTextFieldController.text);
                      Usuario? usuario = userManager.getLoggedUser();

                      if (loginSuccess && usuario != null && mounted) {
                        // Verificar si el widget sigue montado antes de navegar
                        userManager.setLoggedUser(usuario);
                        context.goNamed(CalendarioScreen.name);
                        
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Las credenciales no coinciden con ningun usuario registrado!'),
                            backgroundColor: Color.fromARGB(255, 206, 28, 28),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'INICIAR SESIÓN',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tenes una cuenta? ',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        context.goNamed(RegisterScreen.name);
                      },
                      child: const Text('Regístrate',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              color: Color.fromARGB(255, 22, 22, 180),
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
