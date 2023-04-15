import 'package:adc_app_flutter/data/models/auth_token_storage.dart';
import 'package:adc_app_flutter/data/repositories/repository_impl.dart';
import 'package:adc_app_flutter/domain/entities/auth_token.dart';
import 'package:adc_app_flutter/domain/repositories/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Providers {
  static final repositoryProvider =
      Provider<Repository>((ref) => RepositoryImpl());

  static final profileStateProvider =
      StateProvider<List<bool>>((ref) => [true, false]);

  static final accountStateProvider =
      StateProvider<List<bool>>((ref) => [true, false]);

  static final selectedRoleProvider = StateProvider<String>((ref) => 'USER');

  static final selectedStateProvider =
      StateProvider<String>((ref) => 'INACTIVE');
}
