import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/exceptions/expenses_exists_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_snack_bar.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';
import 'package:onde_gastei_app/app/modules/categories/widgets/color_picker.dart';
import 'package:onde_gastei_app/app/modules/categories/widgets/icon_picker.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:provider/provider.dart';

class CategoriesRegisterPage extends StatefulWidget {
  const CategoriesRegisterPage({
    required CategoriesController categoriesController,
    CategoryModel? categoryModel,
    bool isEditing = false,
    Key? key,
  })  : _categoriesController = categoriesController,
        _categoryModel = categoryModel,
        _isEditing = isEditing,
        super(key: key);

  static const router = '/categories/register';

  final CategoriesController _categoriesController;
  final CategoryModel? _categoryModel;
  final bool _isEditing;

  @override
  State<CategoriesRegisterPage> createState() => _CategoriesRegisterPageState();
}

class _CategoriesRegisterPageState extends State<CategoriesRegisterPage> {
  late TextEditingController categoriesTextController;
  late ValueNotifier<IconData> _icon;

  late ValueNotifier<Color> _color;
  final _scaffoldMessagedKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();
  bool _edited = false;

  @override
  void dispose() {
    categoriesTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    categoriesTextController =
        TextEditingController(text: widget._categoryModel?.description);

    _icon = ValueNotifier<IconData>(
      IconData(
        widget._categoryModel?.iconCode ?? Constants.defaultIconCode,
        fontFamily: 'MaterialIcons',
      ),
    );

    _color = ValueNotifier<Color>(
      Color(widget._categoryModel?.colorCode ?? Constants.defaultColorCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesControllerState =
        context.select<CategoriesControllerImpl, CategoriesState>(
      (categoriesController) => categoriesController.state,
    );

    final categoriesControllerDeleteState =
        context.select<CategoriesControllerImpl, CategoriesDeleteState>(
      (categoriesController) => categoriesController.stateDelete,
    );

    final user = context.select<UserControllerImpl, UserModel?>(
      (userController) => userController.user,
    );

    return ScaffoldMessenger(
      key: _scaffoldMessagedKey,
      child: IgnorePointer(
        ignoring: categoriesControllerState == CategoriesState.loading,
        child: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop(_edited);
            return _edited;
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Categoria',
                // style: TextStyle(fontFamily: 'Jost'),
              ),
              leading: IconButton(
                splashRadius: 20.r,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(_edited),
              ),
              actions: [
                _buildDeleteButton(context, categoriesControllerDeleteState),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: OndeGasteiTextForm(
                          key: const Key('categories_key_register_categories'),
                          label: 'Categoria...',
                          textAlign: TextAlign.center,
                          controller: categoriesTextController,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'A categoria é obrigatório';
                            }

                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      _buildIconAndColor(),
                      SizedBox(
                        height: 40.h,
                      ),
                      _buildSaveButton(
                        context,
                        categoriesControllerState,
                        user,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Visibility _buildDeleteButton(
    BuildContext context,
    CategoriesDeleteState stateDelete,
  ) {
    return Visibility(
      visible: widget._isEditing,
      child: IconButton(
        onPressed: () async {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return AlertDialog(
                key: const Key(
                  'alert_delete_dialog_key_register_categories_page',
                ),
                title: const Text('Deletar categoria'),
                content: Text(
                  'Deseja deletar a categoria ${widget._categoryModel?.description}?',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    key: const Key(
                      'delete_button_dialog_register_categories_page',
                    ),
                    onPressed: () async {
                      // SnackBar snackBar;
                      try {
                        _edited = true;

                        await widget._categoriesController
                            .deleteCategory(widget._categoryModel?.id ?? 0);

                        if (!mounted) {
                          return;
                        }

                        if (Navigator.of(dialogContext).canPop()) {
                          Navigator.of(dialogContext).pop(_edited);
                        }

                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop(_edited);
                        }
                      } on ExpensesExistsException {
                        if (Navigator.of(dialogContext).canPop()) {
                          Navigator.of(dialogContext).pop(_edited);
                        }

                        final snackBar = OndeGasteiSnackBar.buildSnackBar(
                          key: const Key(
                            'snack_bar_fail_delete_key_register_update_categories_page_expenses_exists',
                          ),
                          content: const Text(
                              'Não foi possível deletar categoria. Existe(m) despesas registradas nessa categria.'),
                          backgroundColor: Colors.red,
                          label: 'Fechar',
                          onPressed: () {},
                        );

                        _scaffoldMessagedKey.currentState!
                            .showSnackBar(snackBar);
                      } on Failure {
                        if (Navigator.of(dialogContext).canPop()) {
                          Navigator.of(dialogContext).pop(_edited);
                        }

                        final snackBar = OndeGasteiSnackBar.buildSnackBar(
                          key: const Key(
                            'snack_bar_fail_delete_key_register_update_categories_page',
                          ),
                          content: const Text('Erro ao deletar categoria'),
                          backgroundColor: Colors.red,
                          label: 'Fechar',
                          onPressed: () {},
                        );

                        _scaffoldMessagedKey.currentState!
                            .showSnackBar(snackBar);
                      }
                    },
                    child: stateDelete == CategoriesDeleteState.loading
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
        splashRadius: 20.r,
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
          key: Key('icon_delete_key_register_categories_page'),
        ),
      ),
    );
  }

  OndeGasteiButton _buildSaveButton(
    BuildContext context,
    CategoriesState state,
    UserModel? user,
  ) {
    return OndeGasteiButton(
      Text(
        'Salvar',
        style: TextStyle(color: Colors.white, fontSize: 17.sp),
      ),
      key: const Key('save_button_register_categories_page'),
      width: MediaQuery.of(context).size.width * 0.9,
      isLoading: state == CategoriesState.loading,
      onPressed: () async {
        final formValid = _formKey.currentState?.validate() ?? false;

        if (formValid) {
          _edited = true;

          SnackBar snackBar;

          String message;

          try {
            if (!widget._isEditing) {
              final categoryModel = CategoryModel(
                description: categoriesTextController.text,
                iconCode: _icon.value.codePoint,
                colorCode: _color.value.value,
                userId: user?.userId ?? 0,
              );

              await widget._categoriesController.register(categoryModel);
              message = 'Categoria criada com sucesso!';

              _resetFields();
            } else {
              final categoryInputModel = CategoryInputModel(
                id: widget._categoryModel!.id,
                description: categoriesTextController.text,
                iconCode: _icon.value.codePoint,
                colorCode: _color.value.value,
              );

              await widget._categoriesController.updateCategory(
                widget._categoryModel?.id ?? 0,
                categoryInputModel,
              );
              message = 'Categoria atualizada com sucesso!';
            }

            if (!mounted) {
              return;
            }

            snackBar = OndeGasteiSnackBar.buildSnackBar(
              key: const Key(
                'snack_bar_success_key_register_update_categories_page',
              ),
              content: Text(message),
              backgroundColor: Theme.of(context).primaryColor,
              label: 'Fechar',
              onPressed: () {},
            );
          } on Exception {
            snackBar = OndeGasteiSnackBar.buildSnackBar(
              key: const Key(
                'snack_bar_error_key_register_update_categories_page',
              ),
              content: widget._isEditing
                  ? const Text('Erro ao atualizar categoria!')
                  : const Text('Erro ao criar categoria!'),
              backgroundColor: Colors.red,
              label: 'Fechar',
              onPressed: () {},
            );
          }

          _scaffoldMessagedKey.currentState!.showSnackBar(snackBar);
        }
      },
    );
  }

  Row _buildIconAndColor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ValueListenableBuilder<IconData>(
          valueListenable: _icon,
          builder: (context, iconData, _) {
            return GestureDetector(
              key: const Key('gesture_icon_key_register_categories_page'),
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: _buildDialogIcons,
                );
              },
              child: ValueListenableBuilder<Color>(
                valueListenable: _color,
                builder: (context, color, _) =>
                    _buildIcon(icon: iconData, color: color),
              ),
            );
          },
        ),
        SizedBox(
          width: 50.w,
        ),
        ValueListenableBuilder<Color>(
          valueListenable: _color,
          builder: (context, color, _) {
            return GestureDetector(
              key: const Key('gesture_color_key_register_categories_page'),
              onTap: () {
                showDialog<void>(context: context, builder: _buildDialogColor);
              },
              child: _buildColor(color: color),
            );
          },
        ),
      ],
    );
  }

  Column _buildIcon({
    IconData icon =
        const IconData(Constants.defaultIconCode, fontFamily: 'MaterialIcons'),
    Color color = Colors.grey,
  }) {
    return Column(
      children: [
        Container(
          key: const Key('build_icon_key_register_categories_page'),
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.all(Radius.circular(100.r)),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const Text('Ícone'),
      ],
    );
  }

  Column _buildColor({
    Color color = Colors.grey,
  }) {
    return Column(
      children: [
        Container(
          key: const Key('build_color_key_register_categories_page'),
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.all(Radius.circular(100.r)),
          ),
        ),
        const Text('Cor'),
      ],
    );
  }

  Dialog _buildDialogIcons(BuildContext context) {
    const icons = IconPicker.icons;

    return Dialog(
      child: SizedBox(
        height: 450.h,
        child: GridView.builder(
          itemCount: icons.length,
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 4
                    : 10,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              key: Key('inkwell_icons_key_${index}_register_categories_page'),
              onTap: () {
                _icon.value = icons[index];
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(50),
              child: Icon(
                icons[index],
                color: Colors.grey,
                size: 30,
              ),
            );
          },
        ),
      ),
    );
  }

  Dialog _buildDialogColor(BuildContext context) {
    const colors = ColorPicker.colors;

    return Dialog(
      key: const Key('color_dialog_key_register_categories_page'),
      child: SizedBox(
        height: 450.h,
        child: GridView.builder(
          itemCount: colors.length,
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 4
                    : 10,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final color = colors[index];

            return InkWell(
              key: Key('inkwell_color_key_${index}_register_categories_page'),
              onTap: () {
                _color.value = color;
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(50),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _resetFields() {
    categoriesTextController.clear();

    _icon = ValueNotifier<IconData>(
      const IconData(Constants.defaultIconCode, fontFamily: 'MaterialIcons'),
    );

    _color = ValueNotifier<Color>(
      const Color(Constants.defaultColorCode),
    );
  }
}
