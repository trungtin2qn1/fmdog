import 'package:flutter/material.dart';
import 'package:fmdog/core/theme/theme.dart';
import 'package:fmdog/utils/broadcast/broadcast_channels.dart';
import 'package:fmdog/utils/broadcast/broadcast_receiver.dart';
import 'package:fmdog/viewmodels/time_range_view_model.dart';
import 'package:fmdog/ui/base_screen.dart';
import 'package:fmdog/globals.dart';

class TimeRangeScreen extends StatefulWidget {
  const TimeRangeScreen({Key? key}) : super(key: key);

  @override
  State<TimeRangeScreen> createState() => _TimeRangeScreenState();
}

class _TimeRangeScreenState extends State<TimeRangeScreen> {
  late TimeRangeViewModel _timeRangeViewModel;

  @override
  void initState() {
    // setBroadcastListener();
    super.initState();
  }

  Widget _content() {
    var leftArrow = InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        _timeRangeViewModel.previousMonth();
        BroadcastReceiver.broadcastController.add(BroadcastChannels.updateTimeRange);
      },
      child: Container(
          height: 36,
          width: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: context.appBgColor,
              borderRadius: BorderRadius.circular(18)),
          child: Icon(Icons.arrow_back,
              color: context.appPrimaryColor.withOpacity(0.5))),
    );
    var rightArrow = InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        _timeRangeViewModel.nextMonth();
        BroadcastReceiver.broadcastController.add(BroadcastChannels.updateTimeRange);
      },
      child: Container(
          height: 36,
          width: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: context.appBgColor,
              borderRadius: BorderRadius.circular(18)),
          child: Icon(Icons.arrow_forward,
              color: context.appPrimaryColor.withOpacity(0.5))),
    );
    var rangeWidget = Text(
        "${currTimeline.decoratedStartTime} - ${currTimeline.decoratedEndTime}");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [leftArrow, rangeWidget, rightArrow],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen<TimeRangeViewModel>(onModelReady: (model) {
      _timeRangeViewModel = model;
      _timeRangeViewModel.init();
    }, builder: (context, model, child) {
      return _content();
    });
  }
}
