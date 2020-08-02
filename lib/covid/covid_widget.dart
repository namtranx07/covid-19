import 'package:covid_19/covid/covid_bloc.dart';
import 'package:covid_19/covid/covid_event.dart';
import 'package:covid_19/covid/covid_state.dart';
import 'package:covid_19/custom_piechart_painter/custom_piechart.dart';
import 'package:covid_19/resources/app_colors.dart';
import 'package:covid_19/resources/app_images.dart';
import 'package:flutter/material.dart';
import 'package:covid_19/resources/app_fonts.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

enum CovidType { TOTAL_CONFIRMED, TOTAL_DEATHS, TOTAL_RECOVERED }

class CovidWidget extends StatefulWidget {
  @override
  _CovidWidgetState createState() => _CovidWidgetState();
}

class _CovidWidgetState extends State<CovidWidget> {
  Bloc bloc;
  List<Color> colorList = [
    Color(0xFFDDED1D),
    Color(0xFF298CD0),
    Color(0xFF33ED1D),
  ];
  final numberFormat = NumberFormat("#,##0","en_US");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Covid-19'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<CovidBloc, CovidState>(
        cubit: bloc,
        builder: (context, CovidState state) {
          return Stack(
            children: [
              Positioned.fill(child: AppImages.background),
              Positioned(
                top: 100,
                right: 0,
                left: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: _buildCardInfo(state, CovidType.TOTAL_CONFIRMED),
                      ),
                      Container(
                          width: double.infinity,
                          child: _buildCardInfo(state, CovidType.TOTAL_DEATHS)),
                      Container(
                          width: double.infinity,
                          child:
                              _buildCardInfo(state, CovidType.TOTAL_RECOVERED)),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Cập nhật ngày hôm nay", style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ).redHatDisplayBold(),),
                        ),
                      ),
                      _buildPieChart(state),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc = CovidBloc();
    bloc.add(InitialEvent());
  }

  Widget _buildPieChart(CovidState state) {
    double newConfirmed = (state.summary?.global?.newConfirmed)?.toDouble() ?? 0.0;
    double newDeaths = (state.summary?.global?.newDeaths)?.toDouble() ?? 0.0;
    double newRecovered = (state.summary?.global?.newRecovered)?.toDouble() ?? 0.0;
    Map<String, double> dataMap = Map();
    dataMap = {
      "Số ca nhiễm mới": newConfirmed,
      "Số ca tử vong mới": newDeaths,
      "Số ca hồi phục mới": newRecovered
    };

    return CustomPieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32.0,
      chartRadius: MediaQuery.of(context).size.width / 2.7,
      showChartValuesInPercentage: false,
      showChartValues: true,
      showChartValuesOutside: false,
      chartValueBackgroundColor: Colors.white,
      colorList: colorList,
      showLegends: true,
      legendPosition: LegendPosition.right,
      decimalPlaces: 0,
      showChartValueLabel: true,
      initialAngle: 0,
      chartValueStyle: defaultChartValueStyle.copyWith(
        color: Colors.purple,
      ),
      legendStyle: defaultLegendStyle.copyWith(
        color: Colors.black,
        backgroundColor: Colors.white60,
      ),
      chartType: ChartType.ring,
    );
  }

  Widget _buildCardInfo(CovidState state, CovidType covidType) {
    Widget content;
    switch (covidType) {
      case CovidType.TOTAL_CONFIRMED:
        content = Column(
          children: [
            Text(
              "Tổng số người mắc",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
              ).redHatDisplayBold(),
            ),
            SizedBox(
              height: 20,
            ),
            Text("${numberFormat.format(state.summary?.global?.totalConfirmed ?? 0)} người",
                style: TextStyle(
                  color: Color(0xFF1a237e),
                  fontSize: 20,
                ).redHatDisplayBold()),
          ],
        );
        break;
      case CovidType.TOTAL_DEATHS:
        content = Column(
          children: [
            Text(
              "Tổng số người tử vong",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
              ).redHatDisplayBold(),
            ),
            SizedBox(
              height: 20,
            ),
            Text("${numberFormat.format(state.summary?.global?.totalDeaths ?? 0)} người",
            style: TextStyle(
              color: Color(0xFFe91e63),
              fontSize: 20,
            ).redHatDisplayBold(),),
          ],
        );
        break;
      case CovidType.TOTAL_RECOVERED:
        content = Column(
          children: [
            Text(
              "Tổng số người hồi phục",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
              ).redHatDisplayBold(),
            ),
            SizedBox(
              height: 20,
            ),
            Text("${numberFormat.format(state.summary?.global?.totalRecovered ?? 0)} người",
                style: TextStyle(
                  color: Color(0xFF009688),
                  fontSize: 20,
                ).redHatDisplayBold()),
          ],
        );
        break;
    }
    return Card(
      color: Colors.transparent,
      borderOnForeground: true,
      elevation: 1,
      margin: EdgeInsets.all(16),
      shadowColor: Colors.grey.shade50,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
  }
}
