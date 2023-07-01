import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fmdog/ui/alert_dialog_view.dart';
import 'package:fmdog/viewmodels/add_transaction_view_model.dart';
import 'package:provider/provider.dart';
import 'package:fmdog/core/theme/theme.dart';

enum Options { delete }

class HeaderWidget extends StatefulWidget {
  final bool isSync;
  const HeaderWidget({
    required this.isSync,
    Key? key,
  }) : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late AddTransactionViewModel _transactionViewModel;
  @override
  void initState() {
    _transactionViewModel =
        Provider.of<AddTransactionViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isTransactionAlreadyExist =
        _transactionViewModel.currentTransaction != null;
    double topAndBottomPadding = isTransactionAlreadyExist ? 8 : 16;
    return Container(
        padding: EdgeInsets.only(left: 12, right: 12, top: topAndBottomPadding),
        child: IntrinsicHeight(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text("isSync: ${widget.isSync}",
                //       textAlign: TextAlign.center,
                //       style: GoogleFonts.lato(
                //           fontSize: 12, fontWeight: FontWeight.w600)),
                // ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Transaction",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                ),
                if (isTransactionAlreadyExist)
                  Align(
                      alignment: Alignment.centerRight,
                      child: _buildPopupMenu())
              ],
            ),
            SizedBox(height: topAndBottomPadding),
            const Divider(height: 1, thickness: 0)
          ],
        )));
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      color: context.appHomeScreenBgColor,
      onSelected: (value) {
        _onMenuItemSelected(value as int);
      },
      offset: const Offset(0.0, 40),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      itemBuilder: (ctx) => [
        _buildPopupMenuItem(
            'Delete', Icons.delete_outline, Options.delete.index),
      ],
      child: Container(
        height: 36,
        width: 48,
        alignment: Alignment.center,
        child: const Icon(
          Icons.more_vert,
        ),
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            iconData,
            color: context.appPrimaryColor,
          ),
          Text(title),
        ],
      ),
    );
  }

  _onMenuItemSelected(int value) async {
    if (value == Options.delete.index) {
      _deleteTransaction();
    }
  }

  void _deleteTransaction() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialogView(
              title: "Delete Transaction?",
              description: "Are you sure you want to delete this transaction?",
              leftButtonText: "No",
              rightButtonText: "Yes",
              onTapLeftButton: () {
                Navigator.of(context).pop();
              },
              onTapRightButton: () {
                Navigator.of(context).pop();
                _transactionViewModel.deleteTransaction();
              });
        });
  }
}
