import 'package:flutter/material.dart';
import 'package:pa3/pages/navigationpage.dart';

class login extends StatelessWidget{
  final Map<String, String> arguements;
  login(this.arguements);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (routerSettings){
        switch(routerSettings.name){
          case '/':
            return MaterialPageRoute(builder: (_) => MyHomePage(arguements));
          case '/navigationpage':
            return MaterialPageRoute(builder: (_) => navigationpage(routerSettings.arguments));
          default:
            return null;
        }
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Map<String,String> arguments;
  MyHomePage(this.arguments);
  String _imagepath="assets/images/world.jpg";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('2017314632 KIM YUN SEONG'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CORONA LIVE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    'Login Success. Hello ${arguments["ID"]}!!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: 450,
                    child:  Image.asset(_imagepath),
                  ),
                  ElevatedButton(child: Text('Start Corona Live'),
                      onPressed: ()=>Navigator.pushNamed(context, '/navigationpage', arguments: {"ID": arguments["ID"], "previous_page": "Login Page"})
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}