import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/brand.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/brand_details.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_dialog.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_slidebar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_snackbar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:flutter/material.dart';

class BrandActions {
  static Future deleteBrand({
    required BuildContext context,
    required Brand brand,
  }) {
    BrandDetails brandDetails = BrandDetails();

    return CosmeticDialog.showAlertDialog(
      context: context,
      dialogTittle: 'Excluir Marca',
      dialogDescription: 'Tem certeza que deseja excluir este registro?',
      onPressed: () => {
        brandDetails.deleteBrandDetails(
          id: brand.id,
        ),
        Navigator.pop(context),
        ScaffoldMessenger.of(context).showSnackBar(
          CosmeticSnackBar.showSnackBar(
            context: context,
            message: 'Marca excluída.',
            backgroundColor: Colors.red,
          ),
        ),
      },
    );
  }

  static Future<Widget?> updateBrand({
    required BuildContext context,
    required Brand brand,
    required GlobalKey<FormState> formKey,
  }) {
    BrandDetails brandDetails = BrandDetails();

    return showModalBottomSheet<Widget>(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.only(
          top: 4.0,
          left: cosmeticDefaultSize,
          right: cosmeticDefaultSize,
          bottom: cosmeticDefaultSize,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CosmeticSlideBar(),
                  Text(
                    'Atualizar Marca',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Para atualizar as informações preencha os campos à baixo e clique em "ATUALIZAR".',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: cosmeticFormHeight - 20),
                  CosmeticTextFormField(
                    initialValue: brand.name,
                    textInputAction: TextInputAction.next,
                    borderRadius: 10,
                    keyboardType: TextInputType.name,
                    inputText: 'Nome',
                    icon: const Icon(
                      Icons.drive_file_rename_outline,
                      color: cosmeticSecondaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o Nome!';
                      } else {
                        brand.name = value;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: cosmeticFormHeight - 10),
                  SizedBox(
                    width: double.infinity,
                    child: CosmeticElevatedButton(
                      onPressed: () => {
                        if (formKey.currentState!.validate())
                          {
                            brandDetails.updateBrandDetails(
                              id: brand.id,
                              name: brand.name,
                            ),
                            brand.name = '',
                            Navigator.pop(context),
                            ScaffoldMessenger.of(context).showSnackBar(
                              CosmeticSnackBar.showSnackBar(
                                context: context,
                                message: 'Marca atualizada.',
                              ),
                            ),
                          },
                      },
                      buttonName: 'ATUALIZAR',
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
