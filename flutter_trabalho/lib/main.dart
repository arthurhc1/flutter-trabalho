import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trabalho/services/api_service.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/task_provider.dart';

void main() {
  final dio = Dio(
    BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  final apiService = ApiService(dio);
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(apiService), // Passa o apiService para o TaskProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(  // Usa o Consumer diretamente para acessar o provider
      builder: (context, provider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: provider.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
          home: const HomeScreen(),
        );
      },
    );
  }
}
