import 'package:covid_19/model/summary.dart';
import 'package:equatable/equatable.dart';

class CovidState extends Equatable {
  final Summary summary;
  final Country vnSummary;
  final bool isLoading;
  final Country otherCountry;
  final bool noData;
  final changeIconSearch;

  CovidState({
    this.summary,
    this.vnSummary,
    this.isLoading = true,
    this.otherCountry,
    this.noData = false,
    this.changeIconSearch = false,
  });

  CovidState copyWith({
    Summary summary,
    Country vnSummary,
    bool isLoading,
    Country otherCountry,
    bool noData,
    bool changeIconSearch,
  }) =>
      CovidState(
        summary: summary ?? this.summary,
        vnSummary: vnSummary ?? this.vnSummary,
        isLoading: isLoading ?? true,
        otherCountry: otherCountry,
        noData: noData ?? false,
        changeIconSearch: changeIconSearch ?? false,
      );

  @override
  List<Object> get props => [
        summary,
        vnSummary,
        isLoading,
        otherCountry,
        noData,
        changeIconSearch,
      ];

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
