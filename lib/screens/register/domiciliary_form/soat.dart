import 'package:domi/main.dart';
import 'package:domi/re_use/button_domi_form.dart';
import 'package:domi/re_use/button_upload_photo.dart';
import 'package:domi/re_use/domi_button_continue.dart';
import 'package:domi/re_use/message_strings.dart';
import 'package:domi/re_use/register/need_help_widget.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Soat extends StatefulWidget {
  @override
  _SoatState createState() => _SoatState();
}

class _SoatState extends State<Soat> {
  final df = DateFormat("yyyy-MM-dd");
  DateTime? _dateTimeExpedition;
  DateTime? _dateTimeExpiration;
  String? soatPhoto;
  ValueNotifier<bool> _soatPhotoLoading = ValueNotifier<bool>(false);
  bool showRequired = false;

  @override
  void initState() {
    final register = context.read(registerProvider);
    _dateTimeExpiration = register.expireSoat;
    _dateTimeExpedition = register.expeditionSoat;
    soatPhoto = register.soatFront;
    super.initState();
  }

  @override
  void dispose() {
    _soatPhotoLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        body: CustomScrollView(
          slivers: [
            DomiSliverAppBar("SOAT"),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    ButtonDomiForm(
                      text: _dateTimeExpedition == null
                          ? "Fecha de expedición"
                          : df.format(_dateTimeExpedition!),
                      voidCallback: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 365)),
                                lastDate: DateTime.now())
                            .then((value) {
                          setState(() {
                            _dateTimeExpedition = value;
                          });
                        });
                      },
                      elevate: 0,
                    ),
                    if (_dateTimeExpedition == null && showRequired)
                      messageErrorWidget(REQUIRED_MESSAGE),
                    SizedBox(
                      height: 14,
                    ),
                    ButtonDomiForm(
                      text: _dateTimeExpiration == null
                          ? "Fecha de vencimiento"
                          : df.format(_dateTimeExpiration!),
                      voidCallback: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)))
                            .then((value) {
                          setState(() {
                            _dateTimeExpiration = value;
                          });
                        });
                      },
                      elevate: 0,
                    ),
                    if (_dateTimeExpiration == null && showRequired)
                      messageErrorWidget(REQUIRED_MESSAGE),
                    SizedBox(
                      height: 14,
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _soatPhotoLoading,
                      builder: (context, value, child) {
                        return ButtonUploadPhoto(
                          title: "Foto del SOAT",
                          subTitle: "(Subir foto de frente)",
                          onImageSelected: (value) async {
                            try {
                              _soatPhotoLoading.value = true;
                              soatPhoto = await context
                                  .read(registerProvider.notifier)
                                  .uploadImageFromPathRegister(value);
                            } catch (e) {
                              showError(context, e);
                            }
                            _soatPhotoLoading.value = false;
                          },
                          loading: value,
                          valid: soatPhoto != null,
                        );
                      },
                    ),
                    if (soatPhoto == null && showRequired)
                      messageErrorWidget(REQUIRED_MESSAGE),
                    SizedBox(
                      height: 14,
                    ),
                    DomiContinueButton(
                      voidCallback: _saveInfo,
                    ),
                    SizedBox(
                      height: 290,
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
    if (soatPhoto == null ||
        _dateTimeExpedition == null ||
        _dateTimeExpiration == null) {
      setState(() {
        showRequired = true;
      });
      return;
    }

    context
        .read(registerProvider.notifier)
        .setSoat(_dateTimeExpedition!, _dateTimeExpiration!, soatPhoto!);
    Navigator.of(context).pop(1);
  }
}
