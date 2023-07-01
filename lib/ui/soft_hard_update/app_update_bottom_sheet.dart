import 'package:flutter/material.dart';
import 'package:fmdog/main.dart';
import 'package:fmdog/core/theme/theme.dart';

class AppUpdateBottomSheet extends StatefulWidget {
  final VoidCallback onUpdateClick;
  final bool isDismissible;

  const AppUpdateBottomSheet(
      {Key? key, required this.onUpdateClick, required this.isDismissible})
      : super(key: key);

  @override
  State<AppUpdateBottomSheet> createState() => _AppUpdateBottomSheetState();
}

class _AppUpdateBottomSheetState extends State<AppUpdateBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10)),
          color: context.appSecondaryColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isDismissible) crossIcon(),
            const SizedBox(height: 48),
            const Icon(
              Icons.system_update_outlined,
              size: 80,
            ),
            const SizedBox(height: 48),
            headerWidget(),
            descriptionWidget(),
            const SizedBox(height: 48),
            updateButtonWidget()
          ],
        ));
  }

  Widget crossIcon() {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: onCrossClick,
        child: Icon(
          Icons.cancel,
          size: 30,
          color: context.appPrimaryColor,
        ),
      ),
    );
  }

  Widget headerWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Text(
        "New Update Available!",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: context.appPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget descriptionWidget() {
    return const Text(
        "A new update of this app is now available. Update now!",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, fontSize: 16));
  }

  Widget updateButtonWidget() {
    return SafeArea(
        child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
            backgroundColor: context.appPrimaryColor,
            padding: const EdgeInsets.all(10)),
        child: Text(
          "Update".toUpperCase(),
          style: TextStyle(
              color: context.appSecondaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
      ),
    ));
  }

  void onCrossClick() {
    Navigator.of(navigatorKey.currentContext!).pop();
  }

  void onClick() {
    widget.onUpdateClick();
  }

}
