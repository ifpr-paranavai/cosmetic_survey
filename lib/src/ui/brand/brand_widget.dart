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

var suggestions = <Brand>[];
var aux = <Brand>[];

class _CustomerWidgetState extends State<BrandWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  BrandDetails brandDetails = BrandDetails();
  String name = '';

  @override
  Widget build(BuildContext pageContext) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(),
        body: StreamBuilder<List<Brand>>(
          stream: brandDetails.readBrandDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Ocorreu um erro ao listar registros...',
                ),
              );
            } else if (snapshot.hasData) {
              final brands = snapshot.data!;
              aux.clear();

              if (brands.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum registro encontrado!',
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    var currentBrand = brands[index];

                    Brand brand = Brand(
                      id: currentBrand.id,
                      name: currentBrand.name,
                      creationTime: currentBrand.creationTime,
                    );

                    aux.add(brand);

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
              }
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
                            'Para realizar o cadastro preencha os campos abaixo e clique em "SALVAR".',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: cosmeticFormHeight - 20),
                          CosmeticTextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            borderRadius: 10,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            inputText: 'Nome',
                            readOnly: false,
                            maxLengh: 55,
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
                                    brandDetails.addBrandDetails(
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

  AppBar buildAppBar() {
    return AppBar(
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
      actions: [
        IconButton(
          onPressed: () {
            suggestions.addAll(aux);

            showSearch(
              context: context,
              delegate: CosmeticSearchDelegate(),
            );
          },
          icon: const Icon(
            Icons.search,
          ),
        ),
      ],
    );
  }
}

class CosmeticSearchDelegate extends SearchDelegate {
  var searchResults = suggestions;

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          suggestions.clear();

          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              suggestions.clear();

              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
      ];

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Text(
          'Ops... Parece que algo inesperado aconteceu.\nTente novamente...'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = searchResults.where((searchResult) {
      final result = searchResult.name.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        Brand brand = Brand(
          id: suggestion.id,
          name: suggestion.name,
          creationTime: suggestion.creationTime,
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
  }
}
