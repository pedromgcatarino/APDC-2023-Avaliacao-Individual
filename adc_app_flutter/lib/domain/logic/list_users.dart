import 'package:adc_app_flutter/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/repository.dart';

class ListUsers {
  final Repository repository;

  ListUsers(this.repository);

  Future<Either<Failure, List<User>>> call() {
    return repository.listUsers();
  }
}
