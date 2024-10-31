import 'package:authentcation/core/api/ApiConsumer.dart';
import 'package:authentcation/core/api/DioConsumer.dart';
import 'package:authentcation/core/api/Endpoints.dart';
import 'package:authentcation/core/database/CacheHelper.dart';
import 'package:authentcation/core/errors/ServerExceptions.dart';
import 'package:authentcation/core/functions/UploadImageToApi.dart';
import 'package:authentcation/core/models/SignInModel.dart';
import 'package:authentcation/core/models/SignUpModel.dart';
import 'package:authentcation/core/models/UpdateProfileModel.dart';
import 'package:authentcation/core/models/UpdateProfileModel.dart';
import 'package:authentcation/core/models/UserModel.dart';
import 'package:authentcation/features/authentcation/presentation/views/HomeScreen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'dart:convert'; // Add this import at the top
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.api) : super(AuthInitial());

  final ApiConsumer api;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  SignInModel? userSignIn;
  SignUpModel? userSignUp;
  UserModel? userData;

  XFile? profileImage;

  TextEditingController emailUp = TextEditingController();
  TextEditingController passwordUp = TextEditingController();
  TextEditingController confirmPasswordUp = TextEditingController();
  TextEditingController nameUp = TextEditingController();
  TextEditingController phoneUp = TextEditingController();

  TextEditingController nameUpdateProfile = TextEditingController();
  TextEditingController emailUpdateProfile = TextEditingController();
  TextEditingController phoneUpdateProfile = TextEditingController();
  TextEditingController passwordUpdateProfile = TextEditingController();

  dynamic uploadImage(XFile img) async {
    img = profileImage!;
    emit(UploadImage());
  }

  void signUp() async {
    try {
      emit(SignUpLogin());

      // Prepare data for sign-up
      final data = {
        ApiKey.name: nameUp.text,
        ApiKey.phone: phoneUp.text,
        ApiKey.email: emailUp.text,
        ApiKey.password: passwordUp.text,
        ApiKey.confirmPassword: confirmPasswordUp.text,
        ApiKey.location: '''{
        "name":"methalfa",
        "address":"meet halfa",
        "coordinates":[30.1572709,31.224779]
      }''',
      };

      // Perform the sign-up API call
      final response = await api.post(Endpoints.signUp, data: data);

      // Parse and handle response
      final responseData = response.data;
      if (responseData != null) {
        userSignUp = SignUpModel.fromJson(responseData);
        emit(SignUpSuccess(signUpModel: SignUpModel.fromJson(responseData)));
        print('Sign-up successful: $userSignUp');
      } else {
        throw Exception("Empty response data");
      }
    } on ServerExceptions catch (e) {
      emit(SignUpError(message: e.errorModel.message));
      print('Sign-up error: ${e.errorModel.message}');
    } catch (e) {
      emit(SignUpError(
          message: 'An unexpected error occurred: ${e.toString()}'));
      print('Sign-up unexpected error: ${e.toString()}');
    }
  }

  void signin() async {
    try {
      emit(AuthLogin());

      // Perform the sign-in API call
      final response = await api.post(
        Endpoints.signIn,
        data: {
          ApiKey.email: email.text,
          ApiKey.password: password.text,
        },
      );

      // Handle the response data
      final responseData = response.data;
      if (responseData != null &&
          responseData.containsKey('user') &&
          responseData.containsKey('token')) {
        final user = responseData['user'];
        final token = responseData['token'];

        print("Raw user data: $user");
        print("Raw token data: $token");

        // Save the token in cache
        await CacheHelper.saveData(key: ApiKey.token, value: token);
        print("Token saved: $token");

        // Fetch user data after sign-in
        await this.getUserData();

        print('success');
        emit(AuthSuccess());
        print('success2');
      } else {
        throw Exception("Unexpected response format");
      }
    } on ServerExceptions catch (e) {
      emit(AuthError(message: e.errorModel.message));
      print('Sign-in error: ${e.errorModel.message}');
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred: ${e.toString()}'));
      print('Sign-in unexpected error: ${e.toString()}');
    }
  }

  dynamic getUserData() async {
    try {
      emit(GetUserDataLoading());

      // Fetch user data
      final userId = CacheHelper.getData(key: ApiKey.id);
      final response = await api.get(Endpoints.getUserEndPint(userId));

      print('error1');
      // Check response data
      final responseData = response.data;

      print('error2');

      if (responseData != null && responseData.containsKey('data')) {
        print('error3');

        userData = UserModel.fromJson(responseData['data']);
        print('error4');

        print(userData!.name);
        print(userData!.email);
        print(userData!.phone);

        // Save data to cache
        await CacheHelper.saveData(key: ApiKey.name, value: userData!.name);
        await CacheHelper.saveData(key: ApiKey.email, value: userData!.email);
        await CacheHelper.saveData(key: ApiKey.phone, value: userData!.phone);
        print('error5');

        // emit(GetUserDataSuccess(user: UserModel.fromJson(response.data['data'])));
      } else {
        print('error6');

        emit(GetUserDataError(message: "Invalid response format"));
      }
    } on ServerExceptions catch (e) {
      print('error7');

      emit(GetUserDataError(message: e.errorModel.message));
      print('Get user data error: ${e.errorModel.message}');
    } catch (e) {
      print('error8');

      emit(GetUserDataError(
          message: 'An unexpected error occurred: ${e.toString()}'));
      print('Get user data unexpected error: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      // Clear cache data
      await CacheHelper.clearData();

      // Emit the logged-out state
      emit(AuthLoggedOutSuccess());
      print('Logged out successfully');
    } catch (e) {
      emit(AuthLogoutFailed(error: e.toString()));
      print('Logout error: ${e.toString()}');
    }
  }

  void updateProfile() async {
    try {
      emit(LoadingUpdate());

      final response = await api.post(
        Endpoints.update,
        data: {
          ApiKey.email: emailUpdateProfile.text,
          ApiKey.name: nameUpdateProfile.text,
          ApiKey.phone: phoneUpdateProfile.text,
          ApiKey.password: passwordUpdateProfile.text,
        },
      );

      // Print raw response data
      print("Raw response data: ${response.data}");

      // Check if the response contains a valid message
      if (response.data != null && response.data is Map<String, dynamic>) {
        // Parse response data into UpdateProfileModel
        final updateProfileModel = UpdateProfileModel.fromJson(response.data);
        emit(UpdateSuccess(updateProfileModel: updateProfileModel));
      } else {
        emit(UpdateError(message: "Invalid response from server"));
      }
    } on ServerExceptions catch (e) {
      emit(AuthError(message: e.errorModel.message));
      print("Server error: ${e.errorModel.message}");
    } on FormatException catch (e) {
      emit(AuthError(message: 'Response format error: ${e.message}'));
      print("Format error: ${e.message}");
    } on Exception catch (e) {
      emit(AuthError(message: 'An unexpected error occurred.'));
      print("Unexpected error: ${e.toString()}");
    } catch (e) {
      emit(AuthError(message: 'An unknown error occurred: ${e.toString()}'));
      print("Unknown error: ${e.toString()}");
    }
  }
}

//   void updateProfile() async {
//     final String url =
//         'https://lightsteelblue-rail-575879.hostingersite.com/api/v1/user/update';
//     try {
//       Dio _dio = Dio();
//       _dio.options.headers['token'] =
//           'FOODAPI eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MThmZjBlMGMyYThmMTY3NTllNWNkNyIsImVtYWlsIjoiaXNsYW1AdGVjaHN1cC5jbyIsIm5hbWUiOiJzYWxhaCIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNzI5OTc0MzM5fQ.2HLGrQEFy6CcPSOoTUt3hm8OMdlTQrGS6HULlmbjQOE';
//       final data = {
//         ApiKey.name: "isajl",
//         ApiKey.phone: '01272570173',
//         ApiKey.location: '''{
//           "name":"methalfa",
//           "address":"meet halfa",
//           "coordinates":[30.1572709,31.224779]
//         }''',
//       };
//       final response = await _dio.patch(url, data: data);
//       if (response.statusCode == 200) {
//         print('User profile updated successfully: ${response}');
//       } else {
//         print('Failed to update user profile: ${response}');
//       }
//     } on DioError catch (e) {
//       if (e.response != null) {
//         print('Dio Error: ${e.response?.statusCode} - ${e.response?.data}');
//       } else {
//         print('Dio Error: ${e.message}');
//       }
//     } catch (e) {
//       print('An unexpected error occurred: ${e.toString()}');
//     }
//   }
// }







// import 'package:authentcation/core/api/ApiConsumer.dart';
// import 'package:authentcation/core/api/DioConsumer.dart';
// import 'package:authentcation/core/api/Endpoints.dart';
// import 'package:authentcation/core/database/CacheHelper.dart';
// import 'package:authentcation/core/errors/ServerExceptions.dart';
// import 'package:authentcation/core/functions/UploadImageToApi.dart';
// import 'package:authentcation/core/models/SignInModel.dart';
// import 'package:authentcation/core/models/SignUpModel.dart';
// import 'package:authentcation/core/models/UpdateProfileModel.dart';
// import 'package:authentcation/core/models/UpdateProfileModel.dart';
// import 'package:authentcation/core/models/UserModel.dart';
// import 'package:authentcation/features/authentcation/presentation/views/HomeScreen.dart';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:meta/meta.dart';
// import 'package:dio/dio.dart';
// import 'dart:convert'; // Add this import at the top
// part 'auth_state.dart';

// class AuthCubit extends Cubit<AuthState> {
//   AuthCubit(this.api) : super(AuthInitial());

//   final ApiConsumer api;
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//   SignInModel? userSignIn;
//   SignUpModel? userSignUp;
//   UserModel? userData;

//   XFile? profileImage;

//   TextEditingController emailUp = TextEditingController();
//   TextEditingController passwordUp = TextEditingController();
//   TextEditingController confirmPasswordUp = TextEditingController();
//   TextEditingController nameUp = TextEditingController();
//   TextEditingController phoneUp = TextEditingController();

//   TextEditingController nameUpdateProfile = TextEditingController();
//   TextEditingController emailUpdateProfile = TextEditingController();
//   TextEditingController phoneUpdateProfile = TextEditingController();
//   TextEditingController passwordUpdateProfile = TextEditingController();

//   uploadImage(XFile img) async {
//     img = profileImage!;
//     emit(UploadImage());
//   }

//   void signUp() async {
//     try {
//       emit(SignUpLogin());

//       // API request data including uploaded image URL
//       final response = await api.post(
//         Endpoints.signUp,
//         data: {
//           ApiKey.name: nameUp.text,
//           ApiKey.phone: phoneUp.text,
//           ApiKey.email: emailUp.text,
//           ApiKey.password: passwordUp.text,
//           ApiKey.confirmPassword: confirmPasswordUp.text,
//           ApiKey.location: '''{
//         "name":"methalfa",
//         "address":"meet halfa",
//         "coordinates":[30.1572709,31.224779]
//         }''',
//           // ApiKey.profilePic: uploadedImageUrl,
//         },
//       );

//       // Parse the response and save the user data
//       userSignUp = SignUpModel.fromJson(response);

//       // Emit success state with the signup model
//       emit(SignUpSuccess(
//         signUpModel: SignUpModel.fromJson(response),
//       ));
//     } on ServerExceptions catch (e) {
//       emit(SignUpError(message: e.errorModel.message));
//     } catch (e) {
//       emit(SignUpError(
//           message: 'An unexpected error occurred: ${e.toString()}'));
//     }
//   }

//   void signin() async {
//     try {
//       emit(AuthLogin());

//       final response = await api.post(
//         Endpoints.signIn,
//         data: {
//           ApiKey.email: email.text,
//           ApiKey.password: password.text,
//         },
//       );

//       // Ensure response.data is printed
//       print("Raw response data: ${response.data}");

//       // Check if response.data is not null and is a map
//       if (response.data != null && response.data is Map<String, dynamic>) {
//         // Safely parse the response into SignInModel
//         userSignIn =
//             SignInModel.fromJson(response.data as Map<String, dynamic>);

//         print("response userSignIn object: ${userSignIn}");

//         // Decode JWT token
//         final decodedToken = JwtDecoder.decode(userSignIn!.token);
//         print("response decodedToken: ${decodedToken}");

//         // Save data to cache
//         CacheHelper.saveData(key: ApiKey.token, value: userSignIn!.token);
//         print("Saved token: ${userSignIn!.token}");

//         CacheHelper.saveData(key: ApiKey.id, value: decodedToken['id']);
//         print("Saved decodedToken id: ${decodedToken['id']}");

//         this.getUserData();

//         emit(AuthSuccess());
//       } else {
//         // Handle unexpected response format
//         emit(AuthError(message: "Invalid response from server"));
//       }
//     } on ServerExceptions catch (e) {
//       emit(AuthError(message: e.errorModel.message));
//     } catch (e) {
//       emit(AuthError(message: 'An unexpected error occurred: ${e.toString()}'));
//     }
//   }

//   void getUserData() async {
//     try {
//       emit(GetUserDataLoading());

//       final response = await api.get(
//         Endpoints.getUserEndPint(CacheHelper.getData(key: ApiKey.id)),
//       );

//       // Ensure you're accessing the correct part of the response
//       print("Raw response data: ${response.data}");

//       // Check if response.data is not null and is a map
//       if (response.data != null && response.data is Map<String, dynamic>) {
//         userData = UserModel.fromJson(response.data);
//         print('Parsed userData: $userData');
//         print(userData!.email);

//         // Save data to cache
//         CacheHelper.saveData(key: ApiKey.name, value: userData!.name);
//         CacheHelper.saveData(key: ApiKey.email, value: userData!.email);
//         CacheHelper.saveData(key: ApiKey.phone, value: userData!.phone);
//         CacheHelper.saveData(
//             key: ApiKey.coordinates, value: userData!.coordinates);
//         // Emit success state
//         emit(GetUserDataSuccess(user: UserModel.fromJson(response)));
//       } else {
//         emit(GetUserDataError(message: "Invalid response format"));
//       }
//     } on ServerExceptions catch (e) {
//       emit(GetUserDataError(message: e.errorModel.message));
//     } catch (e) {
//       emit(GetUserDataError(
//           message: 'An unexpected error occurred: ${e.toString()}'));
//     }
//   }

//   Future<void> logout() async {
//     try {
//       // Clear cache data
//       await CacheHelper.clearData();

//       // Emit the logged-out state or initial state after logout
//       emit(AuthLoggedOutSuccess());
//     } catch (e) {
//       // Handle any errors and emit a failure state if needed
//       emit(AuthLogoutFailed(error: e.toString()));
//     }
//   }

// // void updateProfile() async {
// //   try {
// //     emit(LoadingUpdate());

// //     final response = await api.patch(
// //       Endpoints.update,
// //       data: {
// //         // ApiKey.name: nameUpdateProfile.text,
// //         // ApiKey.phone: phoneUpdateProfile.text,
// //         // ApiKey.password:passwordUpdateProfile.text,

// //         ApiKey.name: 'dfdfdf',
// //         ApiKey.phone: '01272570173',
// //         ApiKey.location: '''{
// //           "name":"methalfa",
// //           "address":"meet halfa",
// //           "coordinates":[30.1572709,31.224779]
// //         }''',
// //       },
// //     );

// //     // Ensure response.data is printed
// //     print("Raw response data: ${response}");

// //     // Check if response.message is not null
// //     if (response.message != null) {
// //       emit(UpdateSuccess(updateProfileModel: UpdateProfileModel(message: response)));
// //     } else {
// //       emit(UpdateError(message: "Invalid response from server"));
// //     }
// //   } on ServerExceptions catch (e) {
// //     // Log specific server error
// //     emit(AuthError(message: e.errorModel.message));
// //     print("Server error: ${e.errorModel.message}");
// //   } on FormatException catch (e) {
// //     // Handle format errors specifically
// //     emit(AuthError(message: 'Response format error: ${e.message}'));
// //     print("Format error: ${e.message}");
// //   } on Exception catch (e) {
// //     // Catch any other types of exceptions
// //     emit(AuthError(message: 'An unexpected error occurred.'));
// //     print("Unexpected error: ${e.toString()}");
// //   } catch (e) {
// //     // Fallback for any other errors
// //     emit(AuthError(message: 'An unknown error occurred: ${e.toString()}'));
// //     print("Unknown error: ${e.toString()}");
// //   }
// // }

//   void updateProfile() async {
//     final String url = 'https://food-api-omega.vercel.app/api/v1/user/update';
//     try {
//       Dio _dio = Dio();
//       _dio.options.headers['token'] ='FOODAPI eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MThmZjBlMGMyYThmMTY3NTllNWNkNyIsImVtYWlsIjoiaXNsYW1AdGVjaHN1cC5jbyIsIm5hbWUiOiJzYWxhaCIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNzI5OTc0MzM5fQ.2HLGrQEFy6CcPSOoTUt3hm8OMdlTQrGS6HULlmbjQOE';
//       final data = {
//         ApiKey.name: "isajl",
//         ApiKey.phone: '01272570173',
//         ApiKey.location: '''{
//           "name":"methalfa",
//           "address":"meet halfa",
//           "coordinates":[30.1572709,31.224779]
//         }''',
//       };
//       final response = await _dio.patch(url, data: data);
//       if (response.statusCode == 200) {
//         print('User profile updated successfully: ${response}');
//       } else {
//         print('Failed to update user profile: ${response}');
//       }
//     } on DioError catch (e) {
//       if (e.response != null) {
//         print('Dio Error: ${e.response?.statusCode} - ${e.response?.data}');
//       } else {
//         print('Dio Error: ${e.message}');
//       }
//     } catch (e) {
//       print('An unexpected error occurred: ${e.toString()}');
//     }
//   }
// }
