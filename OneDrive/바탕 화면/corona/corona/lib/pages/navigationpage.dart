import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa3/pages/vaccinepage.dart';
import 'package:pa3/pages/casedeathpage.dart';

class navigationpage extends StatelessWidget{
  final Map<String, String> arguments;
  navigationpage(this.arguments);
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
            return MaterialPageRoute(builder: (_) => MyHomePage(arguments));
          case '/vaccinepage':
            return MaterialPageRoute(builder: (_) => vaccinepage(routerSettings.arguments));
          case '/casedeathpage':
            return MaterialPageRoute(builder: (_) => casedeathpage(routerSettings.arguments));
          default:
            return null;
        }
      },
    );
  }
}

class MyHomePage extends StatelessWidget{
  final Map<String, String> arguments;

  MyHomePage(this.arguments);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Menu'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(color: Colors.white,child: Row(
                      children: <Widget>[
                          Icon(Icons.coronavirus_outlined),
                          Text('Cases/Death'),
                        ]
                      ),onPressed: ()=>Navigator.pushNamed(context, '/casedeathpage', arguments: {"ID": arguments["ID"]})
                    ),
                    RaisedButton(color: Colors.white,child: Row(
                      children: <Widget>[
                          Icon(Icons.local_hospital),
                          Text('Vaccine'),
                        ]
                      ), onPressed: ()=>Navigator.pushNamed(context, '/vaccinepage', arguments: {"ID": arguments["ID"]})
                    ),
                    Text(
                      'Welcome! ${arguments["ID"]}',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Previous: ${arguments["previous_page"]}',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    )
                  ]
                )
              ]
            )
          )
        )
    );
  }
}
