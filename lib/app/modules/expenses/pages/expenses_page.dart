import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_register_page.dart';
import 'package:provider/provider.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ExpensesControllerImpl>(
        builder: (context, expensesController, _) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final expense = expensesController.expensesList[index];

              return ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ExpensesRegisterPage.router,
                    arguments: expense,
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Color(expense.category.colorCode),
                  child: Icon(
                    IconData(
                      expense.category.iconCode,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: Colors.white,
                  ),
                ),
                title: Text(expense.description),
                subtitle: Text(
                  DateFormat('d/MM/y', 'pt_BR').format(expense.date),
                ),
                trailing: Text(
                  NumberFormat.currency(locale: 'pt_BR', symbol: r'R$')
                      .format(expense.value),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            itemCount: expensesController.expensesList.length,
          );
        },
      ),
    );
  }
}
