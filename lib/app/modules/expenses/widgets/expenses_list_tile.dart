import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_register_page.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';

class ExpensesListTile extends StatelessWidget {
  const ExpensesListTile({
    required this.expenseModel,
    required this.expensesController,
    required this.isFirst,
    required this.isLast,
    Key? key,
  }) : super(key: key);

  final ExpenseModel expenseModel;
  final ExpensesController expensesController;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final edited = await Navigator.of(context).pushNamed(
          ExpensesRegisterPage.router,
          arguments: expenseModel,
        ) as bool?;

        if (edited != null) {
          if (edited) {
            await expensesController.findExpensesByPeriod(
              DateTime(2022),
              DateTime.now(),
              userModel?.userId ?? 0,
            );
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SizedBox(
          height: 60.h,
          child: Row(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Opacity(
                        opacity: isFirst == true ? 0 : 1,
                        child: Container(
                          width: 1,
                          decoration: BoxDecoration(
                            border: Border(
                              left: Divider.createBorderSide(
                                context,
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Color(expenseModel.category.colorCode),
                    child: Icon(
                      IconData(
                        expenseModel.category.iconCode,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Opacity(
                        opacity: isLast == true ? 0 : 1,
                        child: Container(
                          width: 1,
                          decoration: BoxDecoration(
                            border: Border(
                              left: Divider.createBorderSide(
                                context,
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        expenseModel.description,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        DateFormat('dd/MM/y', 'pt_BR')
                            .format(expenseModel.date),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                NumberFormat.currency(
                  locale: 'pt_BR',
                  symbol: r'R$',
                ).format(expenseModel.value),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
