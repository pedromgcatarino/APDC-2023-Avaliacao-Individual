import 'package:adc_app_flutter/data/models/roles_input_data.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/repository.dart';

class ChangeRoles {
  final Repository repository;

  ChangeRoles(this.repository);

  Future<Either<Failure, void>> call(RolesInputData data) async {
    return await repository.changeUserRoles(data);
  }
}
