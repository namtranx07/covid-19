import 'package:covid_19/component/splash_screen.dart';
import 'package:covid_19/covid/covid_bloc.dart';
import 'package:covid_19/network/base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'network/configs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  currentEnvironment = Environment.DEV;
  Configs.configNetwork();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "RedHatDisplay",
      ),
      home: HomeWidget(),
    );
  }
}
 class HomeWidget extends StatefulWidget {
   @override
   _HomeWidgetState createState() => _HomeWidgetState();
 }

 class _HomeWidgetState extends State<HomeWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

   @override
   Widget build(BuildContext context) {
     return SafeArea(
       top: false,
       bottom: false,
       child: SplashScreenWidget(),
     );
   }
 }

