import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/helpers/input_formatter/currency_input_formatter_ptbr.dart';
import 'package:onde_gastei_app/app/core/helpers/input_formatter/date_input_formatter_ptbr.dart';
import 'package:onde_gastei_app/app/core/helpers/validators/validators.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_snack_bar.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class ExpensesRegisterPage extends StatefulWidget {
  const ExpensesRegisterPage({
    this.expenseModel,
    this.isEditing = false,
    Key? key,
  }) : super(key: key);

  static const router = 'expenses/register';
  final bool isEditing;
  final ExpenseModel? expenseModel;

  @override
  State<ExpensesRegisterPage> createState() => _ExpensesRegisterPageState();
}

class _ExpensesRegisterPageState extends State<ExpensesRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldMessagedKey = GlobalKey<ScaffoldMessengerState>();
  bool _edited = false;

  CategoryModel? _selectedCategory;

  late TextEditingController descriptionController;

  late TextEditingController dateController;

  late TextEditingController valueController;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(
      text:
          widget.expenseModel != null ? widget.expenseModel!.description : null,
    );

    dateController = TextEditingController(
      text: DateFormat.yMd('pt_BR').format(
        widget.expenseModel != null
            ? widget.expenseModel!.date
            : DateTime.now(),
      ),
    );

    valueController = TextEditingController(
      text: NumberFormat.currency(
        locale: 'pt-BR',
        symbol: r'R$',
        decimalDigits: 2,
      ).format(
        widget.expenseModel != null ? widget.expenseModel!.value : 0,
      ),
    );

    if (widget.expenseModel != null) {
      _selectedCategory = widget.expenseModel!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final expensesController = context.read<ExpensesControllerImpl>();
    final state = context.select<ExpensesControllerImpl, expensesState>(
      (expensesController) => expensesController.state,
    );
    final categoriesList =
        context.select<CategoriesControllerImpl, List<CategoryModel>>(
      (categoriesController) => categoriesController.categoriesList,
    );

    return ScaffoldMessenger(
      key: _scaffoldMessagedKey,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(_edited);
            },
            icon: const Icon(Icons.close),
          ),
          title: const Text('Despesa'),
          actions: [
            _buildDeleteButton(context, expensesController),
          ],
        ),
        body: IgnorePointer(
          ignoring: state == expensesState.loading,
          child: ListView(
            padding: EdgeInsets.only(top: 32.h, left: 16.w, right: 16.w),
            physics: const BouncingScrollPhysics(),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    OndeGasteiTextForm(
                      key: const Key('description_key_expenses_register_page'),
                      controller: descriptionController,
                      label: 'Descrição',
                      prefixIcon: const Icon(Icons.list),
                      validator: Validatorless.required('Informe a descrição'),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    OndeGasteiTextForm(
                      key: const Key('value_key_expenses_register_page'),
                      controller: valueController,
                      label: 'Valor',
                      prefixIcon: const Icon(Icons.attach_money),
                      textInputType: TextInputType.number,
                      inputFormatters: [CurrencyInputFormatterPtBr()],
                      validator: Validators.value(),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    OndeGasteiTextForm(
                      key: const Key('date_key_expenses_register_page'),
                      controller: dateController,
                      label: 'Data',
                      prefixIcon: const Icon(Icons.date_range),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final result = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2099),
                          );

                          if (result != null) {
                            dateController.text =
                                DateFormat.yMd('pt_BR').format(result);
                          }
                        },
                        icon: const Icon(Icons.search_outlined),
                      ),
                      textInputType: TextInputType.datetime,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(10),
                        DateInputFormatterPtbr(),
                      ],
                      validator: Validators.date(),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    DropdownButtonFormField<CategoryModel>(
                      key: const Key('categories_key_expenses_register_page'),
                      validator: (category) {
                        if (category == null) {
                          return 'Informe a categoria';
                        }
                        return null;
                      },
                      onChanged: (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      value: _selectedCategory,
                      hint: const Text(
                        'Selecione a categoria',
                        style: TextStyle(
                          color: Constants.hintStyleColor,
                        ),
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 2.h,
                          horizontal: _selectedCategory == null ? 8.h : 0,
                        ),
                      ),
                      isExpanded: true,
                      isDense: false,
                      items: categoriesList.map((category) {
                        return DropdownMenuItem<CategoryModel>(
                          value: category,
                          child: ListTile(
                            // key: Key(
                            //   'list_tile_items_key_${category.id}_expenses_register_page',
                            // ),
                            leading: CircleAvatar(
                              backgroundColor: Color(category.colorCode),
                              child: Icon(
                                IconData(
                                  category.iconCode,
                                  fontFamily: 'MaterialIcons',
                                ),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(category.description),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    OndeGasteiButton(
                      const Text(
                        'Salvar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;

                        if (formValid) {
                          SnackBar snackBar;

                          String message;

                          try {
                            _edited = true;

                            if (!widget.isEditing) {
                              await expensesController.register(
                                description: descriptionController.text.trim(),
                                value:
                                    Validators.parseLocalFormatValueToIso4217(
                                  valueController.text,
                                ),
                                date: Validators.parseLocalFormatDateToIso8601(
                                  dateController.text,
                                ),
                                category: _selectedCategory!,
                                userId: userModel?.userId ?? 0,
                              );

                              message = 'Despesa registrada com sucesso!';
                            } else {
                              await expensesController.update(
                                description: widget.expenseModel!.description,
                                value: widget.expenseModel!.value,
                                date: widget.expenseModel!.date,
                                category: _selectedCategory!,
                                expenseId: widget.expenseModel!.expenseId ?? 0,
                              );
                              message = 'Despesa atualizada com sucesso!';
                            }

                            if (!mounted) {
                              return;
                            }

                            snackBar = OndeGasteiSnackBar.buildSnackBar(
                              key: const Key(
                                'snack_bar_success_key_register_expenses_page',
                              ),
                              content: Text(message),
                              backgroundColor: Theme.of(context).primaryColor,
                              label: 'Fechar',
                              onPressed: () {},
                            );

                            _resetFields();
                          } on Failure {
                            snackBar = OndeGasteiSnackBar.buildSnackBar(
                              key: const Key(
                                'snack_bar_error_key_expenses_register_page',
                              ),
                              content: widget.isEditing
                                  ? const Text('Erro ao atualizar despesa!')
                                  : const Text('Erro ao registrar despesa!'),
                              backgroundColor: Colors.red,
                              label: 'Fechar',
                              onPressed: () {},
                            );
                          }

                          _scaffoldMessagedKey.currentState!
                              .showSnackBar(snackBar);
                        }
                      },
                      isLoading: state == expensesState.loading,
                      key: const Key(
                        'register_button_key_expenses_register_page',
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Visibility _buildDeleteButton(
    BuildContext pageContext,
    ExpensesControllerImpl expensesController,
  ) {
    return Visibility(
      visible: widget.isEditing,
      child: IconButton(
        onPressed: () async {
          await showDialog<void>(
            context: pageContext,
            barrierDismissible: false,
            builder: (dialogContext) {
              return AlertDialog(
                key: const Key(
                  'alert_delete_dialog_key_register_expenses_page',
                ),
                title: const Text('Deletar despesa'),
                content: Text(
                  'Deseja deletar a despesa ${widget.expenseModel?.description}?',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    key: const Key(
                      'delete_button_dialog_register_expenses_page',
                    ),
                    onPressed: () async {
                      try {
                        _edited = true;

                        await expensesController.delete(
                          expenseId: widget.expenseModel?.expenseId ?? 0,
                        );

                        if (!mounted) {
                          return;
                        }

                        if (Navigator.of(dialogContext).canPop()) {
                          Navigator.of(dialogContext).pop(_edited);
                        }

                        if (Navigator.of(pageContext).canPop()) {
                          Navigator.of(pageContext).pop(_edited);
                        }
                      } on Failure {
                        final snackBar = OndeGasteiSnackBar.buildSnackBar(
                          key: const Key(
                            'snack_bar_fail_delete_key_register_update_expenses_page',
                          ),
                          content: const Text('Erro ao deletar despesa'),
                          backgroundColor: Colors.red,
                          label: 'Fechar',
                          onPressed: () {},
                        );

                        _scaffoldMessagedKey.currentState!
                            .showSnackBar(snackBar);
                      }
                    },
                    child: expensesController.deleteState ==
                            categoriesDeleteState.loading
                        ? SizedBox(
                            height: 15.h,
                            width: 15.w,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 1.w,
                            ),
                          )
                        : const Text(
                            'Deletar',
                            style: TextStyle(color: Colors.red),
                          ),
                  )
                ],
              );
            },
          );
        },
        splashRadius: 25.r,
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
          key: Key('icon_delete_key_register_expenses_page'),
        ),
      ),
    );
  }

  void _resetFields() {
    descriptionController.clear();

    dateController = TextEditingController(
      text: DateFormat.yMd('pt_BR').format(
        DateTime.now(),
      ),
    );

    valueController = TextEditingController(
      text: NumberFormat.currency(
        locale: 'pt-BR',
        symbol: r'R$',
        decimalDigits: 2,
      ).format(0),
    );

    _selectedCategory = null;
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
    dateController.dispose();
    valueController.dispose();
  }
}
