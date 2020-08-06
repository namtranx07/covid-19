import 'dart:convert';

CovidLatest covidLatestFromJson(String str) => CovidLatest.fromJson(json.decode(str));

String covidLatestToJson(CovidLatest data) => json.encode(data.toJson());

class CovidLatest {
  CovidLatest({
    this.cases,
    this.deaths,
    this.recovered,
  });

  int cases;
  int deaths;
  int recovered;

  CovidLatest copyWith({
    int cases,
    int deaths,
    int recovered,
  }) =>
      CovidLatest(
        cases: cases ?? this.cases,
        deaths: deaths ?? this.deaths,
        recovered: recovered ?? this.recovered,
      );

  factory CovidLatest.fromJson(Map<String, dynamic> json) => CovidLatest(
    cases: json["cases"],
    deaths: json["deaths"],
    recovered: json["recovered"],
  );

  Map<String, dynamic> toJson() => {
    "cases": cases,
    "deaths": deaths,
    "recovered": recovered,
  };
}
