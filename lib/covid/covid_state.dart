import 'package:covid_19/model/summary.dart';
import 'package:equatable/equatable.dart';

class CovidState extends Equatable {
  final Summary summary;

  CovidState({this.summary,});

  CovidState copyWith({Summary summary}) =>
      CovidState(
        summary: summary ?? this,
      );

  @override
  List<Object> get props => [summary];

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