import 'package:equatable/equatable.dart';

class CovidState extends Equatable {
  final bool finishSplash;

  CovidState({this.finishSplash = false,});

  CovidState copyWith({bool finishSplash}) =>
      CovidState(
        finishSplash: finishSplash ?? false,
      );

  @override
  List<Object> get props => [];

  @override
  bool operator ==(Object other) {
    if (props == null || props.isEmpty) {
      return false;
    }
    return super == other;
  }

  @override
  bool get stringify => true;

  @override
  int get hashCode => super.hashCode;

}