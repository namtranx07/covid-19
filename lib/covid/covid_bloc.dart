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
    switch(event.runtimeType) {
      case InitialEvent:
        final summaryData = await _covidApiImpl.covidSummary();
        final vnData = summaryData.countries.firstWhere(
              (element) => element.countryCode == "VN",
        orElse: () => null);
        yield state.copyWith(summary: summaryData, vnSummary: vnData);
        break;
    }
  }


}