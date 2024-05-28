part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthEventLogin extends AuthEvent {
  AuthEventLogin(this.email, this.pass);
  String email;
  String pass;
}

class AuthEventLogout extends AuthEvent {}
