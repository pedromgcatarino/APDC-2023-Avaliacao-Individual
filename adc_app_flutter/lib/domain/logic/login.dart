import 'package:adc_app_flutter/domain/entities/auth_token.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/login_data.dart';
import '../repositories/repository.dart';

class Login {
  final Repository repository;

  Login(this.repository);

  Future<Either<Failure, void>> call(LoginData data) {
    return repository.login(data);
  }
}
