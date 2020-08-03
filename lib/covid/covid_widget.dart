import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_19/bar_chart/vn_barchart.dart';
import 'package:covid_19/covid/covid_bloc.dart';
import 'package:covid_19/covid/covid_event.dart';
import 'package:covid_19/covid/covid_state.dart';
import 'package:covid_19/custom_piechart_painter/custom_piechart.dart';
import 'package:covid_19/resources/app_icons.dart';
import 'package:covid_19/utils/custom_appbar.dart';
import 'package:covid_19/utils/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:covid_19/resources/app_fonts.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum CovidType { TOTAL_CONFIRMED, TOTAL_DEATHS, TOTAL_RECOVERED }

class CovidWidget extends StatefulWidget {
  @override
  _CovidWidgetState createState() => _CovidWidgetState();
}

class _CovidWidgetState extends State<CovidWidget> {
  Bloc bloc;
  List<Color> colorList = [
    Colors.blue,
    Colors.redAccent,
    Colors.green.shade400,
  ];

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final numberFormat = NumberFormat("#,##0", "en_US");

  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    bloc = CovidBloc();
    bloc.add(InitialEvent());
    _refreshController = RefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBarGradient(
        child: AppBar(
          title: Text(
            'Covid-19',
            style: TextStyle(
              color: Colors.white,
            ).redHatDisplayMedium(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: BlocBuilder<CovidBloc, CovidState>(
        cubit: bloc,
        builder: (context, CovidState state) {
          if (!state.isLoading) {
            _refreshController.refreshCompleted();
          }
          return SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            header: LoadingIndicator(),
            onRefresh: () {
              bloc.add(InitialEvent());
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SizedBox(height: 32,),
                  _wrappedCard(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0, ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Thông tin thế giới",
                              style: TextStyle(
                                fontSize: 26,
                                foreground: Paint()..shader = linearGradient,
                              ).redHatDisplayBold(),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: _buildCardInfo(
                              state, CovidType.TOTAL_CONFIRMED),
                        ),
                        Container(
                            width: double.infinity,
                            child: _buildCardInfo(
                                state, CovidType.TOTAL_DEATHS)),
                        Container(
                            width: double.infinity,
                            child: _buildCardInfo(
                                state, CovidType.TOTAL_RECOVERED)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  _wrappedCard(child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, left: 16, right: 16, bottom: 24),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Cập nhật ngày hôm nay",
                              style: TextStyle(
                                fontSize: 26,
                                  foreground: Paint()..shader = linearGradient,
                              ).redHatDisplayBold(),
                            ),
                          ),
                        ),
                        _buildPieChart(state),
                        SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    shadowColor: Colors.grey.shade50,
                    borderOnForeground: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, left: 16, right: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Thông tin Việt Nam",
                              style: TextStyle(
                                fontSize: 26,
                                foreground: Paint()..shader = linearGradient,
                              ).redHatDisplayBold(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 32),
                          child: VNBarChartWidget(
                            animate: true,
                            seriesList: _createSeriesListData(state),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _wrappedCard({Widget child}) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shadowColor: Colors.grey.shade50,
      borderOnForeground: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child,
    );
  }

  Widget _buildPieChart(CovidState state) {
    double newConfirmed =
        (state.summary?.global?.newConfirmed)?.toDouble() ?? 0.0;
    double newDeaths = (state.summary?.global?.newDeaths)?.toDouble() ?? 0.0;
    double newRecovered =
        (state.summary?.global?.newRecovered)?.toDouble() ?? 0.0;
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
        color: Colors.black54,
      ),
      legendStyle: defaultLegendStyle.copyWith(
        color: Colors.black54,
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
              "Tổng số ca nhiễm",
              style: TextStyle(
                color: Colors.black45,
                fontSize: 16,
              ).redHatDisplayBold(),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "${numberFormat.format(state.summary?.global?.totalConfirmed ?? 0)} ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 32,
                    ).redHatDisplayBold()),
                Container(
                  child: AppIcons.ic_user,
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ],
        );
        break;
      case CovidType.TOTAL_DEATHS:
        content = Column(
          children: [
            Text(
              "Tổng số ca tử vong",
              style: TextStyle(
                color: Colors.black45,
                fontSize: 16,
              ).redHatDisplayBold(),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${numberFormat.format(state.summary?.global?.totalDeaths ?? 0)} ",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 32,
                  ).redHatDisplayBold(),
                ),
                Container(
                  child: AppIcons.ic_user,
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ],
        );
        break;
      case CovidType.TOTAL_RECOVERED:
        content = Column(
          children: [
            Text(
              "Tổng số ca hồi phục",
              style: TextStyle(
                color: Colors.black45,
                fontSize: 16,
              ).redHatDisplayBold(),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "${numberFormat.format(state.summary?.global?.totalRecovered ?? 0)} ",
                    style: TextStyle(
                      color: Colors.green.shade400,
                      fontSize: 32,
                    ).redHatDisplayBold()),
                Container(
                  child: AppIcons.ic_user,
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ],
        );
        break;
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: content,
      ),
    );
  }

  _createSeriesListData(CovidState state) {
    final data = [
      new VNCovidAnalysis(
          title: 'Tổng số \nca nhiễm',
          total: state.vnSummary?.totalConfirmed ?? 0),
      new VNCovidAnalysis(
          title: 'Tổng số \nca tử vong',
          total: state.vnSummary?.totalDeaths ?? 0),
      new VNCovidAnalysis(
          title: 'Tổng số \nca hồi phục',
          total: state.vnSummary?.totalRecovered ?? 0),
      new VNCovidAnalysis(
          title: 'Số ca \nnhiễm mới',
          total: state.vnSummary?.newConfirmed ?? 0),
      new VNCovidAnalysis(
          title: 'Số ca \ntử vong mới', total: state.vnSummary?.newDeaths ?? 0),
      new VNCovidAnalysis(
          title: 'Số ca \nhồi phục mới',
          total: state.vnSummary?.newRecovered ?? 0),
    ];

    return [
      charts.Series<VNCovidAnalysis, String>(
        id: 'title',
        domainFn: (VNCovidAnalysis info, _) => info.title,
        measureFn: (VNCovidAnalysis info, _) => info.total,
        data: data,
        labelAccessorFn: (VNCovidAnalysis data, _) =>
            '\ ${data.total.toString()}',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault.darker,
        overlaySeries: false,
      ),
    ];
  }
}

