import 'package:authentcation/core/api/Endpoints.dart';
import 'package:authentcation/core/models/UserModel.dart';
import 'package:authentcation/core/database/CacheHelper.dart';
import 'package:authentcation/features/authentcation/presentation/cubit/auth_cubit.dart';
import 'package:authentcation/features/authentcation/presentation/views/SignIn.dart';
import 'package:authentcation/features/authentcation/presentation/views/UpdateProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    String? name = CacheHelper.getData(key: ApiKey.name);
    String? email = CacheHelper.getData(key: ApiKey.email);
    String? phone = CacheHelper.getData(key: ApiKey.phone);
    List<double> coordinates = [23.6, -22.336]; // Example coordinates

    if (name != null && email != null && phone != null) {
      setState(() {
        userData = UserModel(
            name: name, email: email, phone: phone, coordinates: coordinates);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: userData == null
              ? const CircularProgressIndicator()
              : _buildUserCard(userData!),
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Column(
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
        RichText(
          text: TextSpan(
            text: 'Hi, ',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: user.name?.toUpperCase() ?? '',
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Text(
          'WELCOME IN MY APP',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'You have a phone number is ${user.phone} and your email is ${user.email} and your coordinates are ${user.coordinates}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushReplacementNamed(context, UpdateProfile.routeName);
          },
          icon: const Icon(Icons.update, color: Colors.blue),
          label: const Text(
            'update your data now!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 10),
        BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
          if (state is AuthLoggedOutSuccess) {
              Navigator.pushReplacementNamed(context, SignIn.routeName);
            }
          },
          builder: (context, state) {
            return ElevatedButton.icon(
              onPressed: () {
               context.read<AuthCubit>().logout();
              }, // Calls the logout function
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
            );
          },
        ),
      ],
    );
  }
}
