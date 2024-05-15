import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_todo_mvc/main.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'package:copy_todo_mvc/services/repositories/abstract_repository.dart';
import 'package:flutter/material.dart';

class FirestoreRepository implements Repository{
  final db = getIt.get<FirebaseFirestore>();

  @override
  Future<void> addTask(Task task) {
    // TODO: implement addTask
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTask(Task task) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  List<Task> getAllTasks() {
    // TODO: implement getAllTasks
    throw UnimplementedError();
  }

  @override
  Task getTaskById(int id) {
    // TODO: implement getTaskById
    throw UnimplementedError();
  }

  @override
  Future<ThemeMode> getTheme() {
    // TODO: implement getTheme
    throw UnimplementedError();
  }

  @override
  Future<void> setTheme(ThemeMode mode) {
    // TODO: implement setTheme
    throw UnimplementedError();
  }

  @override
  Future<void> updateTask(Task task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
  
}