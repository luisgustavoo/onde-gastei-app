import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_register_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/widgets/expenses_list_tile.dart';
import 'package:provider/provider.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: OndeGasteiTextForm(
              label: 'Pesquisar',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Order por'),
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: '0',
                        child: Text('Maior data'),
                      ),
                      const PopupMenuItem<String>(
                        value: '1',
                        child: Text('Menor data'),
                      ),
                      const PopupMenuItem<String>(
                        value: '2',
                        child: Text('Maior valor'),
                      ),
                      const PopupMenuItem<String>(
                        value: '3',
                        child: Text('Menor valor'),
                      ),
                    ],
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<ExpensesControllerImpl>(
                builder: (context, expensesController, _) {
                  if (expensesController.state == expensesState.error) {
                    return const Center(
                      child: Text('Erro ao buscar despesas'),
                    );
                  }

                  if (expensesController.state == expensesState.loading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 1.w,
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final expense = expensesController.expensesList[index];

                      return ExpensesListTile(
                        expenseModel: expense,
                        expensesController: expensesController,
                        isFirst: index == 0,
                        isLast:
                            index == expensesController.expensesList.length - 1,
                      );

                      // return ListTile(
                      //   onTap: () {
                      //     Navigator.of(context).pushNamed(
                      //       ExpensesRegisterPage.router,
                      //       arguments: expense,
                      //     );
                      //   },
                      //   leading: Column(
                      //     children: [
                      //       // Visibility(child: Expanded(child: VerticalDivider(color: Colors.black, thickness: 2,)), visible: index != 0),
                      //       CircleAvatar(
                      //         backgroundColor:
                      //             Color(expense.category.colorCode),
                      //         child: Icon(
                      //           IconData(
                      //             expense.category.iconCode,
                      //             fontFamily: 'MaterialIcons',
                      //           ),
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //       // Visibility(child: Expanded(child: VerticalDivider(color: Colors.black, thickness: 2,)), visible: index != expensesController.expensesList.length - 1),
                      //     ],
                      //   ),
                      //   title: Text(
                      //     expense.description,
                      //     style: const TextStyle(fontWeight: FontWeight.bold),
                      //   ),
                      //   subtitle: Text(
                      //     DateFormat('dd/MM/y', 'pt_BR').format(expense.date),
                      //   ),
                      //   trailing: Text(
                      //     NumberFormat.currency(locale: 'pt_BR', symbol: r'R$')
                      //         .format(expense.value),
                      //     style: TextStyle(
                      //       fontSize: 15.sp,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // );
                    },
                    itemCount: expensesController.expensesList.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
