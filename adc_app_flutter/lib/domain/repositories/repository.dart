import 'package:adc_app_flutter/core/errors/failures.dart';
import 'package:adc_app_flutter/data/models/roles_input_data.dart';
import 'package:adc_app_flutter/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/login_data.dart';
import '../../data/models/password_input_model.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';

abstract class Repository {
  Future<Either<Failure, void>> register(UserModel user);
  Future<Either<Failure, void>> login(LoginData data);
  Future<Either<Failure, void>> removeUser(String username);
  Future<Either<Failure, List<User>>> listUsers();
  Future<Either<Failure, void>> changeUserAttributes(UserModel updatedUser);
  Future<Either<Failure, void>> changeUserRoles(RolesInputData data);
  Future<Either<Failure, void>> changePassword(PasswordInputModel data);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthToken>> showToken();
  Future<Either<Failure, User>> getUser(String username);
}
