import 'package:adc_app_flutter/presentation/pages/home_page.dart';
import 'package:adc_app_flutter/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ADC',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: const RegisterPage());
    //const RegisterPage());
  }
}
