import 'package:adc_app_flutter/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/repository.dart';

class ChangeAttributes {
  final Repository repository;

  ChangeAttributes(this.repository);

  Future<Either<Failure, void>> call(UserModel updatedUser) async {
    return await repository.changeUserAttributes(updatedUser);
  }
}
