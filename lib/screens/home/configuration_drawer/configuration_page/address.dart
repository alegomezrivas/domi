import 'package:domi/main.dart';
import 'package:domi/provider/config/address_provider.dart';
import 'package:domi/re_use/domi_button_continue.dart';
import 'package:domi/re_use/geo_widgets/domi_search_autocomplete.dart';
import 'package:domi/re_use/indomi_text_form_field.dart';
import 'package:domi/re_use/message_strings.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController _address = TextEditingController();
  TextEditingController _name = TextEditingController();
  Map<String, dynamic>? _addressData;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read(addressProvider.notifier).getAddressBook();
    });
  }

  @override
  void dispose() {
    _address.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: inDomiScaffoldGrey,
      body: CustomScrollView(
        slivers: [
          DomiSliverAppBar("Lugares favoritos"),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Agregar dirección",
                      style: TextStyle(
                          color: inDomiBluePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    InkWell(
                      onTap: () {
                        showPredictions();
                      },
                      child: IgnorePointer(
                        child: IndomiTextFormField(
                          hintText: "Dirección",
                          radius: 9,
                          maxLength: 50,
                          controller: _address,
                          width: double.maxFinite,
                          edgeInsetsGeometry: EdgeInsets.only(left: 16),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return REQUIRED_MESSAGE;
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    IndomiTextFormField(
                      hintText: "Descripción",
                      radius: 9,
                      maxLength: 50,
                      controller: _name,
                      width: double.maxFinite,
                      edgeInsetsGeometry: EdgeInsets.only(left: 16),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return REQUIRED_MESSAGE;
                        }
                      },
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    DomiContinueButton(
                      height: 38,
                      width: double.maxFinite,
                      voidCallback: _saveAddress,
                      text: "Agregar",
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, right: 8, left: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mis direcciones",
                    style: TextStyle(
                        color: inDomiBluePrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.black26,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Consumer(builder: (context, watch, child) {
            final data = watch(addressProvider).results;
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "${data[index].name}, ${data[index].address}",
                          style: TextStyle(color: inDomiGreyBlack, fontSize: 14),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          context
                              .read(addressProvider.notifier)
                              .deleteAddress(data[index].id!);
                        },
                      )
                    ],
                  );
                }, childCount: data.length),
              ),
            );
          })
        ],
      ),
    );
  }

  showPredictions() {
    final media = MediaQuery.of(context).size;
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      builder: (context) {
        return Container(
          height: media.height * 0.8,
          child: IndomiSearchAutocomplete(
            hintText: "Escribe la dirección",
            country: context
                .read(authProvider)
                .userData!
                .user
                .person
                .city
                .countryName,
            onSelectAnPlace: (value) {
              _address.text = value["name"] ?? "";
              _addressData = value;
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await context.read(addressProvider.notifier).createAddress(
          _addressData!["geometry"]["location"]["lat"],
          _addressData!["geometry"]["location"]["lng"],
          _name.text,
          _address.text);
      _addressData = null;
      _address.clear();
      _name.clear();
    } catch (e) {
      showError(context, e);
    }
  }
}
