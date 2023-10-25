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

class vaccinepage extends StatelessWidget{
  final Map<String,String> arguments;
  vaccinepage(this.arguments);
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
class VDatas{
  List<dynamic> VData=List<dynamic>();
  VDatas({@required this.VData});
  factory VDatas.fromJson(dynamic json){
    return VDatas(VData: json);
  }
}
Future<VDatas> fetchPost() async {
  final response =
  await http.get(Uri.https("raw.githubusercontent.com", "owid/covid-19-data/master/public/data/vaccinations/vaccinations.json"));
  if (response.statusCode == 200) {
    return VDatas.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class MyHomePage extends StatelessWidget{
  final Map<String,String> arguments;
  MyHomePage(this.arguments);
  @override
  Widget build(BuildContext context) {
    GraphCounterProvider graph=Provider.of<GraphCounterProvider>(context);
    TableCounterProvider table=Provider.of<TableCounterProvider>(context);
    List<dynamic> Data=List<dynamic>();
    List<dynamic> Graph_totalVacc=List<dynamic>();
    List<dynamic> Graph_dailyVacc=List<dynamic>();
    List<Map> table1=List<Map>();
    List<Map> table2=List<Map>();
    bool start=true;
    bool check=true;
    int index=0;
    int totalVacc=0;
    int totalfullyVacc=0;
    int dailyVacc=0;
    int tmin;
    int tmax;
    int dmin;
    int dmax;
    var last_date;
    var last_date2;
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: FutureBuilder<VDatas>(
        future: fetchPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (start == true) {
              start = false;
              Data = snapshot.data.VData;
              for (int i = 0; i < Data.length; i++) {
                if (Data[i]['country']=="South Korea") {
                  index = i;
                  break;
                }
              }
              last_date = Data[index]['data'].last['date'];
              last_date2=last_date;
              for (int i = 0; i < Data.length; i++) {
                if (Data[i]['data'].last['date']==last_date) {
                  if (Data[i]['data'].last['total_vaccinations'] != null)
                    totalVacc += Data[i]['data'].last['total_vaccinations'];
                  else {
                    if (Data[i]['data'].last['people_vaccinated'] != null)
                      totalVacc +=Data[i]['data'].last['people_vaccinated'];
                    else{
                      if(Data[i]['data'].last['people_fully_vaccinated']!=null)
                        totalVacc+=Data[i]['data'].last['people_fully_vaccinated'];
                    }
                  }
                }
                else {
                  if(Data[i]['data'].length==1){
                    if(Data[i]['data'].last['total_vaccinations']!=null)
                      totalVacc += Data[i]['data'].last['total_vaccinations'];
                    else {
                      if(Data[i]['data'].last['people_vaccinated'] != null)
                        totalVacc += Data[i]['data'].last['people_vaccinated'];
                      else{
                        if(Data[i]['data'].last['people_fully_vaccinated']!=null)
                          totalVacc+=Data[i]['data'].last['people_fully_vaccinated'];
                      }
                    }
                  }
                  if(Data[i]['data'].length>1){
                    if (Data[i]['data'].last['total_vaccinations']!=null) {
                      totalVacc += Data[i]['data'].last['total_vaccinations'];
                    }
                    else {
                      if (Data[i]['data'].last['people_vaccinated']!= null)
                        totalVacc += Data[i]['data'].last['people_vaccinated'];
                      else{
                        if(Data[i]['data'].last['people_fully_vaccinated']!=null)
                          totalVacc+=Data[i]['data'].last['people_fully_vaccinated'];
                      }
                    }
                  }
                }
              }
              for (int i = 0; i < Data.length; i++) {
                if (Data[i]['data'].last['date'] == last_date) {
                  if (Data[i]['data'].last['people_fully_vaccinated']!= null) {
                    totalfullyVacc += Data[i]['data'].last['people_fully_vaccinated'];
                  }
                  else {
                    if(Data[i]['data'].length==1){
                      if(Data[i]['data'].last['people_fully_vaccinated']!=null)
                        totalfullyVacc += Data[i]['data'].last['people_fully_vaccinated'];
                    }
                    if(Data[i]['data'].length>1){
                      if (Data[i]['data'].last['people_fully_vaccinated'] != null)
                         totalfullyVacc += Data[i]['data'].last['people_fully_vaccinated'];
                    }
                  }
                }
                else {
                  if(Data[i]['data'].length==1){
                    if(Data[i]['data'].last['people_fully_vaccinated']!=null)
                      totalfullyVacc += Data[i]['data'].last['people_fully_vaccinated'];
                  }
                  if(Data[i]['data'].length>1){
                    if (Data[i]['data'].last['people_fully_vaccinated']!= null)
                      totalfullyVacc += Data[i]['data'].last['people_fully_vaccinated'];
                  }
                }
              }
              for (int i = 0; i < Data.length; i++) {
                if (Data[i]['data'].last['date'] == last_date) {
                  if (Data[i]['data'].last['daily_vaccinations']!= null) {
                    dailyVacc += Data[i]['data'].last['daily_vaccinations'];
                  }
                  else {
                    if(Data[i]['data'].length==1){
                      if(Data[i]['data'].last['daily_vaccinations']!=null)
                        dailyVacc += Data[i]['data'].last['daily_vaccinations'];
                    }
                    if(Data[i]['data'].length>1){
                      if (Data[i]['data'].last['daily_vaccinations'] != null)
                        dailyVacc += Data[i]['data'].last['daily_vaccinations'];
                    }
                  }
                }
                else {
                  if(Data[i]['data'].length==1){
                    if(Data[i]['data'].last['daily_vaccinations']!=null)
                      dailyVacc += Data[i]['data'].last['daily_vaccinations'];
                  }
                  if(Data[i]['data'].length>1){
                    if (Data[i]['data'].last['daily_vaccinations'] != null)
                      dailyVacc +=Data[i]['data'].last['daily_vaccinations'];
                  }
                }
              }
              int graph_totalVacc=0;
              int graph_dailyVacc=0;
              var year=last_date.split('-')[0];
              var month=last_date.split('-')[1];
              var day=last_date.split('-')[2];
              var graph_date=new DateTime(int.parse(year),int.parse(month),int.parse(day));
              List <dynamic> tm=List <dynamic>();
              List <dynamic> dm=List <dynamic>();
              var graph_last_date;
              var graph_last_date2;
              last_date2=DateFormat('MM-dd').format(DateTime.parse(last_date2)).toString();

              for(int i=27; i>=0; i--){
                graph_last_date=graph_date.subtract(new Duration(days: i));
                graph_last_date2=graph_date.subtract(new Duration(days: i));
                graph_last_date=DateFormat('yyyy-MM-dd').format(graph_last_date);
                graph_last_date2=DateFormat('MM-dd').format(graph_last_date2);
                for(int j=0; j<Data.length; j++){
                  for(int k=0; k<Data[j]['data'].length; k++){
                    if(Data[j]['data'][k]['date']==graph_last_date){
                      if(Data[j]['data'][k]['total_vaccinations']!=null)
                        graph_totalVacc+=Data[j]['data'][k]['total_vaccinations'];
                        break;
                    }
                  }
                }
                Graph_totalVacc.add({'date':graph_last_date2, 'graph_totalVacc':graph_totalVacc});
                tm.add(graph_totalVacc);
                graph_totalVacc=0;
              }
              tmin=tm.cast<num>().reduce(min);
              tmax=tm.cast<num>().reduce(max);

              for(int i=27; i>=0; i--){
                graph_last_date=graph_date.subtract(new Duration(days: i));
                graph_last_date2=graph_date.subtract(new Duration(days: i));
                graph_last_date=DateFormat('yyyy-MM-dd').format(graph_last_date);
                graph_last_date2=DateFormat('MM-dd').format(graph_last_date2);
                for(int j=0; j<Data.length; j++){
                  for(int k=0; k<Data[j]['data'].length; k++){
                    if(Data[j]['data'][k]['date']==graph_last_date){
                      if(Data[j]['data'][k]['daily_vaccinations']!=null){
                        graph_dailyVacc+=Data[j]['data'][k]['daily_vaccinations'];
                        break;
                      }
                    }
                  }
                }
                Graph_dailyVacc.add({'date':graph_last_date2, 'graph_dailyVacc':graph_dailyVacc});
                dm.add(graph_dailyVacc);
                graph_dailyVacc=0;
              }
              dmin=dm.cast<num>().reduce(min);
              dmax=dm.cast<num>().reduce(max);
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    height:70,
                    child: Text("   Total Vacc.                                                        Parsed latest date\n   ${totalVacc.toString()} people                                                    $last_date\n"
                        "   Total fully Vacc.                                                            Daily Vacc. \n   ${totalfullyVacc.toString()} people                                       ${dailyVacc.toString()} people",style: TextStyle(fontSize: 12),),
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
                                )
                              ],
                            ),
                        ),
                        Consumer<GraphCounterProvider>(builder: (context,counter,child)=>
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                    visible: (counter._counter==1 || counter._counter==0),
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
                                                    FlSpot(0, (Graph_totalVacc[21]['graph_totalVacc']/1000000000).toDouble()),
                                                    FlSpot(1, (Graph_totalVacc[22]['graph_totalVacc']/1000000000).toDouble()),
                                                    FlSpot(2, (Graph_totalVacc[23]['graph_totalVacc']/1000000000).toDouble()),
                                                    FlSpot(3, (Graph_totalVacc[24]['graph_totalVacc']/1000000000).toDouble()),
                                                    FlSpot(4, (Graph_totalVacc[25]['graph_totalVacc']/1000000000).toDouble()),
                                                    FlSpot(5, (Graph_totalVacc[26]['graph_totalVacc']/1000000000).toDouble()),
                                                    FlSpot(6, (Graph_totalVacc[27]['graph_totalVacc']/1000000000).toDouble()),
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
                                              minY: (tmin/1000000000).toDouble()-1,
                                              maxY: (tmax/1000000000).toDouble()+1,
                                              titlesData: FlTitlesData(
                                                  bottomTitles: SideTitles(
                                                      showTitles: true,
                                                      getTextStyles: (value)=>const TextStyle(fontSize: 9, color: Colors.black, fontWeight: FontWeight.bold),
                                                      getTitles: (value){
                                                        switch (value.toInt()) {
                                                          case 0:
                                                            return '${Graph_totalVacc[21]['date']}';
                                                          case 1:
                                                            return '${Graph_totalVacc[22]['date']}';
                                                          case 2:
                                                            return '${Graph_totalVacc[23]['date']}';
                                                          case 3:
                                                            return '${Graph_totalVacc[24]['date']}';
                                                          case 4:
                                                            return '${Graph_totalVacc[25]['date']}';
                                                          case 5:
                                                            return '${Graph_totalVacc[26]['date']}';
                                                          case 6:
                                                            return '${Graph_totalVacc[27]['date']}';
                                                          default:
                                                            return '';
                                                        }
                                                      }
                                                  ),
                                                  leftTitles: SideTitles(
                                                      showTitles: true,
                                                      getTextStyles: (value)=>const TextStyle(fontSize: 9, color: Colors.black, fontWeight: FontWeight.bold),
                                                      getTitles: (value){
                                                        return '${value.toStringAsFixed(1)}B';
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
                                                    FlSpot(0, (Graph_dailyVacc[21]['graph_dailyVacc']/1000000)),
                                                    FlSpot(1, (Graph_dailyVacc[22]['graph_dailyVacc']/1000000)),
                                                    FlSpot(2, (Graph_dailyVacc[23]['graph_dailyVacc']/1000000)),
                                                    FlSpot(3, (Graph_dailyVacc[24]['graph_dailyVacc']/1000000)),
                                                    FlSpot(4, (Graph_dailyVacc[25]['graph_dailyVacc']/1000000)),
                                                    FlSpot(5, (Graph_dailyVacc[26]['graph_dailyVacc']/1000000)),
                                                    FlSpot(6, (Graph_dailyVacc[27]['graph_dailyVacc']/1000000)),
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
                                                            return '${Graph_dailyVacc[21]['date']}';
                                                          case 1:
                                                            return '${Graph_dailyVacc[22]['date']}';
                                                          case 2:
                                                            return '${Graph_dailyVacc[23]['date']}';
                                                          case 3:
                                                            return '${Graph_dailyVacc[24]['date']}';
                                                          case 4:
                                                            return '${Graph_dailyVacc[25]['date']}';
                                                          case 5:
                                                            return '${Graph_dailyVacc[26]['date']}';
                                                          case 6:
                                                            return '${Graph_dailyVacc[27]['date']}';
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
                                                    FlSpot(0, (Graph_totalVacc[0]['graph_totalVacc']/1000000000)),
                                                    FlSpot(1, (Graph_totalVacc[1]['graph_totalVacc']/1000000000)),
                                                    FlSpot(2, (Graph_totalVacc[2]['graph_totalVacc']/1000000000)),
                                                    FlSpot(3, (Graph_totalVacc[3]['graph_totalVacc']/1000000000)),
                                                    FlSpot(4, (Graph_totalVacc[4]['graph_totalVacc']/1000000000)),
                                                    FlSpot(5, (Graph_totalVacc[5]['graph_totalVacc']/1000000000)),
                                                    FlSpot(6, (Graph_totalVacc[6]['graph_totalVacc']/1000000000)),
                                                    FlSpot(7, (Graph_totalVacc[7]['graph_totalVacc']/1000000000)),
                                                    FlSpot(8, (Graph_totalVacc[8]['graph_totalVacc']/1000000000)),
                                                    FlSpot(9, (Graph_totalVacc[9]['graph_totalVacc']/1000000000)),
                                                    FlSpot(10, (Graph_totalVacc[10]['graph_totalVacc']/1000000000)),
                                                    FlSpot(11, (Graph_totalVacc[11]['graph_totalVacc']/1000000000)),
                                                    FlSpot(12, (Graph_totalVacc[12]['graph_totalVacc']/1000000000)),
                                                    FlSpot(13, (Graph_totalVacc[13]['graph_totalVacc']/1000000000)),
                                                    FlSpot(14, (Graph_totalVacc[14]['graph_totalVacc']/1000000000)),
                                                    FlSpot(15, (Graph_totalVacc[15]['graph_totalVacc']/1000000000)),
                                                    FlSpot(16, (Graph_totalVacc[16]['graph_totalVacc']/1000000000)),
                                                    FlSpot(17, (Graph_totalVacc[17]['graph_totalVacc']/1000000000)),
                                                    FlSpot(18, (Graph_totalVacc[18]['graph_totalVacc']/1000000000)),
                                                    FlSpot(19, (Graph_totalVacc[19]['graph_totalVacc']/1000000000)),
                                                    FlSpot(20, (Graph_totalVacc[20]['graph_totalVacc']/1000000000)),
                                                    FlSpot(21, (Graph_totalVacc[21]['graph_totalVacc']/1000000000)),
                                                    FlSpot(22, (Graph_totalVacc[22]['graph_totalVacc']/1000000000)),
                                                    FlSpot(23, (Graph_totalVacc[23]['graph_totalVacc']/1000000000)),
                                                    FlSpot(24, (Graph_totalVacc[24]['graph_totalVacc']/1000000000)),
                                                    FlSpot(25, (Graph_totalVacc[25]['graph_totalVacc']/1000000000)),
                                                    FlSpot(26, (Graph_totalVacc[26]['graph_totalVacc']/1000000000)),
                                                    FlSpot(27, (Graph_totalVacc[27]['graph_totalVacc']/1000000000)),
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
                                              minY: (tmin/1000000000).toDouble()-1,
                                              maxY: (tmax/1000000000).toDouble()+1,
                                              titlesData: FlTitlesData(
                                                  bottomTitles: SideTitles(
                                                      showTitles: true,
                                                      getTextStyles: (value)=>const TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold),
                                                      getTitles: (value){
                                                        switch (value.toInt()) {
                                                          case 0:
                                                            return '${Graph_totalVacc[0]['date']}';
                                                          case 6:
                                                            return '${Graph_totalVacc[6]['date']}';
                                                          case 13:
                                                            return '${Graph_totalVacc[13]['date']}';
                                                          case 20:
                                                            return '${Graph_totalVacc[20]['date']}';
                                                          case 27:
                                                            return '${Graph_totalVacc[27]['date']}';
                                                          default:
                                                            return '';
                                                        }
                                                      }
                                                  ),
                                                  leftTitles: SideTitles(
                                                      showTitles: true,
                                                      getTextStyles: (value)=>const TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold),
                                                      getTitles: (value){
                                                        return '${value.toStringAsFixed(1)}B';
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
                                                    FlSpot(0, (Graph_dailyVacc[0]['graph_dailyVacc']/1000000)),
                                                    FlSpot(1, (Graph_dailyVacc[1]['graph_dailyVacc']/1000000)),
                                                    FlSpot(2, (Graph_dailyVacc[2]['graph_dailyVacc']/1000000)),
                                                    FlSpot(3, (Graph_dailyVacc[3]['graph_dailyVacc']/1000000)),
                                                    FlSpot(4, (Graph_dailyVacc[4]['graph_dailyVacc']/1000000)),
                                                    FlSpot(5, (Graph_dailyVacc[5]['graph_dailyVacc']/1000000)),
                                                    FlSpot(6, (Graph_dailyVacc[6]['graph_dailyVacc']/1000000)),
                                                    FlSpot(7, (Graph_dailyVacc[7]['graph_dailyVacc']/1000000)),
                                                    FlSpot(8, (Graph_dailyVacc[8]['graph_dailyVacc']/1000000)),
                                                    FlSpot(9, (Graph_dailyVacc[9]['graph_dailyVacc']/1000000)),
                                                    FlSpot(10, (Graph_dailyVacc[10]['graph_dailyVacc']/1000000)),
                                                    FlSpot(11, (Graph_dailyVacc[11]['graph_dailyVacc']/1000000)),
                                                    FlSpot(12, (Graph_dailyVacc[12]['graph_dailyVacc']/1000000)),
                                                    FlSpot(13, (Graph_dailyVacc[13]['graph_dailyVacc']/1000000)),
                                                    FlSpot(14, (Graph_dailyVacc[14]['graph_dailyVacc']/1000000)),
                                                    FlSpot(15, (Graph_dailyVacc[15]['graph_dailyVacc']/1000000)),
                                                    FlSpot(16, (Graph_dailyVacc[16]['graph_dailyVacc']/1000000)),
                                                    FlSpot(17, (Graph_dailyVacc[17]['graph_dailyVacc']/1000000)),
                                                    FlSpot(18, (Graph_dailyVacc[18]['graph_dailyVacc']/1000000)),
                                                    FlSpot(19, (Graph_dailyVacc[19]['graph_dailyVacc']/1000000)),
                                                    FlSpot(20, (Graph_dailyVacc[20]['graph_dailyVacc']/1000000)),
                                                    FlSpot(21, (Graph_dailyVacc[21]['graph_dailyVacc']/1000000)),
                                                    FlSpot(22, (Graph_dailyVacc[22]['graph_dailyVacc']/1000000)),
                                                    FlSpot(23, (Graph_dailyVacc[23]['graph_dailyVacc']/1000000)),
                                                    FlSpot(24, (Graph_dailyVacc[24]['graph_dailyVacc']/1000000)),
                                                    FlSpot(25, (Graph_dailyVacc[25]['graph_dailyVacc']/1000000)),
                                                    FlSpot(26, (Graph_dailyVacc[26]['graph_dailyVacc']/1000000)),
                                                    FlSpot(27, (Graph_dailyVacc[27]['graph_dailyVacc']/1000000)),
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
                                                            return '${Graph_dailyVacc[0]['date']}';
                                                          case 6:
                                                            return '${Graph_dailyVacc[6]['date']}';
                                                          case 13:
                                                            return '${Graph_dailyVacc[13]['date']}';
                                                          case 20:
                                                            return '${Graph_dailyVacc[20]['date']}';
                                                          case 27:
                                                            return '${Graph_dailyVacc[27]['date']}';
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
                            )
                          )
                        ],
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
                                TextButton(onPressed: ()=> table.Table1() , child: Text('Country_name',
                                    style: TextStyle(
                                      fontSize: 14,
                                    )
                                  ),
                                ),
                                TextButton(onPressed:  ()=> table.Table2(), child: Text('Total_vacc',
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
                                for(int i=0; i<Data.length; i++){
                                  List<dynamic> record=List<dynamic>();
                                  record.add(Data[i]['country']);
                                  record.add(Data[i]['data'].last['total_vaccinations']);
                                  record.add(Data[i]['data'].last['people_fully_vaccinated']);
                                  record.add(Data[i]['data'].last['daily_vaccinations']);
                                  lists.add(record);
                                }
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
                                              Text("total"),
                                              Text("fully"),
                                              Text("daily")
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
                                for(int i=0; i<Data.length; i++){
                                  List<dynamic> record=List<dynamic>();
                                  record.add(Data[i]['country']);
                                  record.add(Data[i]['data'].last['total_vaccinations']);
                                  record.add(Data[i]['data'].last['people_fully_vaccinated']);
                                  record.add(Data[i]['data'].last['daily_vaccinations']);
                                  lists.add(record);
                                }
                                lists.sort((a, b) => b[1].compareTo(a[1]));
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
                                              Text("total"),
                                              Text("fully"),
                                              Text("daily")
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
                              else {
                                return Text('');
                              }
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
        onPressed:(){ Navigator.pushNamed(context, '/navigationpage',arguments: {"ID":arguments["ID"], "previous_page": "Vaccine Page"}
        );},
        child: Icon(Icons.list),
      ),
    );
  }
}
class GraphCounterProvider with ChangeNotifier{
  int _counter=1;
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

  int _counter;
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
}