import 'package:flutter/material.dart';
import 'package:fmdog/core/theme/theme.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isEnable;
  const SaveButton({Key? key, required this.isEnable, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnable ? onTap : null,
      child: Container(
        height: 48,
        margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isEnable
                ? context.appPrimaryColor
                : context.appDisableBgColorBtn,
            borderRadius: const BorderRadius.all(Radius.circular(24))),
        child: Text(
          "Save",
          style: TextStyle(
              fontSize: 20,
              color: isEnable
                  ? context.appSecondaryColor
                  : context.appDisableTextColorBtn),
        ),
      ),
    );
  }
}
