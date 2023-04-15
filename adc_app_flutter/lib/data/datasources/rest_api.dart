import 'dart:convert';

import 'package:adc_app_flutter/core/errors/exceptions.dart';
import 'package:adc_app_flutter/data/models/auth_token_storage.dart';
import 'package:adc_app_flutter/data/models/login_data.dart';
import 'package:adc_app_flutter/data/models/password_input_model.dart';
import 'package:adc_app_flutter/data/models/roles_input_data.dart';
import 'package:adc_app_flutter/data/models/user_model.dart';
import 'package:adc_app_flutter/domain/entities/auth_token.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../core/constants/constants.dart';
import '../models/auth_token_model.dart';
import '../models/response_manager.dart';

abstract class RestApi {
  Future<void> register(UserModel user);
  Future<void> login(LoginData data);
  Future<void> removeUser(String username);
  Future<List<UserModel>> listUsers();
  Future<void> changeUserAttributes(UserModel updatedUser);
  Future<void> changeUserRoles(RolesInputData data);
  Future<void> changePassword(PasswordInputModel data);
  Future<void> logout();
  Future<AuthTokenModel> showToken();
  Future<UserModel> getUser(String username);
}

class RestApiManager implements RestApi {
  AuthTokenStorage tokenStorage = AuthTokenStorage();
  @override
  Future<void> changePassword(PasswordInputModel data) async {
    String? token = await tokenStorage.getAuthToken();
    debugPrint(token);
    final response = await http.put(
        Uri.parse('${ApiConstants.baseURL}${ApiConstants.passwordEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data.toJson()));

    if (response.statusCode == 200) {
      return;
    }
    if (response.statusCode == 409) {
      throw TokenNotValidException();
    }
    if (response.statusCode == 400) {
      throw InvalidInputException();
    }
    if (response.statusCode == 404) {
      throw UserNotFoundException();
    }
    if (response.statusCode == 403) {
      throw WrongPasswordException();
    }
  }

  @override
  Future<void> changeUserAttributes(UserModel updatedUser) async {
    String? token = await tokenStorage.getAuthToken();
    final response = await http.put(
        Uri.parse('${ApiConstants.baseURL}${ApiConstants.updateEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updatedUser.toJson()));

    if (response.statusCode == 200) {
      return;
    }
    if (response.statusCode == 409) {
      throw TokenNotValidException();
    }
    if (response.statusCode == 404) {
      throw UserNotFoundException();
    }
    if (response.statusCode == 403) {
      throw NotPermittedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<UserModel>> listUsers() async {
    String? token = await tokenStorage.getAuthToken();

    final response = await http.get(
        Uri.parse('${ApiConstants.baseURL}${ApiConstants.listUsersEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      return ResponseManager.fromJson(json.decode(response.body)).userList;
    }
    if (response.statusCode == 409) {
      throw TokenNotValidException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> login(LoginData data) async {
    final response = await http.post(
        Uri.parse('${ApiConstants.baseURL}${ApiConstants.loginEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data.toJson()));

    if (response.statusCode == 200) {
      await tokenStorage
          .storeAuthToken(base64.encode(utf8.encode(response.body)));
      return;
    }
    if (response.statusCode == 400) {
      throw InvalidInputException();
    }
    if (response.statusCode == 404) {
      throw UserNotFoundException();
    }
    if (response.statusCode == 403) {
      throw WrongPasswordException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    String? token = await tokenStorage.getAuthToken();

    final response = await http.delete(
        Uri.parse('${ApiConstants.baseURL}${ApiConstants.logoutEndpoint}'),
        headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      tokenStorage.removeAuthToken();
      return;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> register(UserModel user) async {
    final response = await http.post(
        Uri.parse('${ApiConstants.baseURL}${ApiConstants.registerEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()));

    if (response.statusCode == 200) {
      await tokenStorage
          .storeAuthToken(base64.encode(utf8.encode(response.body)));
      return;
    }
    if (response.statusCode == 400) {
      throw InvalidInputException();
    }
    if (response.statusCode == 409) {
      throw UserExistsException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> removeUser(String username) async {
    String? token = await tokenStorage.getAuthToken();

    final response = await http.delete(
        Uri.parse(
            '${ApiConstants.baseURL}${ApiConstants.deleteEndpoint}$username/'),
        headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      return;
    }
    if (response.statusCode == 409) {
      throw TokenNotValidException();
    }
    if (response.statusCode == 404) {
      throw UserNotFoundException();
    }
    if (response.statusCode == 403) {
      throw NotPermittedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AuthTokenModel> showToken() async {
    String? token = await tokenStorage.getAuthToken();
    if (token != null) {
      String decodedToken = utf8.decode(base64.decode(token));
      AuthTokenModel authToken =
          AuthTokenModel.fromJson(json.decode(decodedToken));
      return authToken;
    }
    throw TokenNotValidException();
  }

  @override
  Future<UserModel> getUser(String username) async {
    String? token = await tokenStorage.getAuthToken();

    final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseURL}${ApiConstants.getUserEndpoint}$username/'),
        headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    }
    if (response.statusCode == 409) {
      throw TokenNotValidException();
    }
    if (response.statusCode == 404) {
      throw UserNotFoundException();
    }
    if (response.statusCode == 403) {
      throw NotPermittedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> changeUserRoles(RolesInputData data) async {
    String? token = await tokenStorage.getAuthToken();
    final response = await http.put(
        Uri.parse(
            '${ApiConstants.baseURL}${ApiConstants.updateEndpoint}${ApiConstants.rolesEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data.toJson()));

    if (response.statusCode == 200) {
      return;
    }
    if (response.statusCode == 409) {
      throw TokenNotValidException();
    }
    if (response.statusCode == 404) {
      throw UserNotFoundException();
    }
    if (response.statusCode == 403) {
      throw NotPermittedException();
    } else {
      throw ServerException();
    }
  }
}
