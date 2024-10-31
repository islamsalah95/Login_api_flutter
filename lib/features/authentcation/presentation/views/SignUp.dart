import 'package:authentcation/features/authentcation/presentation/cubit/auth_cubit.dart';
import 'package:authentcation/features/authentcation/presentation/views/SignIn.dart';
import 'package:authentcation/features/authentcation/presentation/widgets/Pickimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  static const String routeName = '/SignUp';

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          Navigator.pushReplacementNamed(context, SignIn.routeName);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('Sign Up'),
            centerTitle: true,
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.purple.shade700],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20.0),
                  const Center(child: Pickimage()),
                  const SizedBox(height: 20.0),
                  Icon(
                    Icons.add_moderator,
                    size: 70,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                            context.read<AuthCubit>().nameUp,
                            'Name',
                            'Please enter your name',
                            TextInputType.name),
                        const SizedBox(height: 10.0),
                        _buildTextField(
                          context.read<AuthCubit>().emailUp,
                          'Email',
                          'Please enter your email',
                          TextInputType.emailAddress,
                          isEmail: true,
                        ),
                        const SizedBox(height: 10.0),
                        _buildTextField(
                          context.read<AuthCubit>().phoneUp,
                          'Phone',
                          'Please enter your phone number',
                          TextInputType.phone,
                          isPhone: true,
                        ),
                        const SizedBox(height: 10.0),
                        _buildTextField(
                          context.read<AuthCubit>().passwordUp,
                          'Password',
                          'Please enter your password',
                          TextInputType.visiblePassword,
                          isObscure: true,
                        ),
                        const SizedBox(height: 10.0),
                        _buildTextField(
                          context.read<AuthCubit>().confirmPasswordUp,
                          'Confirm Password',
                          'Please confirm your password',
                          TextInputType.visiblePassword,
                          isObscure: true,
                        ),
                        const SizedBox(height: 20.0),
                        state is AuthLogin
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().signUp();
                                  }
                                },
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String errorText, TextInputType keyboardType,
      {bool isObscure = false, bool isEmail = false, bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade800,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        } else if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        } else if (isPhone && !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        } else if (isObscure && value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }
}
