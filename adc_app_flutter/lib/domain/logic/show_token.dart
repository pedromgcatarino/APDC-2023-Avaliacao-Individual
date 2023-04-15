import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/auth_token.dart';
import '../repositories/repository.dart';

class ShowToken {
  final Repository repository;

  ShowToken(this.repository);

  Future<Either<Failure, AuthToken>> call() async {
    return await repository.showToken();
  }
}
