import 'package:flutter/material.dart';
import 'core/router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CoinPay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0066FF),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter', // добавишь шрифт потом
      ),
      routerConfig: appRouter,
    );
  }
}