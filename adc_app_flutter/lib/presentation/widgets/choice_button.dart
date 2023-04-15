import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/providers.dart';

class ChoiceButton extends ConsumerWidget {
  const ChoiceButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToggleButtons(
      color: Colors.brown,
      selectedColor: Colors.white,
      fillColor: Colors.brown,
      selectedBorderColor: Colors.brown,
      borderColor: Colors.brown,
      borderRadius: BorderRadius.circular(50),
      isSelected: ref.watch(Providers.profileStateProvider),
      onPressed: (index) {
        if (index == 0) {
          ref.read(Providers.profileStateProvider.notifier).state = [
            true,
            false
          ];
        } else {
          ref.read(Providers.profileStateProvider.notifier).state = [
            false,
            true
          ];
        }
      },
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 62),
          child: Text("Public"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 62),
          child: Text("Private"),
        ),
      ],
    );
  }
}
