part of 'todo_list_cubit.dart';

@freezed
class TodoListState with _$TodoListState{
  const factory TodoListState.initial() = _Initial;
  const factory TodoListState.loading() = _Loading;
  const factory TodoListState.success({ 
    required List<Task> tasks, 
    @Default(BarIndex.all) BarIndex  barIndex, 
    @Default(null) int? editedTaskId}) = _Success;
  const factory TodoListState.error(String errorMessage) = _Error;
}