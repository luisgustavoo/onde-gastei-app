import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/widgets/color_picker.dart';
import 'package:onde_gastei_app/app/modules/categories/widgets/icon_picker.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class RegisterUpdateCategoriesPage extends StatefulWidget {
  const RegisterUpdateCategoriesPage(
      {required this.categoriesController, Key? key})
      : super(key: key);

  static const router = '/register-categories';

  final CategoriesController categoriesController;

  @override
  State<RegisterUpdateCategoriesPage> createState() =>
      _RegisterUpdateCategoriesPageState();
}

class _RegisterUpdateCategoriesPageState
    extends State<RegisterUpdateCategoriesPage> {
  final categoriesTextController = TextEditingController();
  final _icon = ValueNotifier<IconData>(
    const IconData(0xe332, fontFamily: 'MaterialIcons'),
  );

  final _color = ValueNotifier<Color>(
    Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    final state = context.select<CategoriesControllerImpl, categoriesState>(
        (categoriesController) => categoriesController.state);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.close),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  child: OndeGasteiTextForm(
                    key: const Key('categories_key_register_categories'),
                    label: 'Categoria...',
                    textAlign: TextAlign.center,
                    controller: categoriesTextController,
                    validator:
                        Validatorless.required('A categoria é obrigatório'),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Row(
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
                            showDialog<void>(
                                context: context, builder: _buildDialogsColor);
                          },
                          child: _buildColor(color: color),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.h,
                ),
                OndeGasteiButton(
                  Text(
                    'Salvar',
                    style: TextStyle(color: Colors.white, fontSize: 17.sp),
                  ),
                  key: const Key('button_save_register_update_categories_page'),
                  isLoading: state == categoriesState.loading,
                )
              ],
            ),
          ),
        ),
      ),
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
}
