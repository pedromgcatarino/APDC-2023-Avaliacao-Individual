import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]) : super();

  @override
  List<Object> get props => [];

  String get msg;

  int get code;
}

// General failures

// CODE 0
class TokenError extends Failure {
  const TokenError();

  @override
  int get code => 0;

  @override
  String get msg => "AuthToken is not valid";
}

// CODE 1
class InputError extends Failure {
  const InputError();

  @override
  int get code => 1;

  @override
  String get msg => "Input is not valid";
}

// CODE 2
class UserNotFoundError extends Failure {
  const UserNotFoundError();

  @override
  int get code => 2;

  @override
  String get msg => "User does not exist";
}

// CODE 3
class UserExistsError extends Failure {
  const UserExistsError();

  @override
  int get code => 3;

  @override
  String get msg => "User already exists";
}

// CODE 4
class PasswordError extends Failure {
  const PasswordError();

  @override
  int get code => 4;

  @override
  String get msg => "Password is incorrect";
}

// CODE 5
class RoleError extends Failure {
  const RoleError();

  @override
  int get code => 5;

  @override
  String get msg => "You do not have permission for that";
}

// CODE 6
class ServerError extends Failure {
  const ServerError();

  @override
  int get code => 6;

  @override
  String get msg => "Internal Server Error";
}

// CODE 7
class ConnectionError extends Failure {
  const ConnectionError();

  @override
  int get code => 7;

  @override
  String get msg => "Could not connect to the internet";
}

// CODE 8
class HttpError extends Failure {
  const HttpError();

  @override
  int get code => 8;

  @override
  String get msg => "HTTP Error";
}
