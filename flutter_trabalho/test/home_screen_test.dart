import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_trabalho/screens/home_screen.dart';
import 'package:flutter_trabalho/providers/task_provider.dart';
import 'package:flutter_trabalho/services/api_service.dart';
import 'package:flutter_trabalho/model/task.dart';

@GenerateMocks([ApiService])
import 'home_screen_test.mocks.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    late MockApiService mockApiService;
    late TaskProvider taskProvider;

    setUp(() {
      mockApiService = MockApiService();

      when(mockApiService.createTask(any)).thenAnswer((_) async => Task(id: 1, title: 'Mock Task'));
      when(mockApiService.fetchTasks()).thenAnswer((_) async => []);
      when(mockApiService.deleteTask(any)).thenAnswer((_) async {});

      taskProvider = TaskProvider(mockApiService);
    });

    testWidgets('Exibe título do AppBar corretamente', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: taskProvider,
            child: const HomeScreen(),
          ),
        ),
      );

      expect(find.text('Gerenciador de Tarefas'), findsOneWidget);
    });

    testWidgets('Adiciona tarefa ao clicar no botão de adicionar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: taskProvider,
            child: const HomeScreen(),
          ),
        ),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Nova Tarefa');

      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton);

      await tester.pump();

      verify(mockApiService.createTask(any)).called(1);
      expect(taskProvider.tasks.length, 1);
      expect(find.text('Mock Task'), findsOneWidget);
    });

    testWidgets('Alterna entre os temas claro e escuro', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: taskProvider,
            child: const HomeScreen(),
          ),
        ),
      );

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);

      final themeButton = find.byType(IconButton).last;
      await tester.tap(themeButton);

      await tester.pump();

      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('Mostra lista de tarefas corretamente', (WidgetTester tester) async {
      when(mockApiService.fetchTasks()).thenAnswer((_) async => [
        Task(id: 1, title: 'Tarefa 1'),
        Task(id: 2, title: 'Tarefa 2'),
      ]);

      await taskProvider.loadTasks();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: taskProvider,
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Tarefa 1'), findsOneWidget);
      expect(find.text('Tarefa 2'), findsOneWidget);
    });
  });
}
