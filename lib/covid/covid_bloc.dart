import 'package:covid_19/api/covidApiImpl.dart';
import 'package:covid_19/covid/covid_event.dart';
import 'package:covid_19/covid/covid_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CovidBloc extends Bloc<CovidEvent, CovidState> {
  CovidApiImpl _covidApiImpl;

  CovidBloc() : super(CovidState()) {
    _covidApiImpl = CovidApiImpl();
  }

  @override
  Stream<CovidState> mapEventToState(CovidEvent event) async* {
    switch (event.runtimeType) {
      case InitialEvent:
        final summaryData = await _covidApiImpl.covidSummary();
        final vnData = summaryData.countries.firstWhere(
            (element) => element.countryCode == "VN",
            orElse: () => null);
        yield state.copyWith(
          summary: summaryData,
          vnSummary: vnData,
          isLoading: false,
        );
        break;
      case SearchCountryEvent:
        final _event = event as SearchCountryEvent;
        final data = state.summary.countries.firstWhere(
          (element) => element.country == _event.name,
          orElse: () => null,
        );
        yield state.copyWith(
          otherCountry: data,
          isLoading: false,
        );
        break;
    }
  }
}
