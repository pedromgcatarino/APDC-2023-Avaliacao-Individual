import 'dart:io';

import 'package:adc_app_flutter/core/errors/exceptions.dart';
import 'package:adc_app_flutter/data/datasources/rest_api.dart';
import 'package:adc_app_flutter/data/models/login_data.dart';
import 'package:adc_app_flutter/data/models/roles_input_data.dart';
import 'package:adc_app_flutter/domain/entities/user.dart';
import 'package:adc_app_flutter/core/errors/failures.dart';
import 'package:adc_app_flutter/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/auth_token.dart';
import '../models/auth_token_model.dart';
import '../models/password_input_model.dart';
import '../models/user_model.dart';

class RepositoryImpl implements Repository {
  final remoteDataSource = RestApiManager();

  @override
  Future<Either<Failure, void>> changePassword(PasswordInputModel data) async {
    try {
      await remoteDataSource.changePassword(data);
      return const Right(null);
    } on TokenNotValidException {
      return const Left(TokenError());
    } on UserNotFoundException {
      return const Left(UserNotFoundError());
    } on InvalidInputException {
      return const Left(InputError());
    } on WrongPasswordException {
      return const Left(PasswordError());
    } on ServerException {
      return const Left(ServerError());
    } on SocketException {
      return const Left(ConnectionError());
    } on HttpException {
      return const Left(HttpError());
    }
  }

  @override
  Future<Either<Failure, void>> changeUserAttributes(
      UserModel updatedUser) async {
    try {
      await remoteDataSource.changeUserAttributes(updatedUser);
      return const Right(null);
    } on TokenNotValidException {
      return const Left(TokenError());
    } on UserNotFoundException {
      return const Left(UserNotFoundError());
    } on NotPermittedException {
      return const Left(RoleError());
    } on ServerException {
      return const Left(ServerError());
    } on SocketException {
      return const Left(ConnectionError());
    } on HttpException {
      return const Left(HttpError());
    }
  }

  @override
  Future<Either<Failure, List<User>>> listUsers() async {
    try {
      final result = await remoteDataSource.listUsers();
      final solution = result.map((e) => e.toEntity()).toList();
      return Right(solution);
    } on TokenNotValidException {
      return const Left(TokenError());
    } on UserNotFoundException {
      return const Left(UserNotFoundError());
    } on ServerException {
      return const Left(ServerError());
    } on SocketException {
      return const Left(ConnectionError());
    } on HttpException {
      return const Left(HttpError());
    }
  }

  @override
  Future<Either<Failure, void>> login(LoginData data) async {
    try {
      await remoteDataSource.login(data);
      return const Right(null);
    } on InvalidInputException {
      return const Left(InputError());
    } on UserNotFoundException {
      return const Left(UserNotFoundError());
    } on WrongPasswordException {
      return const Left(PasswordError());
    } on ServerException {
      return const Left(ServerError());
    } on SocketException {
      return const Left(ConnectionError());
    } on HttpException {
      return const Left(HttpError());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException {
      return const Left(ServerError());
    } on SocketException {
      return const Left(ConnectionError());
    } on HttpException {
      return const Left(HttpError());
    }
  }

  @override
  Future<Either<Failure, void>> register(UserModel user) async {
    try {
      await remoteDataSource.register(user);
      return const Right(null);
    } on InvalidInputException {
      return const Left(InputError());
    } on UserExistsException {
      return const Left(UserExistsError());
    } on ServerException {
      return const Left(ServerError());
    } on SocketException {
      return const Left(ConnectionError());
    } on HttpException {
      return const Left(HttpError());
    }
  }

  @override
  Future<Either<Failure, void>> removeUser(String username) async {
    try {
      await remoteDataSource.removeUser(username);
      return const Right(null);
    } on TokenNotValidException {
      return const Left(TokenError());
    } on UserNotFoundException {
      return const Left(UserNotFoundError());
    } on NotPermittedException {
      return const Left(RoleError());
    } on ServerException {
      return const Left(ServerError());
    } on SocketException {
      return const Left(ConnectionError());
    } on HttpException {
      return const Left(HttpError());
    }
  }

  @override
  Future<Either<Failure, AuthToken>> showToken() async {
    try {
      AuthTokenModel token = await remoteDataSource.showToken();
      return Right(token.toEntity());
    } on TokenNotValidException {
      return const Left(TokenError());
    }
  }

  @override
  Future<Either<Failure, User>> getUser(String username) async {
    try {
      UserModel user = await remoteDataSource.getUser(username);
      return Right(user.toEntity());
    } on TokenNotValidException {
      return const Left(TokenError());
    } on UserNotFoundException {
      return const Left(UserNotFoundError());
    } on NotPermittedException {
      return const Left(RoleError());
    } on ServerException {
      return const Left(ServerError());
    } on SocketException {
      return const Left(ConnectionError());
    } on HttpException {
      return const Left(HttpError());
    }
  }

  @override
  Future<Either<Failure, void>> changeUserRoles(RolesInputData data) async {
    try {
      await remoteDataSource.changeUserRoles(data);
      return const Right(null);
    } on TokenNotValidException {
      return const Left(TokenError());
    } on UserNotFoundException {
      return const Left(UserNotFoundError());
    } on NotPermittedException {
      return const Left(RoleError());
    } on ServerException {
      return const Left(ServerError());
    } on SocketException {
      return const Left(ConnectionError());
    } on HttpException {
      return const Left(HttpError());
    }
  }
}
