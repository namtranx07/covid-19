import 'package:covid_19/model/summary.dart';
import 'package:equatable/equatable.dart';

class CovidState extends Equatable {
  final Summary summary;
  final Country vnSummary;

  CovidState({this.summary, this.vnSummary});

  CovidState copyWith({Summary summary, Country vnSummary}) =>
      CovidState(
        summary: summary ?? this,
        vnSummary: vnSummary ?? this,
      );

  @override
  List<Object> get props => [summary, vnSummary];

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