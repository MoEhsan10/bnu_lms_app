import 'package:freezed_annotation/freezed_annotation.dart';

part 'grading_state.freezed.dart';

@freezed
class GradingState with _$GradingState {
  const factory GradingState.initial() = _Initial;
  const factory GradingState.loading() = _Loading;
  const factory GradingState.success() = _Success;
  const factory GradingState.error(String message) = _Error;
}
