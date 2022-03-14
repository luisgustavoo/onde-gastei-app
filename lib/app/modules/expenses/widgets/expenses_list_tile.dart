import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';

class ExpensesListTile extends StatelessWidget {
  const ExpensesListTile({
    required this.expenseModel,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final ExpenseModel expenseModel;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
