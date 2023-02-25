import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/brand.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/brand_details.dart';
import 'package:cosmetic_survey/src/ui/brand/brand_card.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_circular_indicator.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_floating_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_slidebar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_snackbar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'brand_actions.dart';

class BrandWidget extends StatefulWidget {
  const BrandWidget({Key? key}) : super(key: key);

  @override
  State<BrandWidget> createState() => _CustomerWidgetState();
}

class _CustomerWidgetState extends State<BrandWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String name = '';

  @override
  Widget build(BuildContext pageContext) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Marcas',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cosmeticSecondaryColor,
              fontSize: 25,
            ),
          ),
        ),
        body: StreamBuilder<List<Brand>>(
          stream: BrandDetails.readBrandDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Ocorreu um erro ao listar registros...',
                ),
              );
            } else if (snapshot.hasData) {
              final brands = snapshot.data!;

              return ListView.builder(
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  var currentBrand = brands[index];

                  Brand brand = Brand(
                    id: currentBrand.id,
                    name: currentBrand.name,
                  );

                  return BrandCard(
                    brand: brand,
                    onPressedDelete: () {
                      HapticFeedback.vibrate();

                      BrandActions.deleteBrand(
                        context: context,
                        brand: brand,
                      );
                    },
                  );
                },
              );
            } else {
              return const CosmeticCircularIndicator();
            }
          },
        ),
        floatingActionButton: CosmeticFloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
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
                  key: _formKey,
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
                            'Cadastro de Marca',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'Para realizar o cadastro preencha os campos à baixo e clique em "SALVAR".',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: cosmeticFormHeight - 20),
                          CosmeticTextFormField(
                            controller: _nameController,
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
                                name = value;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: cosmeticFormHeight - 10),
                          SizedBox(
                            width: double.infinity,
                            child: CosmeticElevatedButton(
                              onPressed: () => {
                                if (_formKey.currentState!.validate())
                                  {
                                    BrandDetails.addBrandDetails(
                                      name: _nameController.text,
                                    ),
                                    _nameController.clear(),
                                    Navigator.pop(context),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CosmeticSnackBar.showSnackBar(
                                        context: context,
                                        message: 'Marca criada.',
                                      ),
                                    ),
                                  },
                              },
                              buttonName: 'SALVAR',
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          icon: Icons.add,
        ),
      ),
    );
  }
}
