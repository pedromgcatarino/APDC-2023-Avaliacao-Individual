import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/repository.dart';

class RemoveUser {
  final Repository repository;

  RemoveUser(this.repository);

  Future<Either<Failure, void>> call(String username) async {
    return await repository.removeUser(username);
  }
}
