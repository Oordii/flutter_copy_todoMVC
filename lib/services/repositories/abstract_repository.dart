import 'package:copy_todo_mvc/models/task.dart';
import 'package:flutter/material.dart';

abstract class Repository {
  Future<void> setTheme(ThemeMode mode);
  Future<ThemeMode> getTheme();
  Future<List<Task>> getAllTasks();
  Future<void> addTask(Task task);
  Future<Task> getTaskById(int id);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(Task task);
}