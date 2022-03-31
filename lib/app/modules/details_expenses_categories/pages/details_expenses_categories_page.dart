import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/app.dart';
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
    Key? key,
  }) : super(key: key);

  static const router = '/details-expenses-categories';

  final int userId;
  final int categoryId;
  final String categoryName;
  final DetailsExpensesCategoriesController controller;

  @override
  State<DetailsExpensesCategoriesPage> createState() =>
      _DetailsExpensesCategoriesPageState();
}

class _DetailsExpensesCategoriesPageState
    extends State<DetailsExpensesCategoriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await widget.controller.findExpensesByCategories(
        userId: widget.userId,
        categoryId: widget.categoryId,
        initialDate: dateFilter!.initialDate,
        finalDate: dateFilter!.finalDate,
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
        title: Text(widget.categoryName),
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

              return ExpensesListTile(
                onTap: () {},
                expenseModel: expense,
                isFirst: index == 0,
                isLast: index == expensesCategoryList.length - 1,
              );
            },
          );
        },
      ),
    );
  }
}
