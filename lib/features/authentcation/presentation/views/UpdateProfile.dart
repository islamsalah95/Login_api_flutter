import 'package:authentcation/core/api/Endpoints.dart';
import 'package:authentcation/core/models/UserModel.dart';
import 'package:authentcation/core/database/CacheHelper.dart';
import 'package:authentcation/features/authentcation/presentation/cubit/auth_cubit.dart';
import 'package:authentcation/features/authentcation/presentation/cubit/auth_cubit.dart';
import 'package:authentcation/features/authentcation/presentation/views/HomeScreen.dart';
import 'package:authentcation/features/authentcation/presentation/views/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfile extends StatefulWidget {
  static const String routeName = '/UpdateProfile';
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    String? name = CacheHelper.getData(key: ApiKey.name);
    String? email = CacheHelper.getData(key: ApiKey.email);
    String? phone = CacheHelper.getData(key: ApiKey.phone);

    if (name != null && email != null && phone != null) {
      _nameController.text = name;
      _emailController.text = email;
      _phoneController.text = phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if(state is UpdateSuccess){
         Navigator.pushNamed(context,SignIn.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: const Text(
              'Update Profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.purple.shade700],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                      context.read<AuthCubit>().nameUpdateProfile, 'Name'),
                  const SizedBox(height: 10),
                  _buildTextField(
                      context.read<AuthCubit>().emailUpdateProfile, 'Email'),
                  const SizedBox(height: 10),
                  _buildTextField(
                      context.read<AuthCubit>().phoneUpdateProfile, 'Phone'),
                  const SizedBox(height: 10),
                  _buildTextField(
                      context.read<AuthCubit>().passwordUpdateProfile,
                      'Password',
                      obscureText: true),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          context.read<AuthCubit>().updateProfile();
                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade800,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (label == 'Email' &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}
