import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_snack_bar.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';
import 'package:onde_gastei_app/app/modules/categories/widgets/color_picker.dart';
import 'package:onde_gastei_app/app/modules/categories/widgets/icon_picker.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class RegisterCategoriesPage extends StatefulWidget {
  const RegisterCategoriesPage({
    required this.categoriesController,
    this.categoryModel,
    this.isEditing = false,
    Key? key,
  }) : super(key: key);

  static const router = '/register-categories';

  final CategoriesController categoriesController;
  final CategoryModel? categoryModel;
  final bool isEditing;

  @override
  State<RegisterCategoriesPage> createState() => _RegisterCategoriesPageState();
}

class _RegisterCategoriesPageState extends State<RegisterCategoriesPage> {
  TextEditingController? categoriesTextController;
  late ValueNotifier<IconData> _icon;

  late ValueNotifier<Color> _color;
  final _scaffoldMessagedKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    categoriesTextController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    categoriesTextController =
        TextEditingController(text: widget.categoryModel?.description);

    _icon = ValueNotifier<IconData>(
      IconData(widget.categoryModel?.iconCode ?? 0xe332,
          fontFamily: 'MaterialIcons'),
    );

    _color = ValueNotifier<Color>(
      Color(widget.categoryModel?.colorCode ?? 0xFF9E9E9E),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select<CategoriesControllerImpl, categoriesState>(
        (categoriesController) => categoriesController.state);

    return SafeArea(
      child: ScaffoldMessenger(
        key: _scaffoldMessagedKey,
        child: IgnorePointer(
          ignoring: state == categoriesState.loading,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  splashRadius: 20,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop()),
              actions: [
                _buildDeleteButton(context),
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
                        child: OndeGasteiTextForm(
                          key: const Key('categories_key_register_categories'),
                          label: 'Categoria...',
                          textAlign: TextAlign.center,
                          controller: categoriesTextController,
                          validator: Validatorless.required(
                              'A categoria é obrigatório'),
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      _buildIconAndColor(),
                      SizedBox(
                        height: 40.h,
                      ),
                      _buidlSaveButton(state, context)
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

  Visibility _buildDeleteButton(BuildContext registerPageContext) {
    return Visibility(
      visible: widget.isEditing,
      child: IconButton(
        onPressed: () async {
          await showDialog<void>(
            context: registerPageContext,
            barrierDismissible: false,
            builder: (dialogContext) {
              return Consumer<CategoriesControllerImpl>(
                builder:
                    (categoriesControllerContext, categoreisController, _) {
                  return AlertDialog(
                    title: const Text('Deletar categoria'),
                    content: Text(
                        'Deseja deletar a categoria ${widget.categoryModel?.description}?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // SnackBar snackBar;
                          try {
                            await categoreisController
                                .deleteCategory(widget.categoryModel?.id ?? 0);

                            // if (Navigator.of(context).canPop()) {
                            //   Navigator.of(context).pop();
                            // }

                            if (Navigator.of(dialogContext).canPop()) {
                              Navigator.of(dialogContext).pop();
                            }

                            if (Navigator.of(registerPageContext).canPop()) {
                              Navigator.of(registerPageContext).pop();
                            }

                            // snackBar = OndeGasteiSnackBar.buildSnackBar(
                            //   key: const Key(
                            //       'snack_bar_success_delete_key_register_update_categories_page'),
                            //   content:
                            //       const Text('Categoria deletada com sucesso!'),
                            //   backgroundColor: Theme.of(context).primaryColor,
                            //   label: 'Fechar',
                            //   onPressed: () {},
                            // );
                          } on Exception {
                            final snackBar = OndeGasteiSnackBar.buildSnackBar(
                              key: const Key(
                                  'snack_bar_fail_delete_key_register_update_categories_page'),
                              content: const Text('Erro ao deletar'),
                              backgroundColor: Colors.red,
                              label: 'Fechar',
                              onPressed: () {},
                            );

                            _scaffoldMessagedKey.currentState!
                                .showSnackBar(snackBar);
                          }
                        },
                        child: categoreisController.stateDelete ==
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
          );
        },
        splashRadius: 25.r,
        icon: const Icon(
          Icons.delete_sharp,
          color: Colors.red,
        ),
      ),
    );
  }

  OndeGasteiButton _buidlSaveButton(
      categoriesState state, BuildContext context) {
    return OndeGasteiButton(
      Text(
        'Salvar',
        style: TextStyle(color: Colors.white, fontSize: 17.sp),
      ),
      key: const Key('button_save_register_update_categories_page'),
      isLoading: state == categoriesState.loading,
      onPressed: () async {
        SnackBar snackBar;
        String message;

        try {
          if (!widget.isEditing) {
            final categoryModel = CategoryModel(
              description: categoriesTextController!.text,
              iconCode: _icon.value.codePoint,
              colorCode: _color.value.value,
              userId: userModel?.userId,
            );

            await widget.categoriesController.register(categoryModel);
            message = 'Categoria criada com sucesso!';

            _resetFields();
          } else {
            final categoryInputModel = CategoryInputModel(
              id: widget.categoryModel!.id,
              description: categoriesTextController!.text,
              iconCode: _icon.value.codePoint,
              colorCode: _color.value.value,
            );

            await widget.categoriesController.updateCategory(
              widget.categoryModel?.id ?? 0,
              categoryInputModel,
            );
            message = 'Categoria atualizada com sucesso!';
          }

          snackBar = OndeGasteiSnackBar.buildSnackBar(
            key: const Key(
                'snack_bar_success_key_register_update_categories_page'),
            content: RichText(
              key: const Key('message_key_register_update_categories_page'),
              text: TextSpan(
                children: [
                  TextSpan(
                    text: message,
                  ),
                ],
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Fechar',
            onPressed: () {},
          );
        } on Exception {
          snackBar = OndeGasteiSnackBar.buildSnackBar(
            key: const Key(
                'snack_bar_error_key_register_update_categories_page'),
            content: RichText(
              key: const Key(
                  'message_error_key_register_update_categories_page'),
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Erro ao criar categoria!',
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.red,
            label: 'Fechar',
            onPressed: () {},
          );
        }

        _scaffoldMessagedKey.currentState!.showSnackBar(snackBar);
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
              onTap: () {
                showDialog<void>(context: context, builder: _buildDialogsColor);
              },
              child: _buildColor(color: color),
            );
          },
        ),
      ],
    );
  }

  Widget _buildIcon({
    IconData icon = const IconData(0xe332, fontFamily: 'MaterialIcons'),
    Color color = Colors.grey,
  }) {
    return Column(
      children: [
        Container(
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

  Widget _buildColor({
    Color color = Colors.grey,
  }) {
    return Column(
      children: [
        Container(
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

  Widget _buildDialogIcons(BuildContext context) {
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

  Widget _buildDialogsColor(BuildContext context) {
    const colors = ColorPicker.colors;

    return Dialog(
      child: SizedBox(
        height: 450.h,
        child: GridView(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 4
                      : 10,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            children: colors.map((color) {
              return InkWell(
                onTap: () {
                  _color.value = color;
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              );
            }).toList()),
      ),
    );
  }

  void _resetFields() {
    categoriesTextController?.clear();

    _icon = ValueNotifier<IconData>(
      const IconData(0xe332, fontFamily: 'MaterialIcons'),
    );

    _color = ValueNotifier<Color>(
      const Color(0xFF9E9E9E),
    );
  }
}
