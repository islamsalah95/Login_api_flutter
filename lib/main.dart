import 'package:authentcation/core/api/DioConsumer.dart';
import 'package:authentcation/core/database/CacheHelper.dart';
import 'package:authentcation/features/authentcation/presentation/cubit/auth_cubit.dart';
import 'package:authentcation/features/authentcation/presentation/views/HomeScreen.dart';
import 'package:authentcation/features/authentcation/presentation/views/SignUp.dart';
import 'package:authentcation/features/authentcation/presentation/views/SignIn.dart';
import 'package:authentcation/features/authentcation/presentation/views/UpdateProfile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.initial();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(DioConsumer(dio: Dio())),
      child: MaterialApp(
        title: 'Authentication',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: SignIn.routeName, // Set the initial route
        routes: {
          SignUp.routeName: (context) => const SignUp(),
          SignIn.routeName: (context) => const SignIn(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          UpdateProfile.routeName: (context) => const UpdateProfile(),

        },
      ),
    );
  }
}
