import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:fmdog/category/model/category.dart';
import 'package:fmdog/ui/base_screen.dart';
import 'package:fmdog/ui/category/add_edit_category_screen.dart';
import 'package:fmdog/utils/custom_text_style.dart';
import 'package:fmdog/utils/enum/transaction_type.dart';
import 'package:fmdog/viewmodels/manage_category_view_model.dart';
import 'package:fmdog/core/theme/theme.dart';

class ManageCategoryScreen extends StatefulWidget {
  const ManageCategoryScreen({super.key});

  @override
  State<ManageCategoryScreen> createState() => _ManageCategoryScreenState();
}

class _ManageCategoryScreenState extends State<ManageCategoryScreen> {
  late ManageCategoryViewModel _manageCategoryViewModel;

  int? groupValue = 0;
  bool _isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return BaseScreen<ManageCategoryViewModel>(
        onModelReady: (model) {
          _manageCategoryViewModel = model;
          _manageCategoryViewModel.initState();
        },
        builder: (context, model, child) => _scaffold());
  }

  Widget _scaffold() {
    return Scaffold(
      backgroundColor: context.appHomeScreenBgColor,
      appBar: AppBar(
          title: const Text("Categories"),
          actions: _appBarActions()),
      body: _body(),
      floatingActionButton: _fab(),
    );
  }

  List<Widget> _appBarActions() {
    List<Widget> list = [];
    if (!_isEditMode) {
      var editWidget = InkWell(
        onTap: () {
          setState(() {
            _isEditMode = true;
          });
        },
        child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: const Icon(Icons.edit_outlined)),
      );
      list.add(editWidget);
    } else {
      var doneWidget = InkWell(
        onTap: () {
          setState(() {
            _isEditMode = false;
          });
        },
        child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: const Icon(Icons.done)),
      );
      list.add(doneWidget);
    }
    return list;
  }

  Widget _body() {
    return Stack(
      children: [
        _listView(),
        Positioned.fill(
            child: Align(
                alignment: Alignment.bottomCenter, child: _segmentControl())),
      ],
    );
  }

  Widget _listView() {
    return ListView.builder(
        padding:
            const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 100),
        itemCount: _manageCategoryViewModel.filteredCategories.length,
        itemBuilder: (context, index) {
          return _row(_manageCategoryViewModel.filteredCategories[index]);
        });
  }

  Widget _segmentControl() {
    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 24),
      child: CustomSlidingSegmentedControl<int>(
        initialValue: groupValue,
        padding: 18,
        children: const {0: Text('Expense'), 1: Text('Income')},
        decoration: BoxDecoration(
          color: context.appToggleBgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: context.appSecondaryColor.withOpacity(0.8),
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: const Offset(
                0.0,
                2.0,
              ),
            ),
          ],
        ),
        thumbDecoration: BoxDecoration(
          color: context.appSecondaryColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: context.appPrimaryColor.withOpacity(.05),
              blurRadius: 2.0,
              spreadRadius: 0.5,
              offset: const Offset(
                0.0,
                2.0,
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInToLinear,
        onValueChanged: (int? value) {
          groupValue = value;
          var type =
              value == 0 ? TransactionType.expense : TransactionType.income;
          setState(() {
            _manageCategoryViewModel.setTransactionType(type);
          });
        },
      ),
    );
  }

  Widget buildSegment(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: context.appSecondaryColor),
      ),
    );
  }

  Widget _row(Category category) {
    return InkWell(
      onTap: _isEditMode
          ? null
          : () => _openAddEditCategoryScreen(category: category),
      child: Container(
        padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
        child: Column(
          children: [
            Row(
              children: [
                Text(category.emoji,
                    style: CustomTextStyle.emojiStyle(
                        context: context, fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(category.isActive ? "Show" : "Hidden",
                          style: TextStyle(
                              fontSize: 12,
                              color: context.appPrimaryColor.withOpacity(0.6))),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 12),
                if (_isEditMode)
                  _switchWidget(category, (value) {
                    setState(() {
                      _manageCategoryViewModel.setStatus(
                          category: category, status: value);
                    });
                  })
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 0, thickness: 0)
          ],
        ),
      ),
    );
  }

  Widget _switchWidget(Category category, ValueChanged<bool> callback) {
    // var widget = Container(
    //   height: 34.0,
    //   width: 42.0,
    //   child: FittedBox(
    //       fit: BoxFit.contain,
    //       child: CupertinoSwitch(
    //           value: category.isActive,
    //           activeColor: context.appPrimaryColor.withOpacity(0.8),
    //           onChanged: callback)),
    // );

    var widget = Switch(
        value: category.isActive,
        activeColor: context.appPrimaryColor.withOpacity(0.8),
        onChanged: callback);

    return widget;
  }

  void _openAddEditCategoryScreen({Category? category}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditCategoryScreen(
              category: category,
              transactionType: _manageCategoryViewModel.selectedTransactionType,
              addOrEditPerformed: () => _manageCategoryViewModel.initState(),
            )));
  }

  Widget _fab() {
    return FloatingActionButton(
      onPressed: () => _openAddEditCategoryScreen(),
      tooltip: 'Add Category',
      backgroundColor: context.appSecondaryColor,
      child: Icon(
        Icons.add,
        size: 32,
        color: context.appPrimaryColor,
      ),
    );
  }
}
