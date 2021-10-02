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

class IdentificationDocument extends StatefulWidget {
  @override
  _IdentificationDocumentState createState() => _IdentificationDocumentState();
}

class _IdentificationDocumentState extends State<IdentificationDocument> {
  final df = DateFormat("yyyy-MM-dd");
  DateTime? _dateTime;
  TextEditingController _numberID = TextEditingController();
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String? frontKey;
  String? backKey;
  ValueNotifier<bool> _frontLoading = ValueNotifier<bool>(false);
  ValueNotifier<bool> _backLoading = ValueNotifier<bool>(false);
  bool showRequired = false;

  @override
  void initState() {
    final register = context.read(registerProvider);
    _numberID.text = register.docNumber ?? "";
    _dateTime = register.expeditionDate;
    frontKey = register.docFront;
    backKey = register.docBack;
    super.initState();
  }

  @override
  void dispose() {
    _numberID.dispose();
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
            DomiSliverAppBar("Documento de identificación"),
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
                        hintText: "Número de documento",
                        radius: 9,
                        maxLength: 10,
                        width: double.maxFinite,
                        controller: _numberID,
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
                        text: _dateTime == null
                            ? "Fecha de expedición"
                            : "${df.format(_dateTime!)}",
                        voidCallback: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: _dateTime ?? DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now())
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                _dateTime = value;
                              });
                            }
                          });
                        },
                        elevate: 0,
                      ),
                      if (_dateTime == null && showRequired)
                        messageErrorWidget(REQUIRED_MESSAGE),
                      SizedBox(
                        height: 14,
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: _frontLoading,
                          builder: (context, value, child) {
                            return ButtonUploadPhoto(
                              title: "Documento de ID",
                              subTitle: "(Subir foto de frente)",
                              onImageSelected: (value) async {
                                try {
                                  _frontLoading.value = true;
                                  frontKey = await context
                                      .read(registerProvider.notifier)
                                      .uploadImageFromPathRegister(value);
                                } catch (e) {
                                  showError(context, e);
                                }
                                _frontLoading.value = false;
                              },
                              valid: frontKey != null,
                              loading: value,
                            );
                          }),
                      if (frontKey == null && showRequired)
                        messageErrorWidget(REQUIRED_MESSAGE),
                      SizedBox(
                        height: 14,
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: _backLoading,
                          builder: (context, value, child) {
                            return ButtonUploadPhoto(
                              title: "Documento de ID",
                              subTitle: "(Subir foto de trasera)",
                              onImageSelected: (value) async {
                                try {
                                  _backLoading.value = true;
                                  backKey = await context
                                      .read(registerProvider.notifier)
                                      .uploadImageFromPathRegister(value);
                                } catch (e) {
                                  showError(context, e);
                                }
                                _backLoading.value = false;
                              },
                              valid: backKey != null,
                              loading: value,
                            );
                          }),
                      if (backKey == null && showRequired)
                        messageErrorWidget(REQUIRED_MESSAGE),
                      SizedBox(
                        height: 14,
                      ),
                      DomiContinueButton(
                        voidCallback: _saveInfo,
                      ),
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
        frontKey == null ||
        backKey == null ||
        _dateTime == null) {
      setState(() {
        showRequired = true;
      });
      return;
    }

    context
        .read(registerProvider.notifier)
        .setIdentificationData(_numberID.text, _dateTime!, frontKey!, backKey!);
    Navigator.of(context).pop(1);
  }
}
