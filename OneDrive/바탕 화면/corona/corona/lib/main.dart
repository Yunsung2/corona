import 'package:flutter/material.dart';
import 'package:pa3/pages/navigationpage.dart';
import 'package:provider/provider.dart';
import 'package:pa3/pages/login.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2017314656 KIM YUN SEONG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (routerSettings){
        switch(routerSettings.name){
          case '/':
            return MaterialPageRoute(builder: (_) => MyHomePage(title: '2017314632 KIM YUN SEONG'));
          case '/login':
            return MaterialPageRoute(builder: (_) => login(routerSettings.arguments));
          default:
            return null;
        }
      }
     );
  }
}
class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  String _password='1234';
  String _Name="skku";
  String title;
  final textController=TextEditingController();
  final textController2=TextEditingController();
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
                    'Login Please....',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[Text(
                            "ID:"
                        ),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: textController,
                            ),
                          ),
                        ]
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[Text(
                            "PW:"
                        ),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: textController2,
                            ),
                          ),
                        ]
                    ),
                    ElevatedButton(child: Text('Login'),onPressed: (){
                      if(textController.text==_Name && textController2.text==_password){
                        Navigator.pushNamed(context, '/login', arguments: {"previous-page": "Login Page", "ID": _Name});
                      }
                    },),
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 3)),
              )
            ],
          ),
        ),
      ),
    );
  }
}