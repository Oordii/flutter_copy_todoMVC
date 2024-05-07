part of 'todo_list_cubit.dart';

class TodoListState {
  TodoListState({required this.taskEntries, this.barIndex = BarIndex.all, this.editedEntryKey});
  final Map<dynamic, Task> taskEntries;
  BarIndex barIndex;
  dynamic editedEntryKey;
}