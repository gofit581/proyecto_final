import 'package:flutter/material.dart';
import '../widget/custom_app_bar.dart';
import '../widget/custom_botton_navigation_bar.dart';
import '../core/entities/User.dart';


class StudentProfileScreen extends StatefulWidget {
  static const String name = 'ProfileScreen';
  final Usuario usuarioSeleccionado;

  StudentProfileScreen({super.key, required this.usuarioSeleccionado});

  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

   Future<void> _loadUserData() async {
      setState(() {
      });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: 'Student Profile',
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/image/BANNER.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: (MediaQuery.of(context).size.width / 2) - 50,
                        bottom: 0,
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/image/USER-PHOTO.jpg'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nombre y Apellido',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            widget.usuarioSeleccionado.toString(),
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Email',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            widget.usuarioSeleccionado.getEmail(),
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Fecha de Nacimiento',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child:  Text(
                            widget.usuarioSeleccionado.getAge(),
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 22, 22, 180),
                          elevation: 5,
                          fixedSize: const Size(170, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          //Metodo de Luana
                        },
                        child: const Text(
                          'Ver Rutina',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 22, 22, 180),
                          elevation: 5,
                          fixedSize: const Size(170, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          //Metodo de Luana
                        },
                        child: const Text(
                          'Asignar Rutina',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}