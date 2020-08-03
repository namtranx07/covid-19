import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class VNCovidAnalysis {
  final String title;
  final int total;

  VNCovidAnalysis({this.title, this.total});
}

class VNBarChartWidget extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;

  VNBarChartWidget({this.seriesList, this.animate});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: BarChart(
        seriesList,
        animate: animate,
        barRendererDecorator: BarLabelDecorator<String>(
        ),
        domainAxis: OrdinalAxisSpec(),
        vertical: false,
        animationDuration: Duration(milliseconds: 800),
        flipVerticalAxis: true,
      ),
    );
  }
}
