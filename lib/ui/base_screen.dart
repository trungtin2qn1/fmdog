import 'package:flutter/material.dart';
import 'package:fmdog/di/service_locator.dart';
import 'package:fmdog/viewmodels/base_view_model.dart';
import 'package:provider/provider.dart';

class BaseScreen<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T)? onModelReady;

  const BaseScreen({Key? key, required this.builder, this.onModelReady})
      : super(key: key);

  @override
  State<BaseScreen<T>> createState() => _BaseScreenState<T>();
}

class _BaseScreenState<T extends BaseViewModel> extends State<BaseScreen<T>> {
  T model = locator<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) widget.onModelReady!(model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (BuildContext context) => model,
      child: Consumer<T>(
        builder: widget.builder,
      ),
    );
  }
}
