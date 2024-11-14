import 'package:flutter/material.dart';
import '../core/entities/User.dart';
import '../core/entities/UserManager.dart';
import '../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  final Usuario usuario;
  final AuthService authService;

  const EditProfileScreen({super.key, required this.usuario, required this.authService});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  late TextEditingController _mailController;
  late TextEditingController _ageController;
  late TextEditingController _experienceController;
  late TextEditingController _disciplineController;
  late TextEditingController _trainingDaysController;
  late TextEditingController _trainingDurationController;
  late TextEditingController _injuriesController;
  late TextEditingController _extraActivitiesController;


  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.usuario.userName);
    _passwordController = TextEditingController(text: widget.usuario.password);
    _mailController = TextEditingController(text: widget.usuario.mail);
    _ageController = TextEditingController(text: widget.usuario.age.toString());
    _experienceController = TextEditingController(text: widget.usuario.experience ?? "");
    _disciplineController = TextEditingController(text: widget.usuario.discipline ?? "");
    _trainingDaysController = TextEditingController(text: widget.usuario.trainingDays.toString());
    _trainingDurationController = TextEditingController(text: widget.usuario.trainingDuration.toString());
    _injuriesController = TextEditingController(text: widget.usuario.injuries ?? "");
    _extraActivitiesController = TextEditingController(text: widget.usuario.extraActivities ?? "");
  }

 Future<void> _saveProfile() async {
  final UserManager userManager = UserManager();
  if (_formKey.currentState!.validate()) {
    final updatedUser = Usuario(
      id: widget.usuario.id,
      userName: _userNameController.text,
      password: _passwordController.text,
      mail: widget.usuario.mail, 
      age: widget.usuario.age, 
      idTrainer: widget.usuario.idTrainer, 
      objectiveDescription: widget.usuario.objectiveDescription, 
      experience: _experienceController.text,
      discipline: _disciplineController.text,
      trainingDays: _trainingDaysController.text,
      trainingDuration: _trainingDurationController.text,
      injuries: _injuriesController.text,
      extraActivities: _extraActivitiesController.text,
      actualSesion: widget.usuario.actualSesion,
    );


    bool isMailValid = true;
    if (widget.usuario.mail != updatedUser.mail) {
      isMailValid = await widget.authService.validateMail(updatedUser.mail);
    }

    if (isMailValid) {
      userManager.setLoggedUser(widget.usuario); 
      bool isUpdated = await widget.authService.updateUser(updatedUser);
      if (isUpdated) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context, updatedUser);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado exitosamente')),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar el perfil')),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El correo electrónico ya está en uso')),
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Nombre de Usuario', _userNameController),
              _buildTextField('Contraseña', _passwordController),
              _buildTextField('Correo Electrónico', _mailController, readOnly: true),
              _buildTextField('Edad', _ageController, isNumeric: true, readOnly: true),
              _buildTextField('Experiencia', _experienceController),
              _buildTextField('Disciplina', _disciplineController),
              _buildTextField('Días de Entrenamiento', _trainingDaysController, isNumeric: true),
              _buildTextField('Duración del Entrenamiento (min)', _trainingDurationController, isNumeric: true),
              _buildTextField('Lesiones', _injuriesController),
              _buildTextField('Actividades Extra', _extraActivitiesController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumeric = false, bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      readOnly: readOnly,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
    );
  }
}
