part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
class AuthLogin extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}




class SignUpLogin extends AuthState {}
class SignUpSuccess extends AuthState {
  final SignUpModel signUpModel;
  SignUpSuccess({required this.signUpModel});
}
class SignUpError extends AuthState {
  final String message;
  SignUpError({required this.message});
}



class GetUserDataLoading extends AuthState {}
class GetUserDataSuccess extends AuthState {
  final UserModel user;
  GetUserDataSuccess({required this.user});
}
class GetUserDataError extends AuthState {
  final String message;
  GetUserDataError({required this.message});
}






// State for successful logout
class AuthLoggedOutSuccess extends AuthState {}
// State for logout failure, if needed
class AuthLogoutFailed extends AuthState {
  final String error;
  AuthLogoutFailed({required this.error});
}


class LoadingUpdate extends AuthState {}
class UpdateSuccess extends AuthState {
  final UpdateProfileModel updateProfileModel;
  UpdateSuccess({required this.updateProfileModel});
}
class UpdateError extends AuthState {
  final String message;
  UpdateError({required this.message});
}



class UploadImage extends AuthState {}
