import 'package:copy_todo_mvc/models/task.dart';
import 'package:copy_todo_mvc/services/repositories/abstract_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveRepository implements Repository {
  final Box _settingsBox = Hive.box('settings');
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  @override
  Future<void> setTheme(ThemeMode mode) async {
    await _settingsBox.put('isDarkMode', mode == ThemeMode.dark);
  }

  @override
  Future<ThemeMode> getTheme() async {
    var isDarkMode = _settingsBox.get('isDarkMode');
    if (isDarkMode == null) {
      isDarkMode = ThemeMode.system == ThemeMode.dark;
      await _settingsBox.put('isDarkMode', isDarkMode);
    }
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  List<Task> getAllTasks() {
    return _taskBox.values.toList();
  }

  @override
  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<void> deleteTask(Task task) async {
    await _taskBox.delete(task.id);
  }
  
  @override
  Task getTaskById(int id) {
    return _taskBox.values.singleWhere((element) => element.id == id);
  }
}