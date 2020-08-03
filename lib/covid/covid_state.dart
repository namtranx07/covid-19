import 'package:covid_19/model/summary.dart';
import 'package:equatable/equatable.dart';

class CovidState extends Equatable {
  final Summary summary;
  final Country vnSummary;
  final bool isLoading;

  CovidState({this.summary, this.vnSummary, this.isLoading = true});

  CovidState copyWith({Summary summary, Country vnSummary, bool isLoading}) =>
      CovidState(
        summary: summary ?? this,
        vnSummary: vnSummary ?? this,
        isLoading: isLoading ?? true,
      );

  @override
  List<Object> get props => [summary, vnSummary, isLoading];

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