import 'package:covid_19/covid/covid_bloc.dart';
import 'package:covid_19/covid/covid_event.dart';
import 'package:flutter/material.dart';
import 'package:covid_19/resources/app_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CovidWidget extends StatefulWidget {
  @override
  _CovidWidgetState createState() => _CovidWidgetState();
}

class _CovidWidgetState extends State<CovidWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => CovidBloc(),
        child: Builder(
          builder: (context)
          {
            context.bloc<CovidBloc>().add(TestEvent());
            return Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  "This is content",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ).redHatDisplayBold(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
