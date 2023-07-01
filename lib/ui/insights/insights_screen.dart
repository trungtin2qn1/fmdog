import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fmdog/ui/time_range_screen.dart';
import 'package:intl/intl.dart';
import 'package:fmdog/core/theme/theme.dart';
import 'package:fmdog/ui/base_screen.dart';
import 'package:fmdog/viewmodels/insights_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fmdog/utils/broadcast/broadcast_channels.dart';
import 'package:fmdog/utils/broadcast/broadcast_receiver.dart';
import 'package:fmdog/utils/validation_utils.dart';

class ChartSampleData {
  DateTime x;
  double y;
  ChartSampleData({required this.x, required this.y});
}

class ChartCategoryData {
  String x;
  double y;
  ChartCategoryData({required this.x, required this.y});
}

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late InsightsViewModel _insightsViewModel;

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    setBroadcastListener();
    super.initState();
  }

  void setBroadcastListener() {
    _streamSubscription =
        BroadcastReceiver.broadcastController.stream.listen((event) {
      if (ValidationUtils.isValidString(event) &&
          (event == BroadcastChannels.refreshAppUpdateChecker ||
              event == BroadcastChannels.updateTimeRange)) {
        _insightsViewModel.setTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen<InsightsViewModel>(onModelReady: (model) {
      _insightsViewModel = model;
      _insightsViewModel.init();
    }, builder: (context, model, child) {
      return _body();
    });
  }

  Scaffold _body() {
    return Scaffold(
        backgroundColor: context.appHomeScreenBgColor,
        // appBar: AppBar(
        //     title: Text(
        //   "Insights",
        //   style: TextStyle(
        //       color: context.appPrimaryColor,
        //       fontSize: 24,
        //       fontWeight: FontWeight.w600),
        // )),
        body: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 64),
          child: _content(),
        )));
  }

  Widget _content() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TimeRangeScreen(),
            SfCartesianChart(
              title: ChartTitle(text: 'Expenses'),
              plotAreaBorderWidth: 0,
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat.MMMd(),
                majorGridLines: const MajorGridLines(width: 0),
                //Hide the axis line of x-axis
              ),
              primaryYAxis:
                  NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
              series: <ChartSeries<ChartSampleData, DateTime>>[
                ColumnSeries<ChartSampleData, DateTime>(
                    dataSource: _insightsViewModel.chartData,
                    xValueMapper: (ChartSampleData data, _) => data.x,
                    yValueMapper: (ChartSampleData data, _) => data.y,
                    name: 'Gold',
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4)),
                    color: context.appPrimaryColor)
              ],
            ),
            const SizedBox(height: 20),
            SfCircularChart(
              title: ChartTitle(text: 'Expenses by categories (%)'),
              legend: const Legend(
                isVisible: true,
                // position: LegendPosition.bottom,
                // orientation: LegendItemOrientation.horizontal,
              ),
              series: <DoughnutSeries>[
                DoughnutSeries<ChartCategoryData, String>(
                  dataSource: _insightsViewModel.chartCategoryData,
                  xValueMapper: (ChartCategoryData data, _) => data.x,
                  yValueMapper: (ChartCategoryData data, _) => data.y,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    // labelPosition: ChartDataLabelPosition.outside,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _insightsViewModel.removeBoxListener();
    _streamSubscription?.cancel();
    super.dispose();
  }
}
