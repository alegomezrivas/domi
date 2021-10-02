import 'package:domi/main.dart';
import 'package:domi/re_use/button_upload_photo.dart';
import 'package:domi/re_use/domi_button_continue.dart';
import 'package:domi/re_use/message_strings.dart';
import 'package:domi/re_use/register/need_help_widget.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertyCard extends StatefulWidget {
  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  ValueNotifier<bool> _frontLoading = ValueNotifier<bool>(false);
  ValueNotifier<bool> _backLoading = ValueNotifier<bool>(false);
  String? frontProperty;
  String? backProperty;
  bool showRequired = false;
  DateTime now = DateTime.now();

  @override
  void initState() {
    final register = context.read(registerProvider);
    frontProperty = register.propCardFront;
    backProperty = register.propCardBack;
    super.initState();
  }

  @override
  void dispose() {
    _frontLoading.dispose();
    _backLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        body: CustomScrollView(
          slivers: [
            DomiSliverAppBar("Tarjeta de propiedad"),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: _frontLoading,
                        builder: (context, value, child) {
                          return ButtonUploadPhoto(
                            title: "Tarjeta de propiedad",
                            subTitle: "(Subir foto de frente)",
                            onImageSelected: (value) async {
                              try {
                                _frontLoading.value = true;
                                frontProperty = await context
                                    .read(registerProvider.notifier)
                                    .uploadImageFromPathRegister(value);
                              } catch (e) {
                                showError(context, e);
                              }
                              _frontLoading.value = false;
                            },
                            valid: frontProperty != null,
                            loading: value,
                          );
                        }),
                    if (frontProperty == null && showRequired)
                      messageErrorWidget(REQUIRED_MESSAGE),
                    SizedBox(
                      height: 14,
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: _backLoading,
                        builder: (context, value, child) {
                          return ButtonUploadPhoto(
                            title: "Tarjeta de propiedad",
                            subTitle: "(Subir foto de trasera)",
                            onImageSelected: (value) async {
                              try {
                                _backLoading.value = true;
                                backProperty = await context
                                    .read(registerProvider.notifier)
                                    .uploadImageFromPathRegister(value);
                              } catch (e) {
                                showError(context, e);
                              }
                              _backLoading.value = false;
                            },
                            valid: backProperty != null,
                            loading: value,
                          );
                        }),
                    if (backProperty == null && showRequired)
                      messageErrorWidget(REQUIRED_MESSAGE),
                    SizedBox(
                      height: 14,
                    ),
                    DomiContinueButton(
                      voidCallback: _saveInfo,
                    ),
                    SizedBox(
                      height: 300,
                    ),
                    NeedHelpWidget(),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future<void> _saveInfo() async {
    if (frontProperty == null || backProperty == null) {
      setState(() {
        showRequired = true;
      });
      return;
    }
    context
        .read(registerProvider.notifier)
        .setPropertyCard(frontProperty!, backProperty!);
    Navigator.of(context).pop(1);
  }
}
