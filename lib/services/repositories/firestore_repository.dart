import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_todo_mvc/main.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'package:copy_todo_mvc/services/repositories/abstract_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreRepository implements Repository {
  final db = getIt.get<FirebaseFirestore>();

  @override
  Future<void> addTask(Task task) async {
    final userUId = FirebaseAuth.instance.currentUser?.uid;
    if (userUId == null) {
      throw Exception('Unauthorized');
    }

    await db
        .collection('users')
        .doc(userUId)
        .collection('tasks')
        .doc(task.id.toString())
        .withConverter<Task>(
            fromFirestore: Task.fromFirestore, toFirestore: Task.toFirestore)
        .set(task);
  }

  @override
  Future<void> deleteTask(Task task) async {
    final userUId = FirebaseAuth.instance.currentUser?.uid;
    if (userUId == null) {
      throw Exception('Unauthorized');
    }

    await db.collection('users').doc(userUId).collection('tasks').doc(task.id.toString()).delete();
  }

  @override
  Future<List<Task>> getAllTasks() async {
    final userUId = FirebaseAuth.instance.currentUser?.uid;
    if (userUId == null) {
      throw Exception('Unauthorized');
    }

    final querySnap = await db
        .collection('users')
        .doc(userUId)
        .collection('tasks')
        .withConverter<Task>(
            fromFirestore: Task.fromFirestore, toFirestore: Task.toFirestore)
        .get();

    var tasks = List<Task>.empty(growable: true);

    for (final doc in querySnap.docs) {
      tasks.add(doc.data());
    }

    return tasks;
  }

  @override
  Future<Task> getTaskById(int id) async {
    final userUId = FirebaseAuth.instance.currentUser?.uid;
    if (userUId == null) {
      throw Exception('Unauthorized');
    }

    final docSnap = await db
        .collection('users')
        .doc(userUId)
        .collection('tasks')
        .doc(id.toString())
        .withConverter<Task>(
            fromFirestore: Task.fromFirestore, toFirestore: Task.toFirestore)
        .get();

    final task = docSnap.data();

    if (task == null) {
      throw Exception('Task with id: $id was not found');
    }

    return task;
  }

  @override
  Future<ThemeMode> getTheme() async {
    final userUId = FirebaseAuth.instance.currentUser?.uid;
    if (userUId == null) {
      throw Exception('Unauthorized');
    }
    
    final docSnap = await db.collection('users').doc(userUId).collection('settings').doc('theme').get();

    final docData = docSnap.data();

    if (docData == null){
      await db.collection('users').doc(userUId).collection('settings').doc('theme').set({'themeMode': 'system'});
      return ThemeMode.system;
    }

    switch (docData['themeMode']){
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<void> setTheme(ThemeMode mode) async {
    final userUId = FirebaseAuth.instance.currentUser?.uid;
    if (userUId == null) {
      throw Exception('Unauthorized');
    }

    String themeMode = '';

    switch (mode){
      case ThemeMode.system:
        themeMode = 'system';
        break;
      case ThemeMode.light:
        themeMode = 'light';
        break;
      case ThemeMode.dark:
        themeMode = 'dark';
        break;
      default: 
        themeMode = 'system';
        break;
    }

    await db.collection('users').doc(userUId).collection('settings').doc('theme').set({'themeMode': themeMode});
  }

  @override
  Future<void> updateTask(Task task) async {
    final userUId = FirebaseAuth.instance.currentUser?.uid;
    if (userUId == null) {
      throw Exception('Unauthorized');
    }

    await db
        .collection('users')
        .doc(userUId)
        .collection('tasks')
        .doc(task.id.toString())
        .withConverter<Task>(
            fromFirestore: Task.fromFirestore, toFirestore: Task.toFirestore)
        .set(task);
  }
}
