import 'package:covid_19/component/splash_screen.dart';
import 'package:covid_19/network/base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
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
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

   @override
   Widget build(BuildContext context) {
     return SplashScreenWidget();
   }
 }

