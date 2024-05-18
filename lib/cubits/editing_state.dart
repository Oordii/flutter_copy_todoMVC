part of 'editing_cubit.dart';

@freezed
class EditingState with _$EditingState {
  const factory EditingState.editing(int id) = _Editing;
  const factory EditingState.idle() = _Idle;
}
