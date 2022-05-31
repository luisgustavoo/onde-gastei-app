import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';

class ExpensesListTile extends StatelessWidget {
  const ExpensesListTile({
    required this.expenseModel,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final ExpenseModel expenseModel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Color(expenseModel.category.colorCode),
        child: Icon(
          IconData(
            expenseModel.category.iconCode,
            fontFamily: 'MaterialIcons',
          ),
          color: Colors.white,
        ),
      ),
      title: Text(
        expenseModel.description,
        style: TextStyle(
          fontSize: 15.sp,
          // fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        expenseModel.local ?? '',
        style: TextStyle(fontSize: 12.sp),
      ),
      trailing: Text(
        NumberFormat.currency(
          locale: 'pt_BR',
          symbol: r'R$',
        ).format(expenseModel.value),
        style: TextStyle(
          fontSize: 13.sp,
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
