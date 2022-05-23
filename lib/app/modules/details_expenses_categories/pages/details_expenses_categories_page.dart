import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:onde_gastei_app/app/core/dtos/date_filter.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_loading.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/controllers/details_expenses_categories_controller.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/controllers/details_expenses_categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/widgets/expenses_list_tile.dart';
import 'package:provider/provider.dart';

class DetailsExpensesCategoriesPage extends StatefulWidget {
  const DetailsExpensesCategoriesPage({
    required this.userId,
    required this.categoryId,
    required this.categoryName,
    required this.controller,
    required this.dateFilter,
    Key? key,
  }) : super(key: key);

  static const router = '/details-expenses-categories';

  final int userId;
  final int categoryId;
  final String categoryName;
  final DetailsExpensesCategoriesController controller;
  final DateFilter dateFilter;

  @override
  State<DetailsExpensesCategoriesPage> createState() =>
      _DetailsExpensesCategoriesPageState();
}

class _DetailsExpensesCategoriesPageState
    extends State<DetailsExpensesCategoriesPage> {
  DateTime? lastDate;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await widget.controller.findExpensesByCategories(
        userId: widget.userId,
        categoryId: widget.categoryId,
        initialDate: widget.dateFilter.initialDate,
        finalDate: widget.dateFilter.finalDate,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select<DetailsExpensesCategoriesControllerImpl,
        DetailsExpensesCategoriesState>((controller) => controller.state);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
        title: Text(
          widget.categoryName,
          // style: const TextStyle(fontFamily: 'Jost'),
        ),
      ),
      body:
          Selector<DetailsExpensesCategoriesControllerImpl, List<ExpenseModel>>(
        selector: (_, controller) => controller.detailsExpensesCategoryList,
        builder: (_, expensesCategoryList, __) {
          if (state == DetailsExpensesCategoriesState.error) {
            return const Center(
              child: Text(
                'Erro a buscar despesas por categoria',
              ),
            );
          }

          if (state == DetailsExpensesCategoriesState.loading) {
            return const OndeGasteiLoading();
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: expensesCategoryList.length,
            itemBuilder: (_, index) {
              final expense = expensesCategoryList[index];

              if (lastDate == null || lastDate != expense.date) {
                lastDate = expense.date;
                return Column(
                  children: [
                    Text(
                      DateFormat('dd/MM/y', 'pt_BR').format(expense.date),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ExpensesListTile(
                      onTap: () {},
                      expenseModel: expense,
                    ),
                  ],
                );
              }

              return ExpensesListTile(
                onTap: () {},
                expenseModel: expense,
              );
            },
          );
        },
      ),
    );
  }
}
