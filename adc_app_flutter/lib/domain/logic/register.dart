import 'package:adc_app_flutter/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/repository.dart';

class Register {
  final Repository repository;

  Register(this.repository);

  Future<Either<Failure, void>> call(UserModel user) async {
    return await repository.register(user);
  }
}
