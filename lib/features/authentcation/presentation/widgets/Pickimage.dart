import 'dart:io';

import 'package:authentcation/features/authentcation/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class Pickimage extends StatelessWidget {
  const Pickimage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return context.read<AuthCubit>().profileImage == null
                ? CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("assets/profile.png"),
                  )
                : CircleAvatar(
                    radius: 80,
                    backgroundImage: FileImage(
                        File(context.read<AuthCubit>().profileImage!.path)),
                  );
          },
        ),
        IconButton(
            onPressed: () {
              ImagePicker().pickImage(source: ImageSource.gallery).then((val) {
                context.read<AuthCubit>().uploadImage(val!);
              });
            },
            icon: Icon(Icons.add_a_photo))
      ],
    );
  }
}
