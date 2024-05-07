import 'package:auto_route/annotations.dart';
import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:copy_todo_mvc/screens/layout.dart';
import 'package:copy_todo_mvc/widgets/todo_bar.dart';
import 'package:copy_todo_mvc/widgets/todo_items.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Layout(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          FocusManager.instance.primaryFocus?.unfocus();
          Future.delayed(Duration.zero, (){
            context.read<TodoListCubit>().addTask('');
          });
        },
        child: const Icon(Icons.add),),
      child: (SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 8, bottom: 64),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TodoBar(),
              Card(
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.all(8),
                elevation: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<TodoListCubit, TodoListState>(
                              builder: (context, state) {
                                return (IconButton(
                                  disabledColor:
                                      Theme.of(context).disabledColor,
                                  iconSize: 24,
                                  visualDensity: VisualDensity.compact,
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll<
                                              OutlinedBorder>(
                                          CircleBorder(
                                              side: BorderSide(
                                                  width: 2,
                                                  color: state
                                                          .taskEntries.isEmpty
                                                      ? Theme.of(context)
                                                          .disabledColor
                                                      : Theme.of(context)
                                                          .primaryColor)))),
                                  icon: Icon(Icons.done_all,
                                      color: state.taskEntries.isEmpty
                                          ? Theme.of(context).disabledColor
                                          : Theme.of(context).primaryColor),
                                  selectedIcon: Icon(Icons.remove_done,
                                      color: state.taskEntries.isEmpty
                                          ? Theme.of(context).disabledColor
                                          : Theme.of(context).primaryColor),
                                  isSelected: !state.taskEntries.values
                                      .any((element) => !element.isCompleted),
                                  onPressed: () => state.taskEntries.isEmpty
                                      ? null
                                      : context
                                          .read<TodoListCubit>()
                                          .toggleAllTasks(),
                                ));
                              },
                            ),
                            Text("title".tr(context: context)),
                            BlocBuilder<TodoListCubit, TodoListState>(
                                builder: (context, state) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  "left".tr(args: [
                                    state.taskEntries.values
                                        .where(
                                            (element) => !element.isCompleted)
                                        .length
                                        .toString()
                                  ]),
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                      const TodoItems(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
