import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'editing_state.dart';
part 'editing_cubit.freezed.dart';

class EditingCubit extends Cubit<EditingState> {
  EditingCubit() : super(const EditingState.idle());

  void setEditedTaskId(int? id){
    if(id != null){
      emit(EditingState.editing(id));
    } else {
      emit(const EditingState.idle());
    }
  }
}