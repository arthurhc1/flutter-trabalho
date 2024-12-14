import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_trabalho/model/task.dart';
import 'package:flutter_trabalho/services/api_service.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isDarkTheme = false;

  final ApiService _apiService;

  TaskProvider(this._apiService);

  List<Task> get tasks => _tasks;
  bool get isDarkTheme => _isDarkTheme;

  Future<void> addTask(String title) async {
    final nextId = _tasks.isNotEmpty ? _tasks.map((task) => task.id).reduce((a, b) => a > b ? a : b) + 1 : 1;

    final newTask = Task(id: nextId, title: title);

    _tasks.add(newTask);
    notifyListeners();

    await saveTasks();

    try {
      final createdTask = await _apiService.createTask(newTask);

      _tasks.removeWhere((task) => task.id == newTask.id);
      _tasks.add(createdTask);

      notifyListeners();
    } catch (e) {
      print("Erro ao adicionar tarefa: $e");
    }
  }


  Future<void> toggleTaskCompletion(Task aTask) async {
    final taskIndex = _tasks.indexWhere((task) => aTask.id == task.id);
    if (taskIndex == -1) {
      print("Tarefa não encontrada: ${aTask.id}");
      return;
    }

    final task = _tasks[taskIndex];
    final previousState = task.isCompleted;
    task.isCompleted = !task.isCompleted;

    await saveTasks();

    try {
      print(task.toJson());
      await _apiService.updateTask(task.id, task);
    } catch (e) {
      print("Erro ao atualizar tarefa na API (ID: ${task.id}): $e");

      task.isCompleted = previousState;
      await saveTasks();
    }

    notifyListeners();
  }

  Future<void> removeTask(Task task) async {
    _tasks.removeWhere((t) => t.id == task.id);
    await saveTasks();

    try {
      await _apiService.deleteTask(task.id);
      notifyListeners();
    } catch (e) {
      print("Erro ao deletar a tarefa: $e");
    }
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList('tasks') ?? [];
    _tasks = savedTasks.map((taskJson) {
      return Task.fromJson(jsonDecode(taskJson));
    }).toList();
    notifyListeners();

    try {
      final apiTasks = await _apiService.fetchTasks();
      _tasks.addAll(apiTasks);
      notifyListeners();
    } catch (e) {
      print("Erro ao carregar tarefas da API: $e");
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = _tasks.map((task) => jsonEncode(task.toJson())).toList();
    prefs.setStringList('tasks', taskList);
  }
}
