
import 'package:equatable/equatable.dart';

abstract class CovidEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class InitialEvent extends CovidEvent {}

class SearchCountryEvent extends CovidEvent {
  final String name;

  SearchCountryEvent({this.name});
}

class ChangeIconSearch extends CovidEvent {
  final bool change;

  ChangeIconSearch({this.change = false});
}