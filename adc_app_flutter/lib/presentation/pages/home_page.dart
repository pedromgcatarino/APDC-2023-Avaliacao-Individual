import 'package:adc_app_flutter/presentation/widgets/operations_widget.dart';
import 'package:adc_app_flutter/presentation/widgets/user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import '../provider/providers.dart';

class HomePage extends ConsumerWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(Providers.repositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          UserDetails(user: user),
          OperationsWidget(repository: repository),
        ],
      ),
    );
  }
}
