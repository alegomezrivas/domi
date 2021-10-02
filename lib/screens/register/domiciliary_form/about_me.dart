import 'dart:io';

import 'package:domi/main.dart';
import 'package:domi/re_use/button_domi_form.dart';
import 'package:domi/re_use/domi_button_continue.dart';
import 'package:domi/re_use/indomi_text_form_field.dart';
import 'package:domi/re_use/message_strings.dart';
import 'package:domi/re_use/register/need_help_widget.dart';

import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/general_repository.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AboutMe extends StatefulWidget {
  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  final dfz = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
  final df = DateFormat("yyyy-MM-dd");
  DateTime? _dateTime;
  File? _image;
  final picker = ImagePicker();
  TextEditingController _name = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _email = TextEditingController();
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  ValueNotifier<bool> _uploading = ValueNotifier<bool>(false);

  String? imageKey;

  bool showRequired = false;
  DateTime now = DateTime.now();

  @override
  void initState() {
    final provider = context.read(registerProvider);
    _name.text = provider.firstName ?? "";
    _lastname.text = provider.lastName ?? "";
    _dateTime = provider.birthday;
    if (provider.photoPath != null) {
      _image = File(provider.photoPath!);
      imageKey = provider.photo;
    }
    _dateTime = provider.birthday;
    _email.text = provider.email ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _lastname.dispose();
    _email.dispose();
    _uploading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        body: CustomScrollView(
          slivers: [
            DomiSliverAppBar("Acerca de mi"),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Form(
                  key: _formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: getImage,
                        child: _image == null
                            ? Container(
                                height: 180,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage("assets/icons/im.png"),
                                      height: 158,
                                      width: 158,
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        child: Image(
                                          image: AssetImage(
                                              "assets/icons/Grupo 1361@2x.png"),
                                          height: 44,
                                          width: 160,
                                        )),
                                    ValueListenableBuilder<bool>(
                                      valueListenable: _uploading,
                                      builder: (context, value, child) {
                                        if (!value) {
                                          return SizedBox();
                                        }
                                        return CircularProgressIndicator();
                                      },
                                    )
                                  ],
                                ),
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 200,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
                                        image: DecorationImage(
                                            image: MemoryImage(
                                              _image!.readAsBytesSync(),
                                            ),
                                            fit: BoxFit.cover)),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.highlight_remove_outlined,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (_image != null) {
                                            _image = null;
                                            imageKey = null;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  ValueListenableBuilder<bool>(
                                    valueListenable: _uploading,
                                    builder: (context, value, child) {
                                      if (!value) {
                                        return SizedBox();
                                      }
                                      return CircularProgressIndicator();
                                    },
                                  )
                                ],
                              ),
                      ),
                      if (_image == null && showRequired)
                        messageErrorWidget(REQUIRED_MESSAGE,
                            alignment: Alignment.center),
                      SizedBox(
                        height: 20,
                      ),
                      IndomiTextFormField(
                        hintText: "Nombre",
                        radius: 9,
                        maxLength: 30,
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
                      IndomiTextFormField(
                        hintText: "Apellido",
                        radius: 9,
                        maxLength: 30,
                        width: double.maxFinite,
                        controller: _lastname,
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
                      ButtonDomiForm(
                        text: _dateTime == null
                            ? "Fecha de nacimiento"
                            : "${df.format(_dateTime!)}",
                        voidCallback: () {
                          showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1940),
                                  lastDate: DateTime(
                                      now.year - 18, now.month, now.day),
                                  initialDate: _dateTime ??
                                      DateTime(
                                          now.year - 18, now.month, now.day))
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                _dateTime = value;
                              });
                            }
                          });
                        },
                        elevate: 0,
                        valid: false,
                      ),
                      if (_dateTime == null && showRequired)
                        messageErrorWidget(REQUIRED_MESSAGE),
                      SizedBox(
                        height: 14,
                      ),
                      IndomiTextFormField(
                        hintText: "Correo electrónico (opcional)",
                        radius: 9,
                        maxLength: 200,
                        edgeInsetsGeometry: EdgeInsets.only(left: 16),
                        width: double.maxFinite,
                        controller: _email,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      DomiContinueButton(
                        voidCallback: _saveInfo,
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      NeedHelpWidget()
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future getImage() async {
    try {
      final choice = await imageSourceBottomSheet(context);

      if (choice == null) {
        return;
      }
      final pickedFile =
          await picker.getImage(source: choice, imageQuality: 50);
      if (pickedFile != null) {
        _uploading.value = true;
        _image = File(pickedFile.path);
        if (await _image!.length() > MAX_IMAGE_SIZE) {
          showError(context, {"detail": IMAGE_SIZE_MESSAGE});
          return;
        }
        final response = await context
            .read(registerProvider.notifier)
            .getSignedData(_image!.uri.pathSegments.last);
        await GeneralRepository.uploadFile(response, _image!);
        setState(() {});
        imageKey = response["fields"]["key"];
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print(e);
    } finally {
      _uploading.value = false;
    }
  }

  Future<void> _saveInfo() async {
    if (!_formState.currentState!.validate() ||
        imageKey == null ||
        _dateTime == null) {
      setState(() {
        showRequired = true;
      });
      return;
    }
    context.read(registerProvider.notifier).setAboutMeData(_name.text,
        _lastname.text, imageKey!, _image!.path, _email.text, _dateTime!);
    Navigator.of(context).pop(1);
  }
}
