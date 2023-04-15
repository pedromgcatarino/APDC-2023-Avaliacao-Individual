import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/repository.dart';

class Logout {
  final Repository repository;

  Logout(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
