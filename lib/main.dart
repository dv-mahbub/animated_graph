import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

void main() {
  runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  _MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  late List<LiveData> chartData;
  late ChartSeriesController? _chartSeriesController;
  late Timer _timer;
  int currentIndex = 0;

  // This variable will store the calculated dy.
  int dy = 0;

  @override
  void initState() {
    chartData = getChartData();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (Timer timer) {
      updateDataSource();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                series: <LineSeries<LiveData, int>>[
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    color: Colors.greenAccent,
                    xValueMapper: (LiveData sales, _) => sales.time,
                    yValueMapper: (LiveData sales, _) => sales.speed,
                  )
                ],
                primaryXAxis: NumericAxis(
                  axisLine: AxisLine(width: 0),
                  majorTickLines: MajorTickLines(width: 0),
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.none,
                  interval: 3,
                  labelStyle: TextStyle(color: Colors.transparent),
                  title: AxisTitle(text: ''),
                ),
                primaryYAxis: NumericAxis(
                  axisLine: AxisLine(width: 0),
                  majorTickLines: MajorTickLines(size: 0),
                  majorGridLines: MajorGridLines(width: 0),
                  borderColor: Colors.transparent,
                  labelStyle: TextStyle(color: Colors.transparent),
                  title: AxisTitle(text: ''),
                  minimum: -40,
                  maximum: 100,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Transform.translate(
                offset: Offset(30, dy.toDouble()+300),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int time = 19;

  void updateDataSource() {
    setState(() {
      chartData.removeAt(0);
      chartData.add(LiveData(time++, getChartData()[currentIndex].speed));

      _chartSeriesController?.updateDataSource(
        addedDataIndex: chartData.length - 1,
        removedDataIndex: 0,
      );

      // Calculate the change in speed (dy).
      int previousSpeed = chartData[chartData.length - 2].speed;
      int currentSpeed = chartData[chartData.length - 1].speed;
      dy = currentSpeed - previousSpeed;

      if (currentIndex >= getChartData().length - 1) {
        currentIndex = 0;
      } else {
        currentIndex++;
      }
    });
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 42),
      LiveData(1, 42),
      LiveData(2, 43),
      LiveData(3, 43),
      LiveData(4, 43),
      LiveData(5, 44),
      LiveData(6, 45),
      LiveData(7, 45),
      LiveData(8, 45),
      LiveData(9, 46),
      LiveData(10, 46),
      LiveData(11, 47),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.speed);

  final int time;
  final int speed;
}
