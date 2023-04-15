import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/repository.dart';

class GetUser {
  final Repository repository;

  GetUser(this.repository);

  Future<Either<Failure, User>> call(String username) {
    return repository.getUser(username);
  }
}
