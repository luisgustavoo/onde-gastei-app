import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:onde_gastei_app/app/core/helpers/input_formatter/currency_input_formatter_ptbr.dart';
import 'package:onde_gastei_app/app/core/helpers/input_formatter/date_input_formatter_ptbr.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:provider/provider.dart';

class ExpensesRegisterPage extends StatefulWidget {
  const ExpensesRegisterPage({Key? key}) : super(key: key);

  static const router = 'expenses/register';

  @override
  _ExpensesRegisterPageState createState() => _ExpensesRegisterPageState();
}

class _ExpensesRegisterPageState extends State<ExpensesRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  CategoryModel? _selectedCategory;
  TextEditingController dateController = TextEditingController(
    text: DateFormat.yMd('pt_BR').format(
      DateTime.now(),
    ),
  );

  TextEditingController valueController = TextEditingController(
    text: NumberFormat.currency(
      locale: 'pt-BR',
      symbol: r'R$',
      decimalDigits: 2,
    ).format(0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text('Despesa'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.only(top: 32.h, left: 16.w, right: 16.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  OndeGasteiTextForm(
                    label: 'Descrição',
                    prefixIcon: const Icon(Icons.list),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  OndeGasteiTextForm(
                    controller: valueController,
                    label: 'Valor',
                    prefixIcon: const Icon(Icons.attach_money),
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      // FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatterPtbr()
                    ],
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  OndeGasteiTextForm(
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
                      // FilteringTextInputFormatter.digitsOnly,
                      DateInputFormatterPtbr(),
                    ],
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Selector<CategoriesControllerImpl, List<CategoryModel>>(
                    builder: (context, categoriesList, _) {
                      return DropdownButtonFormField<CategoryModel>(
                        onChanged: (value) {
                          _selectedCategory = value;
                        },
                        value: _selectedCategory,
                        hint: const Text(
                          'Selecione a categoria',
                          style: TextStyle(
                            color: Color(0xFFC0C2D1),
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
                        items: categoriesList
                            .map(
                              (category) => DropdownMenuItem<CategoryModel>(
                                value: category,
                                child: ListTile(
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
                              ),
                            )
                            .toList(),
                      );
                    },
                    selector: (context, categoriesController) =>
                        categoriesController.categoriesList,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
