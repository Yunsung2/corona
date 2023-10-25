import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/number_symbols.dart';
import 'package:provider/provider.dart';
import 'package:pa3/pages/navigationpage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math';

class casedeathpage extends StatelessWidget{
  final Map<String,String> arguments;

  casedeathpage(this.arguments);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>GraphCounterProvider(0)),
          ChangeNotifierProvider(create: (context)=>TableCounterProvider(0)),
        ],
        child: MaterialApp(
          initialRoute: '/',
          onGenerateRoute: (routerSettings){
            switch(routerSettings.name){
              case '/':
                return MaterialPageRoute(builder: (_) => MyHomePage(arguments));
              case '/navigationpage':
                return MaterialPageRoute(builder: (_) => navigationpage(routerSettings.arguments));
              default:
                return null;
            }
          },
        )
    );
  }
}
class CDatas{
  Map<String, dynamic> CData= Map<String, dynamic>();
  CDatas({@required this.CData});
  factory CDatas.fromJson(dynamic json){
    return CDatas(CData: json);
  }
}
Future<CDatas> fetchPost() async {
  final response =
  await http.get(Uri.https("covid.ourworldindata.org", "data/owid-covid-data.json"));
  if (response.statusCode == 200) {
    return CDatas.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class MyHomePage extends StatelessWidget{
  final Map<String, String> arguments;
  MyHomePage(this.arguments);

  @override
  Widget build(BuildContext context) {
    GraphCounterProvider graph=Provider.of<GraphCounterProvider>(context);
    TableCounterProvider table=Provider.of<TableCounterProvider>(context);
    var Data;
    bool start=true;
    double totalCase=0;
    double totalDeath=0;
    double dailyCase=0;
    var last_date;
    List<dynamic> Graph_totalCase=List<dynamic>();
    List<dynamic> Graph_dailyCase=List<dynamic>();
    double tmin;
    double tmax;
    double dmin;
    double dmax;
    double graph_totalCase=0;
    double graph_dailyCase=0;

    return Scaffold(
      body: FutureBuilder<CDatas>(
        future: fetchPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (start == true) {
              start = false;
              Data=snapshot.data.CData;
              last_date=Data['KOR']['data'].last['date'];
              var year=last_date.split('-')[0];
              var month=last_date.split('-')[1];
              var day=last_date.split('-')[2];
              var last_date2=new DateTime(int.parse(year),int.parse(month),int.parse(day));
              var new_last_date;
              var graph_last_date;
              var graph_last_date2;
              var last_date3=DateFormat('MM-dd').format(DateTime.parse(last_date)).toString();
              List <dynamic> tm=List <dynamic>();
              List <dynamic> dm=List <dynamic>();
              new_last_date=last_date2.subtract(new Duration(days:1));
              for (String key in Data.keys) {
                if (Data[key]['data'].last['date'] == last_date) {
                  if(Data[key]['data'].last['total_cases']!=null){
                    totalCase+=Data[key]['data'].last['total_cases'];
                  }
                  else{
                    if(Data[key]['data'].last['total_cases']!=null){
                      totalCase+=Data[key]['data'].last['total_cases'];
                    }
                  }
                }
                else if(Data[key]['data'].last['date']==new_last_date){
                  if(Data[key]['data'].last['total_cases']!=null){
                    totalCase+=Data[key]['data'].last['total_cases'];
                  }
                }
              }

              for (String key in Data.keys) {
                if (Data[key]['data'].last['date'] == last_date) {
                  if(Data[key]['data'].last['total_deaths']!=null){
                    totalDeath+=Data[key]['data'].last['total_deaths'];
                  }
                  else{
                    if(Data[key]['data'].last['total_deaths']!=null){
                      totalDeath+=Data[key]['data'].last['total_deaths'];
                    }
                  }
                }
                else if(Data[key]['data'].last['date']==new_last_date){
                  if(Data[key]['data'].last['total_deaths']!=null){
                    totalDeath+=Data[key]['data'].last['total_deaths'];
                  }
                }
              }

              for (String key in Data.keys) {
                if (Data[key]['data'].last['date'] == last_date) {
                  if(Data[key]['data'].last['new_cases']!=null){
                    dailyCase+=Data[key]['data'].last['new_cases'];
                  }
                  else{
                    if(Data[key]['data'].last['new_cases']!=null){
                      dailyCase+=Data[key]['data'].last['new_cases'];
                    }
                  }
                }
                else if(Data[key]['data'].last['date']==new_last_date){
                  if(Data[key]['data'].last['new_cases']!=null){
                    dailyCase+=Data[key]['data'].last['new_cases'];
                  }
                }
              }
              for(int i=27; i>=0; i--){
                graph_last_date=last_date2.subtract(new Duration(days: i));
                graph_last_date2=last_date2.subtract(new Duration(days: i));
                graph_last_date=DateFormat('yyyy-MM-dd').format(graph_last_date);
                graph_last_date2=DateFormat('MM-dd').format(graph_last_date2);
                for(String key in Data.keys){
                  for(int k=0; k<Data[key]['data'].length; k++){
                    if(Data[key]['data'][k]['date']==graph_last_date){
                      if(Data[key]['data'][k]['total_cases']!=null){
                        graph_totalCase+=Data[key]['data'][k]['total_cases'];
                        break;
                      }
                    }
                  }
                }
                Graph_totalCase.add({'date':graph_last_date2, 'graph_totalCase':graph_totalCase});
                tm.add(graph_totalCase);
                graph_totalCase=0;
              }
              tmin=tm.cast<double>().reduce(min);
              tmax=tm.cast<double>().reduce(max);

              for(int i=27; i>=0; i--){
                graph_last_date=last_date2.subtract(new Duration(days: i));
                graph_last_date2=last_date2.subtract(new Duration(days: i));
                graph_last_date=DateFormat('yyyy-MM-dd').format(graph_last_date);
                graph_last_date2=DateFormat('MM-dd').format(graph_last_date2);
                for(String key in Data.keys){
                  for(int k=0; k<Data[key]['data'].length; k++){
                    if(Data[key]['data'][k]['date']==graph_last_date){
                      if(Data[key]['data'][k]['new_cases']!=null){
                        graph_dailyCase+=Data[key]['data'][k]['new_cases'];
                        break;
                      }
                    }
                  }
                }
                Graph_dailyCase.add({'date':graph_last_date2, 'graph_dailyCase':graph_dailyCase});
                dm.add(graph_dailyCase);
                graph_dailyCase=0;
              }
              dmin=dm.cast<double>().reduce(min);
              dmax=dm.cast<double>().reduce(max);
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    height:70,
                    child: Text("   Total Case.                                                        Parsed latest date\n   ${totalCase.toString()} people                                                   $last_date                                   \n"
                        "   Total Deaths.                                                                 Daily Case. \n   ${totalDeath.toString()} people                                         ${dailyCase.toString()} people                    ",style: TextStyle(fontSize: 12),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black, width: 3)),
                  ),
                  Container(
                    width: 350,
                    height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 350,
                          height:64,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children :<Widget> [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(onPressed: ()=> graph.Graph1() , child: Text('Graph 1',
                                      style: TextStyle(
                                        fontSize: 14,
                                      )
                                  ),
                                  ),
                                  TextButton(onPressed:  ()=> graph.Graph2(), child: Text('Graph 2',
                                    style: TextStyle(
                                      fontSize: 14,

                                    ),
                                  ),
                                  ),
                                  TextButton(onPressed:  ()=> graph.Graph3(), child: Text('Graph 3',
                                      style: TextStyle(
                                        fontSize: 14,
                                      )
                                  ),
                                  ),
                                  TextButton(onPressed:  ()=> graph.Graph4(), child: Text('Graph 4',
                                      style: TextStyle(
                                        fontSize: 14,
                                      )
                                  ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 3,
                              ),

                            ],
                          ),
                        ),
                        Consumer<GraphCounterProvider>(builder: (context,counter,child)=>
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                      visible: (counter._counter==1||counter._counter==0),
                                      child:
                                      Container(
                                        width: 270,
                                        height: 200,
                                        child: LineChart(
                                            LineChartData(
                                                lineTouchData: LineTouchData(enabled: false),
                                                lineBarsData:[
                                                  LineChartBarData(
                                                    spots: [
                                                      FlSpot(0, (Graph_totalCase[21]['graph_totalCase']/1000000).toDouble()),
                                                      FlSpot(1, (Graph_totalCase[22]['graph_totalCase']/1000000).toDouble()),
                                                      FlSpot(2, (Graph_totalCase[23]['graph_totalCase']/1000000).toDouble()),
                                                      FlSpot(3, (Graph_totalCase[24]['graph_totalCase']/1000000).toDouble()),
                                                      FlSpot(4, (Graph_totalCase[25]['graph_totalCase']/1000000).toDouble()),
                                                      FlSpot(5, (Graph_totalCase[26]['graph_totalCase']/1000000).toDouble()),
                                                      FlSpot(6, (Graph_totalCase[27]['graph_totalCase']/1000000).toDouble()),
                                                    ],
                                                    barWidth: 2,
                                                    colors: [
                                                      Colors.red,
                                                    ],
                                                    dotData: FlDotData(
                                                      show: true,
                                                    ),
                                                  ),
                                                ],
                                                borderData: FlBorderData(
                                                  show:true,
                                                  border: Border.all(color: const Color(0xff37434d),width: 1),

                                                ),
                                                minY: (tmin/1000000).toDouble()-1,
                                                maxY: (tmax/1000000).toDouble()+1,
                                                titlesData: FlTitlesData(
                                                    bottomTitles: SideTitles(
                                                        showTitles: true,
                                                        getTextStyles: (value)=>const TextStyle(fontSize: 9, color: Colors.black, fontWeight: FontWeight.bold),
                                                        getTitles: (value){
                                                          switch (value.toInt()) {
                                                            case 0:
                                                              return '${Graph_totalCase[21]['date']}';
                                                            case 1:
                                                              return '${Graph_totalCase[22]['date']}';
                                                            case 2:
                                                              return '${Graph_totalCase[23]['date']}';
                                                            case 3:
                                                              return '${Graph_totalCase[24]['date']}';
                                                            case 4:
                                                              return '${Graph_totalCase[25]['date']}';
                                                            case 5:
                                                              return '${Graph_totalCase[26]['date']}';
                                                            case 6:
                                                              return '${Graph_totalCase[27]['date']}';
                                                            default:
                                                              return '';
                                                          }
                                                        }
                                                    ),
                                                    leftTitles: SideTitles(
                                                        showTitles: true,
                                                        getTextStyles: (value)=>const TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold),
                                                        getTitles: (value){
                                                          return '${value.toStringAsFixed(1)}M';
                                                        }
                                                    )
                                                )
                                            )
                                        ),
                                      )
                                  ),
                                  Visibility(
                                      visible: counter._counter==2,
                                      child:
                                      Container(
                                        width: 270,
                                        height: 200,
                                        child: LineChart(
                                            LineChartData(
                                                lineTouchData: LineTouchData(enabled: false),
                                                lineBarsData:[
                                                  LineChartBarData(
                                                    spots: [
                                                      FlSpot(0, (Graph_dailyCase[21]['graph_dailyCase']/1000000)),
                                                      FlSpot(1, (Graph_dailyCase[22]['graph_dailyCase']/1000000)),
                                                      FlSpot(2, (Graph_dailyCase[23]['graph_dailyCase']/1000000)),
                                                      FlSpot(3, (Graph_dailyCase[24]['graph_dailyCase']/1000000)),
                                                      FlSpot(4, (Graph_dailyCase[25]['graph_dailyCase']/1000000)),
                                                      FlSpot(5, (Graph_dailyCase[26]['graph_dailyCase']/1000000)),
                                                      FlSpot(6, (Graph_dailyCase[27]['graph_dailyCase']/1000000)),
                                                    ],
                                                    barWidth: 2,
                                                    colors: [
                                                      Colors.red,
                                                    ],
                                                    dotData: FlDotData(
                                                      show: true,
                                                    ),
                                                  ),
                                                ],
                                                borderData: FlBorderData(
                                                  show:true,
                                                  border: Border.all(color: const Color(0xff37434d),width: 1),

                                                ),
                                                minY: (dmin/1000000).toDouble()-1,
                                                maxY: (dmax/1000000).toDouble()+1,
                                                titlesData: FlTitlesData(
                                                    bottomTitles: SideTitles(
                                                        showTitles: true,
                                                        getTextStyles: (value)=>const TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold),
                                                        getTitles: (value){
                                                          switch (value.toInt()) {
                                                            case 0:
                                                              return '${Graph_dailyCase[21]['date']}';
                                                            case 1:
                                                              return '${Graph_dailyCase[22]['date']}';
                                                            case 2:
                                                              return '${Graph_dailyCase[23]['date']}';
                                                            case 3:
                                                              return '${Graph_dailyCase[24]['date']}';
                                                            case 4:
                                                              return '${Graph_dailyCase[25]['date']}';
                                                            case 5:
                                                              return '${Graph_dailyCase[26]['date']}';
                                                            case 6:
                                                              return '${Graph_dailyCase[27]['date']}';
                                                            default:
                                                              return '';
                                                          }
                                                        }
                                                    ),
                                                    leftTitles: SideTitles(
                                                        showTitles: true,
                                                        getTextStyles: (value)=>const TextStyle(fontSize: 7, color: Colors.black, fontWeight: FontWeight.bold),
                                                        getTitles: (value){
                                                          return '${value.toStringAsFixed(1)}M';
                                                        }
                                                    )
                                                )
                                            )
                                        ),
                                      )
                                  ),
                                  Visibility(
                                      visible: counter._counter==3,
                                      child:
                                      Container(
                                        width: 270,
                                        height: 200,
                                        child: LineChart(
                                            LineChartData(
                                                lineTouchData: LineTouchData(enabled: false),
                                                lineBarsData:[
                                                  LineChartBarData(
                                                    spots: [
                                                      FlSpot(0, (Graph_totalCase[0]['graph_totalCase']/1000000)),
                                                      FlSpot(1, (Graph_totalCase[1]['graph_totalCase']/1000000)),
                                                      FlSpot(2, (Graph_totalCase[2]['graph_totalCase']/1000000)),
                                                      FlSpot(3, (Graph_totalCase[3]['graph_totalCase']/1000000)),
                                                      FlSpot(4, (Graph_totalCase[4]['graph_totalCase']/1000000)),
                                                      FlSpot(5, (Graph_totalCase[5]['graph_totalCase']/1000000)),
                                                      FlSpot(6, (Graph_totalCase[6]['graph_totalCase']/1000000)),
                                                      FlSpot(7, (Graph_totalCase[7]['graph_totalCase']/1000000)),
                                                      FlSpot(8, (Graph_totalCase[8]['graph_totalCase']/1000000)),
                                                      FlSpot(9, (Graph_totalCase[9]['graph_totalCase']/1000000)),
                                                      FlSpot(10, (Graph_totalCase[10]['graph_totalCase']/1000000)),
                                                      FlSpot(11, (Graph_totalCase[11]['graph_totalCase']/1000000)),
                                                      FlSpot(12, (Graph_totalCase[12]['graph_totalCase']/1000000)),
                                                      FlSpot(13, (Graph_totalCase[13]['graph_totalCase']/1000000)),
                                                      FlSpot(14, (Graph_totalCase[14]['graph_totalCase']/1000000)),
                                                      FlSpot(15, (Graph_totalCase[15]['graph_totalCase']/1000000)),
                                                      FlSpot(16, (Graph_totalCase[16]['graph_totalCase']/1000000)),
                                                      FlSpot(17, (Graph_totalCase[17]['graph_totalCase']/1000000)),
                                                      FlSpot(18, (Graph_totalCase[18]['graph_totalCase']/1000000)),
                                                      FlSpot(19, (Graph_totalCase[19]['graph_totalCase']/1000000)),
                                                      FlSpot(20, (Graph_totalCase[20]['graph_totalCase']/1000000)),
                                                      FlSpot(21, (Graph_totalCase[21]['graph_totalCase']/1000000)),
                                                      FlSpot(22, (Graph_totalCase[22]['graph_totalCase']/1000000)),
                                                      FlSpot(23, (Graph_totalCase[23]['graph_totalCase']/1000000)),
                                                      FlSpot(24, (Graph_totalCase[24]['graph_totalCase']/1000000)),
                                                      FlSpot(25, (Graph_totalCase[25]['graph_totalCase']/1000000)),
                                                      FlSpot(26, (Graph_totalCase[26]['graph_totalCase']/1000000)),
                                                      FlSpot(27, (Graph_totalCase[27]['graph_totalCase']/1000000)),
                                                    ],
                                                    barWidth: 2,
                                                    colors: [
                                                      Colors.red,
                                                    ],
                                                    dotData: FlDotData(
                                                      show: true,
                                                    ),
                                                  ),
                                                ],
                                                borderData: FlBorderData(
                                                  show:true,
                                                  border: Border.all(color: const Color(0xff37434d),width: 1),

                                                ),
                                                minY: (tmin/1000000).toDouble()-1,
                                                maxY: (tmax/1000000).toDouble()+1,
                                                titlesData: FlTitlesData(
                                                    bottomTitles: SideTitles(
                                                        showTitles: true,
                                                        getTextStyles: (value)=>const TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold),
                                                        getTitles: (value){
                                                          switch (value.toInt()) {
                                                            case 0:
                                                              return '${Graph_totalCase[0]['date']}';
                                                            case 6:
                                                              return '${Graph_totalCase[6]['date']}';
                                                            case 13:
                                                              return '${Graph_totalCase[13]['date']}';
                                                            case 20:
                                                              return '${Graph_totalCase[20]['date']}';
                                                            case 27:
                                                              return '${Graph_totalCase[27]['date']}';
                                                            default:
                                                              return '';
                                                          }
                                                        }
                                                    ),
                                                    leftTitles: SideTitles(
                                                        showTitles: true,
                                                        getTextStyles: (value)=>const TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold),
                                                        getTitles: (value){
                                                          return '${value.toStringAsFixed(1)}M';
                                                        }
                                                    )
                                                )
                                            )
                                        ),
                                      )
                                  ),

                                  Visibility(
                                      visible: counter._counter==4,
                                      child:
                                      Container(
                                        width: 250,
                                        height: 200,
                                        child: LineChart(
                                            LineChartData(
                                                lineTouchData: LineTouchData(enabled: false),
                                                lineBarsData:[
                                                  LineChartBarData(
                                                    spots: [
                                                      FlSpot(0, (Graph_dailyCase[0]['graph_dailyCase']/1000000)),
                                                      FlSpot(1, (Graph_dailyCase[1]['graph_dailyCase']/1000000)),
                                                      FlSpot(2, (Graph_dailyCase[2]['graph_dailyCase']/1000000)),
                                                      FlSpot(3, (Graph_dailyCase[3]['graph_dailyCase']/1000000)),
                                                      FlSpot(4, (Graph_dailyCase[4]['graph_dailyCase']/1000000)),
                                                      FlSpot(5, (Graph_dailyCase[5]['graph_dailyCase']/1000000)),
                                                      FlSpot(6, (Graph_dailyCase[6]['graph_dailyCase']/1000000)),
                                                      FlSpot(7, (Graph_dailyCase[7]['graph_dailyCase']/1000000)),
                                                      FlSpot(8, (Graph_dailyCase[8]['graph_dailyCase']/1000000)),
                                                      FlSpot(9, (Graph_dailyCase[9]['graph_dailyCase']/1000000)),
                                                      FlSpot(10, (Graph_dailyCase[10]['graph_dailyCase']/1000000)),
                                                      FlSpot(11, (Graph_dailyCase[11]['graph_dailyCase']/1000000)),
                                                      FlSpot(12, (Graph_dailyCase[12]['graph_dailyCase']/1000000)),
                                                      FlSpot(13, (Graph_dailyCase[13]['graph_dailyCase']/1000000)),
                                                      FlSpot(14, (Graph_dailyCase[14]['graph_dailyCase']/1000000)),
                                                      FlSpot(15, (Graph_dailyCase[15]['graph_dailyCase']/1000000)),
                                                      FlSpot(16, (Graph_dailyCase[16]['graph_dailyCase']/1000000)),
                                                      FlSpot(17, (Graph_dailyCase[17]['graph_dailyCase']/1000000)),
                                                      FlSpot(18, (Graph_dailyCase[18]['graph_dailyCase']/1000000)),
                                                      FlSpot(19, (Graph_dailyCase[19]['graph_dailyCase']/1000000)),
                                                      FlSpot(20, (Graph_dailyCase[20]['graph_dailyCase']/1000000)),
                                                      FlSpot(21, (Graph_dailyCase[21]['graph_dailyCase']/1000000)),
                                                      FlSpot(22, (Graph_dailyCase[22]['graph_dailyCase']/1000000)),
                                                      FlSpot(23, (Graph_dailyCase[23]['graph_dailyCase']/1000000)),
                                                      FlSpot(24, (Graph_dailyCase[24]['graph_dailyCase']/1000000)),
                                                      FlSpot(25, (Graph_dailyCase[25]['graph_dailyCase']/1000000)),
                                                      FlSpot(26, (Graph_dailyCase[26]['graph_dailyCase']/1000000)),
                                                      FlSpot(27, (Graph_dailyCase[27]['graph_dailyCase']/1000000)),
                                                    ],
                                                    barWidth: 2,
                                                    colors: [
                                                      Colors.red,
                                                    ],
                                                    dotData: FlDotData(
                                                      show: true,
                                                    ),
                                                  ),
                                                ],
                                                borderData: FlBorderData(
                                                  show:true,
                                                  border: Border.all(color: const Color(0xff37434d),width: 1),

                                                ),
                                                minY: (dmin/1000000).toDouble()-1,
                                                maxY: (dmax/1000000).toDouble()+1,
                                                titlesData: FlTitlesData(
                                                    bottomTitles: SideTitles(
                                                        showTitles: true,
                                                        getTextStyles: (value)=>const TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold),
                                                        getTitles: (value){
                                                          switch (value.toInt()) {
                                                            case 0:
                                                              return '${Graph_dailyCase[0]['date']}';
                                                            case 6:
                                                              return '${Graph_dailyCase[6]['date']}';
                                                            case 13:
                                                              return '${Graph_dailyCase[13]['date']}';
                                                            case 20:
                                                              return '${Graph_dailyCase[20]['date']}';
                                                            case 27:
                                                              return '${Graph_dailyCase[27]['date']}';
                                                            default:
                                                              return '';
                                                          }
                                                        }
                                                    ),
                                                    leftTitles: SideTitles(
                                                        showTitles: true,
                                                        getTextStyles: (value)=>const TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold),
                                                        getTitles: (value){
                                                          return '${value.toStringAsFixed(1)}M';
                                                        }
                                                    )
                                                )
                                            )
                                        ),
                                      )
                                  )
                                ]
                            ),
                        )
                      ]
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black, width: 3)),
                  ),
                  Container(
                    width: 350,
                    height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 350,
                          height:64,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children :<Widget> [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(onPressed: ()=> table.Table1() , child: Text('Total Cases',
                                      style: TextStyle(
                                        fontSize: 14,
                                      )
                                  ),
                                  ),
                                  TextButton(onPressed:  ()=> table.Table2(), child: Text('Total Deaths',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 3,
                              )
                            ],
                          ),
                        ),
                        Consumer<TableCounterProvider>(
                            builder: (context, counter, chile){
                              if(counter._counter==1){
                                List<List<dynamic>> lists= List<List<dynamic>>();
                                for(String key in Data.keys){
                                  List<dynamic> record=List<dynamic>();
                                  record.add(Data[key]['location']);
                                  if(Data[key]['data'].last['total_cases']!=null)
                                    record.add(Data[key]['data'].last['total_cases'].toInt());
                                  else
                                    record.add(Data[key]['data'].last['total_cases']);
                                  if(Data[key]['data'].last['new_cases']!=null)
                                    record.add(Data[key]['data'].last['new_cases'].toInt());
                                  else
                                    record.add(Data[key]['data'].last['new_cases']);
                                  if(Data[key]['data'].last['total_deaths']!=null)
                                    record.add(Data[key]['data'].last['total_deaths'].toInt());
                                  else
                                    record.add(Data[key]['data'].last['total_deaths']);
                                  lists.add(record);
                                }
                                lists.sort((a, b) {return compare(a[1], b[1]);});
                                lists = lists.sublist(0, 7);
                                return Container(
                                    width: 350,
                                    height: 200,
                                    child :ListView(
                                      padding: EdgeInsets.zero,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Text("Country"),
                                              Text("total cases"),
                                              Text("fully cases"),
                                              Text("daily cases")
                                            ],
                                          ),
                                        ),
                                        for(var list in lists)
                                          Container(
                                            padding: EdgeInsets.only(bottom: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(list[0]),
                                                Text(list[1].toString()),
                                                Text(list[2].toString()),
                                                Text(list[3].toString())
                                              ],
                                            ),
                                          )
                                      ],
                                    )
                                );
                              }
                              if(counter._counter==2){
                                List<List<dynamic>> lists= List<List<dynamic>>();
                                for(String key in Data.keys){
                                  List<dynamic> record=List<dynamic>();
                                  record.add(Data[key]['location']);
                                  if(Data[key]['data'].last['total_cases']!=null)
                                    record.add(Data[key]['data'].last['total_cases'].toInt());
                                  else
                                    record.add(Data[key]['data'].last['total_cases']);
                                  if(Data[key]['data'].last['new_cases']!=null)
                                    record.add(Data[key]['data'].last['new_cases'].toInt());
                                  else
                                    record.add(Data[key]['data'].last['new_cases']);
                                  if(Data[key]['data'].last['total_deaths']!=null)
                                    record.add(Data[key]['data'].last['total_deaths'].toInt());
                                  else
                                    record.add(Data[key]['data'].last['total_deaths']);
                                  lists.add(record);
                                }
                                lists.sort((a, b) {return compare(a[3], b[3]);});
                                lists = lists.sublist(0, 7);
                                return Container(
                                    width: 350,
                                    height: 200,
                                    child :ListView(
                                      padding: EdgeInsets.zero,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Text("Country"),
                                              Text("total cases"),
                                              Text("fully cases"),
                                              Text("daily cases")
                                            ],
                                          ),
                                        ),
                                        for(var list in lists)
                                          Container(
                                            padding: EdgeInsets.only(bottom: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(list[0]),
                                                Text(list[1].toString()),
                                                Text(list[2].toString()),
                                                Text(list[3].toString())
                                              ],
                                            ),
                                          )
                                      ],
                                    )
                                );
                              }
                              else return Text('');
                            }
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black, width: 3)),
                  ),
                ]
              )
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){ Navigator.pushNamed(context, '/navigationpage',arguments: {"ID":arguments["ID"], "previous_page": "Cases/Death Page"}
        );},
        child: Icon(Icons.list),
      ),
    );
  }
}
class GraphCounterProvider with ChangeNotifier{
  int _counter;
  get counter=>_counter;

  GraphCounterProvider(this._counter);
  void Graph1(){
    _counter=1;
    notifyListeners();
  }
  void Graph2(){
    _counter=2;
    notifyListeners();
  }
  void Graph3(){
    _counter=3;
    notifyListeners();
  }
  void Graph4(){
    _counter=4;
    notifyListeners();
  }
}

class TableCounterProvider with ChangeNotifier{
  int _counter=1;
  get counter=>_counter;

  TableCounterProvider(this._counter);
  void Table1(){
    _counter=1;
    notifyListeners();
  }
  void Table2(){
    _counter=2;
    notifyListeners();
  }
  void Table3(){
    _counter=3;
    notifyListeners();
  }
  void Table4(){
    _counter=4;
    notifyListeners();
  }
}
int compare(int a, int b){
  if (a == null && b != null)
    return 1;
  else if(a != null && b == null)
    return -1;
  else if(a == null && b == null)
    return 0;
  else if(a < b)
    return 1;
  else if(a> b)
    return -1;
  else
    return 0;
}