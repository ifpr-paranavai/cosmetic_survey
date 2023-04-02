import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:cosmetic_survey/src/core/constants/sizes.dart';
import 'package:cosmetic_survey/src/core/entity/product.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/brand_details.dart';
import 'package:cosmetic_survey/src/core/firebase/firestore/product_details.dart';
import 'package:cosmetic_survey/src/ui/brand/cosmetic_brand_dropdown.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_circular_indicator.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_dialog.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_elevated_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_floating_button.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_slidebar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_snackbar.dart';
import 'package:cosmetic_survey/src/ui/components/cosmetic_text_form_field.dart';
import 'package:cosmetic_survey/src/ui/product/product_actions.dart';
import 'package:cosmetic_survey/src/ui/product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({Key? key}) : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _valueController = MoneyMaskedTextController();
  final _dropdownController = TextEditingController();

  BrandDetails brandDetails = BrandDetails();
  ProductDetails productDetails = ProductDetails();

  String name = '';
  int code = 0;
  double price = 0;

  @override
  Widget build(BuildContext context) {
    var brands = brandDetails.searchAndConvertBrands();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Produtos',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cosmeticSecondaryColor,
              fontSize: 25,
            ),
          ),
        ),
        body: StreamBuilder<List<Product>>(
          stream: productDetails.readProductDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Ocorreu um erro ao listar registros...',
                ),
              );
            } else if (snapshot.hasData) {
              final products = snapshot.data!;

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var currentProduct = products[index];

                  Product product = Product(
                    id: currentProduct.id,
                    name: currentProduct.name,
                    price: currentProduct.price,
                    code: currentProduct.code,
                    brandId: currentProduct.brandId,
                    creationTime: currentProduct.creationTime,
                  );

                  return ProductCard(
                    product: product,
                    brands: brands,
                    onPressedDelete: () {
                      HapticFeedback.vibrate();

                      ProductActions.deleteProduct(
                        context: context,
                        product: product,
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
            if (brands.isEmpty) {
              CosmeticDialog.showAlertDialog(
                context: context,
                dialogTittle: 'Informação!',
                dialogDescription:
                    'Cadastre uma Marca antes de cadastrar um Produto!',
                onPressed: () {
                  Navigator.pop(context);
                },
                showCancelButton: false,
              );
            } else {
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
                              'Cadastro de Produto',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Text(
                              'Para realizar o cadastro preencha os campos à baixo e clique em "SALVAR".',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const SizedBox(height: cosmeticFormHeight - 20),
                            CosmeticTextFormField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              borderRadius: 10,
                              keyboardType: TextInputType.name,
                              inputText: 'Nome',
                              maxLengh: 55,
                              readOnly: false,
                              icon: const Icon(
                                Icons.edit,
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
                            const SizedBox(height: cosmeticFormHeight - 20),
                            CosmeticTextFormField(
                              controller: _valueController,
                              textInputAction: TextInputAction.next,
                              borderRadius: 10,
                              keyboardType: TextInputType.number,
                              inputText: 'Valor',
                              readOnly: false,
                              icon: const Icon(
                                Icons.attach_money,
                                color: cosmeticSecondaryColor,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe o Valor!';
                                } else {
                                  price = double.parse(value
                                      .toString()
                                      .replaceAll(',', '')
                                      .replaceAll('.', ''));
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: cosmeticFormHeight - 20),
                            CosmeticTextFormField(
                              controller: _codeController,
                              textInputAction: TextInputAction.next,
                              borderRadius: 10,
                              keyboardType: TextInputType.number,
                              readOnly: false,
                              inputText: 'Código',
                              icon: const Icon(
                                Icons.qr_code_2,
                                color: cosmeticSecondaryColor,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe o Código!';
                                } else {
                                  code = int.parse(value);
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: cosmeticFormHeight - 20),
                            const SizedBox(height: cosmeticFormHeight - 20),
                            CosmeticBrandDropdown(
                              brands: brands,
                              validator: (value) {
                                if (value == null) {
                                  return 'Selecione uma opção!';
                                }
                                return null;
                              },
                              onBrandChanged: (value) {
                                _dropdownController.text = value.id;
                              },
                            ),
                            const SizedBox(height: cosmeticFormHeight - 10),
                            SizedBox(
                              width: double.infinity,
                              child: CosmeticElevatedButton(
                                onPressed: () => {
                                  if (_formKey.currentState!.validate())
                                    {
                                      productDetails.addProductDetails(
                                        product: Product(
                                          name: name,
                                          price: price,
                                          code: code,
                                          brandId: _dropdownController.text,
                                        ),
                                      ),
                                      _nameController.clear(),
                                      _codeController.clear(),
                                      _valueController.clear(),
                                      _dropdownController.clear(),
                                      Navigator.pop(context),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        CosmeticSnackBar.showSnackBar(
                                          context: context,
                                          message: 'Produto criado.',
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
            }
          },
          icon: Icons.add,
        ),
      ),
    );
  }
}
