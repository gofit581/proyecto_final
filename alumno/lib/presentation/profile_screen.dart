import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  static const String name = 'ProfileScreen';

  const MyProfileScreen({super.key});
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/image/BACK.jpg',
            width: 80,
            height: 80,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/image/SETTINGS.jpg',
              width: 80,
              height: 80,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Image.asset(
              'assets/image/EDIT.jpg',
              width: 80,
              height: 80,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    backgroundImage: AssetImage('assets/image/USER-PHOTO.jpg'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nombre Completo',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    padding: const EdgeInsets.only(bottom: 8),
                    child: const Text(
                      ' ',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Apellido',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    padding: const EdgeInsets.only(bottom: 8),
                    child: const Text(
                      '',
                      style: TextStyle(fontSize: 16, color: Colors.black),
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
                    padding: const EdgeInsets.only(bottom: 8),
                    child: const Text(
                      '',
                      style: TextStyle(fontSize: 16, color: Colors.black),
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
                    print('Ver rutina presionado');
                  },
                  child: const Text(
                    'VER RUTINA',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}