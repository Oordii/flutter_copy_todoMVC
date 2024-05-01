part of 'todo_list_cubit.dart';

class TodoListState {
  TodoListState({required this.taskEntries, this.barIndex = BarIndex.all});
  final Map<dynamic, Task> taskEntries;
  BarIndex barIndex;
}