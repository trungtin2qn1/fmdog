import 'package:flutter/material.dart';
import 'package:fmdog/account/data_source/account_local_data_source.dart';
import 'package:fmdog/category/data_source/category_local_data_source.dart';
import 'package:fmdog/transactions/models/transaction.dart';
import 'package:fmdog/utils/currency_helper.dart';
import 'package:fmdog/utils/custom_text_style.dart';
import 'package:fmdog/utils/validation_utils.dart';
import 'package:fmdog/core/theme/theme.dart';

class TransactionRowWidget extends StatefulWidget {
  final Transaction transaction;
  final AccountLocalDataSource accountLocalDataSource;
  final CategoryLocalDataSource categoryLocalDataSource;
  const TransactionRowWidget(
      {Key? key,
      required this.transaction,
      required this.accountLocalDataSource,
      required this.categoryLocalDataSource})
      : super(key: key);

  @override
  State<TransactionRowWidget> createState() => _TransactionRowWidgetState();
}

class _TransactionRowWidgetState extends State<TransactionRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: _body(),
    );
  }

  Widget _body() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.categoryLocalDataSource
            .fetchCategory(widget.transaction.categoryId)!
            .emoji,
        style: CustomTextStyle.emojiStyle(context: context, fontSize: 24),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          widget.categoryLocalDataSource
                              .fetchCategory(widget.transaction.categoryId)!
                              .name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      if (ValidationUtils.isValidString(
                          widget.transaction.notes))
                        ..._notesWidget()
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                    CurrencyHelper.formattedCurrency(widget.transaction.amount),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
              ],
            ),
            const SizedBox(height: 16),
            const Divider(
              height: 0.5,
              thickness: 0,
            )
          ],
        ),
      )
    ]);
  }

  List<Widget> _notesWidget() {
    return [
      const SizedBox(height: 4),
      Text(widget.transaction.notes ?? "",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 14, color: context.appPrimaryColor.withOpacity(0.6)))
    ];
  }
}
