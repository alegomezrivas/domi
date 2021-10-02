import 'package:domi/main.dart';
import 'package:domi/re_use/button_domi_form.dart';
import 'package:domi/re_use/button_upload_photo.dart';
import 'package:domi/re_use/domi_button_continue.dart';
import 'package:domi/re_use/indomi_text_form_field.dart';
import 'package:domi/re_use/message_strings.dart';
import 'package:domi/re_use/register/need_help_widget.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DriverLicense extends StatefulWidget {
  @override
  _DriverLicenseState createState() => _DriverLicenseState();
}

class _DriverLicenseState extends State<DriverLicense> {
  final df = DateFormat("yyyy-MM-dd");
  DateTime? expireDate;
  TextEditingController _license = TextEditingController();
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  ValueNotifier<bool> _frontLoading = ValueNotifier<bool>(false);
  ValueNotifier<bool> _backLoading = ValueNotifier<bool>(false);
  String? frontLicKey;
  String? backLicKey;
  bool showRequired = false;
  DateTime now = DateTime.now();

  @override
  void initState() {
    final register = context.read(registerProvider);
    _license.text = register.numberLicense ?? "";
    expireDate = register.expireDateLicense;
    frontLicKey = register.licFront;
    backLicKey = register.licBack;
    super.initState();
  }

  @override
  void dispose() {
    _license.dispose();
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
            DomiSliverAppBar("Licencia de coducción"),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      IndomiTextFormField(
                        hintText: "Número de licencia de conducción",
                        radius: 9,
                        maxLength: 15,
                        width: double.maxFinite,
                        controller: _license,
                        edgeInsetsGeometry: EdgeInsets.only(left: 16),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return REQUIRED_MESSAGE;
                          }
                        },
                        formatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      ButtonDomiForm(
                        text: expireDate == null
                            ? "Fecha de vencimiento"
                            : "${df.format(expireDate!)}",
                        voidCallback: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: expireDate ??
                                      DateTime(now.year, now.month, now.day),
                                  firstDate:
                                      DateTime(now.year, now.month, now.day),
                                  lastDate: DateTime(
                                      now.year + 10, now.month, now.day))
                              .then((value) {
                            setState(() {
                              if (value != null) {
                                setState(() {
                                  expireDate = value;
                                });
                              }
                            });
                          });
                        },
                        elevate: 0,
                      ),
                      if (expireDate == null && showRequired)
                        messageErrorWidget(REQUIRED_MESSAGE),
                      SizedBox(
                        height: 14,
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: _frontLoading,
                          builder: (context, value, child) {
                            return ButtonUploadPhoto(
                              title: "Licencia de conducir",
                              subTitle: "(Subir foto de frente)",
                              onImageSelected: (value) async {
                                try {
                                  _frontLoading.value = true;
                                  frontLicKey = await context
                                      .read(registerProvider.notifier)
                                      .uploadImageFromPathRegister(value);
                                } catch (e) {
                                  showError(context, e);
                                }
                                _frontLoading.value = false;
                              },
                              valid: frontLicKey != null,
                              loading: value,
                            );
                          }),
                      if (frontLicKey == null && showRequired)
                        messageErrorWidget(REQUIRED_MESSAGE),
                      SizedBox(
                        height: 14,
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: _backLoading,
                          builder: (context, value, child) {
                            return ButtonUploadPhoto(
                              title: "Licencia de conducir",
                              subTitle: "(Subir foto de trasera)",
                              onImageSelected: (value) async {
                                try {
                                  _backLoading.value = true;
                                  backLicKey = await context
                                      .read(registerProvider.notifier)
                                      .uploadImageFromPathRegister(value);
                                  _backLoading.value = false;
                                } catch (e) {
                                  showError(context, e);
                                }
                              },
                              valid: frontLicKey != null,
                              loading: value,
                            );
                          }),
                      if (backLicKey == null && showRequired)
                        messageErrorWidget(REQUIRED_MESSAGE),
                      SizedBox(
                        height: 14,
                      ),
                      DomiContinueButton(voidCallback: _saveInfo),
                      SizedBox(
                        height: 210,
                      ),
                      NeedHelpWidget(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future<void> _saveInfo() async {
    if (!_formState.currentState!.validate() ||
        frontLicKey == null ||
        backLicKey == null ||
        expireDate == null) {
      setState(() {
        showRequired = true;
      });
      return;
    }
    context.read(registerProvider.notifier).setLicenseDriver(
        _license.text, expireDate!, frontLicKey!, backLicKey!);
    Navigator.of(context).pop(1);
  }
}
