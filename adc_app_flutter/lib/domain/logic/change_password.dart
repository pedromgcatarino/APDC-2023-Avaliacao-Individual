import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/password_input_model.dart';
import '../repositories/repository.dart';

class ChangePassword {
  final Repository repository;

  ChangePassword(this.repository);

  Future<Either<Failure, void>> call(PasswordInputModel data) {
    return repository.changePassword(data);
  }
}
