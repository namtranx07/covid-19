import 'package:covid_19/covid/covid_event.dart';
import 'package:covid_19/covid/covid_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CovidBloc extends Bloc<CovidEvent, CovidState> {

  CovidBloc() : super(CovidState());

  @override
  Stream<CovidState> mapEventToState(CovidEvent event) async* {
    print('CovidBloc');
  }


}