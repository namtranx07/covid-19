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
import 'package:translator/translator.dart';

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
  GoogleTranslator _translator =
      GoogleTranslator(client: ClientType.extensionGT);

  RefreshController _refreshController;
  String _textTranslated;
  TextEditingController textEditingController;
  bool changeSuffixIcon = false;
  String nameSearchCountry = "";

  @override
  void initState() {
    super.initState();
    bloc = CovidBloc();
    bloc.add(InitialEvent());
    _refreshController = RefreshController();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  Future<Translation> _translateVNEN(String text) async {
    if (text != null && text.isNotEmpty) {
      return await _translator.translate(text, from: 'auto', to: 'en');
    }
    return null;
  }

  Future<Translation> _translateENVN(String text) async {
    if (text != null && text.isNotEmpty) {
      return await _translator.translate(text, from: 'auto', to: 'vi');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 32.0, horizontal: 16),
                      child: _buildSearchView(),
                    ),
                    if (state.otherCountry != null &&
                        _textTranslated != null &&
                        textEditingController.text != "")
                      _buildSearchResultWidget(state),
                    _wrappedCard(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              top: 32.0,
                            ),
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
                                state: state,
                                covidType: CovidType.TOTAL_CONFIRMED),
                          ),
                          Container(
                              width: double.infinity,
                              child: _buildCardInfo(
                                  state: state,
                                  covidType: CovidType.TOTAL_DEATHS)),
                          Container(
                              width: double.infinity,
                              child: _buildCardInfo(
                                  state: state,
                                  covidType: CovidType.TOTAL_RECOVERED)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    _wrappedCard(
                      child: Column(
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
                          AnimatedOpacity(
                            child: _buildPieChart(state: state),
                            opacity: !state.isLoading ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 800),
                            curve: Curves.easeInCubic,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    _buildVNInfo(state),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Card _buildVNInfo(CovidState state) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shadowColor: Colors.grey.shade50,
      borderOnForeground: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
            child: VNBarChartWidget(
              animate: true,
              seriesList: _createSeriesListData(state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultWidget(CovidState state) {
    return Column(
      children: [
        _wrappedCard(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 32.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Thông tin $nameSearchCountry",
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
                  state: state,
                  covidType: CovidType.TOTAL_CONFIRMED,
                  otherCountry: true,
                ),
              ),
              Container(
                  width: double.infinity,
                  child: _buildCardInfo(
                    state: state,
                    covidType: CovidType.TOTAL_DEATHS,
                    otherCountry: true,
                  )),
              Container(
                  width: double.infinity,
                  child: _buildCardInfo(
                    state: state,
                    covidType: CovidType.TOTAL_RECOVERED,
                    otherCountry: true,
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 32,
        ),
        _wrappedCard(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 32.0, left: 16, right: 16, bottom: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Cập nhật $nameSearchCountry ngày hôm nay",
                    style: TextStyle(
                      fontSize: 26,
                      foreground: Paint()..shader = linearGradient,
                    ).redHatDisplayBold(),
                  ),
                ),
              ),
              AnimatedOpacity(
                child: _buildPieChart(state: state, otherCountry: true),
                opacity: !state.isLoading ? 1.0 : 0.0,
                duration: Duration(milliseconds: 800),
                curve: Curves.easeInCubic,
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 32,
        ),
      ],
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

  Widget _buildPieChart({CovidState state, bool otherCountry = false}) {
    double newConfirmed = !otherCountry
        ? (state.summary?.global?.newConfirmed)?.toDouble() ?? 0.0
        : ((state.otherCountry?.newConfirmed))?.toDouble() ?? 0.0;
    double newDeaths = !otherCountry
        ? (state.summary?.global?.newDeaths)?.toDouble() ?? 0.0
        : ((state.otherCountry?.newDeaths)?.toDouble() ?? 0.0);
    double newRecovered = !otherCountry
        ? (state.summary?.global?.newRecovered)?.toDouble() ?? 0.0
        : ((state.otherCountry?.newRecovered)?.toDouble() ?? 0.0);
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
      showChartValuesOutside: false,
      chartValueBackgroundColor: Colors.transparent,
      colorList: colorList,
      showLegends: true,
      legendPosition: LegendPosition.right,
      decimalPlaces: 0,
      showChartValueLabel: true,
      initialAngle: 0,
      chartValueStyle: defaultChartValueStyle.copyWith(
        color: Colors.black87,
      ),
      legendStyle: defaultLegendStyle.copyWith(
        color: Colors.black54,
      ),
      chartType: ChartType.ring,
    );
  }

  Widget _buildCardInfo({
    CovidState state,
    CovidType covidType,
    bool otherCountry = false,
  }) {
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
                    !otherCountry
                        ? "${numberFormat.format(state.summary?.global?.totalConfirmed ?? 0)} "
                        : "${numberFormat.format(state.otherCountry?.totalConfirmed ?? 0)} ",
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
                  !otherCountry
                      ? "${numberFormat.format(state.summary?.global?.totalDeaths ?? 0)} "
                      : "${numberFormat.format(state.otherCountry?.totalDeaths ?? 0)} ",
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
                    !otherCountry
                        ? "${numberFormat.format(state.summary?.global?.totalRecovered ?? 0)} "
                        : "${numberFormat.format(state.otherCountry?.totalRecovered ?? 0)} ",
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
        insideLabelStyleAccessorFn: (_, __) => charts.TextStyleSpec(
          color: charts.MaterialPalette.red.shadeDefault,
          fontSize: 16,
          fontFamily: "RedHatDisplay",
          fontWeight: "Bold",
        ),
        outsideLabelStyleAccessorFn: (_, __) => charts.TextStyleSpec(
          color: charts.MaterialPalette.red.shadeDefault,
          fontSize: 16,
          fontWeight: "Bold",
        ),
      ),
    ];
  }

  Widget _buildSearchView() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 15, bottom: 2, top: 14, right: 15),
          hintText: "Nhập tên quốc gia...",
          alignLabelWithHint: true,
          labelStyle: TextStyle(
            fontSize: 26,
            color: Colors.red,
          ).redHatDisplayRegular(),
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ).redHatDisplayRegular(),
          suffixIcon: !changeSuffixIcon
              ? Container(
                  child: AppIcons.ic_search,
                  padding: EdgeInsets.all(10),
                  width: 16,
                  height: 16,
                )
              : IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => textEditingController.clear()),
        ),
        autocorrect: true,
        enableSuggestions: true,
        onSubmitted: (text) async {
          final result = await _translateVNEN("nước " + text);
          final resultENVN = await _translateENVN(result.text);
          nameSearchCountry = resultENVN.text;
          setState(() {
            _textTranslated = result.text;
            bloc.add(SearchCountryEvent(name: _textTranslated));
          });
        },
        maxLines: 1,
        textAlign: TextAlign.left,
        onChanged: (text) {
          setState(() {
            if (text != "") {
              changeSuffixIcon = true;
            } else {
              changeSuffixIcon = false;
            }
          });
        },
      ),
    );
  }
}
