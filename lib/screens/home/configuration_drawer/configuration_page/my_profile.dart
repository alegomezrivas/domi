import 'dart:io';

import 'package:domi/main.dart';
import 'package:domi/re_use/domi_button_continue.dart';
import 'package:domi/re_use/indomi_text_form_field.dart';
import 'package:domi/re_use/message_strings.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/general_repository.dart';
import 'package:domi/repositories/user_repository.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final dfz = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
  final df = DateFormat("yyyy-MM-dd");
  File? _image;
  final picker = ImagePicker();
  TextEditingController _name = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _number = TextEditingController();
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  ValueNotifier<bool> _uploading = ValueNotifier<bool>(false);

  String? imageKey;
  String? urlImage;

  bool showRequired = false;
  DateTime now = DateTime.now();

  @override
  void initState() {
    final provider = context.read(authProvider);
    _name.text = provider.userData!.user.firstName;
    _lastname.text = provider.userData!.user.lastName;
    if (provider.userData!.user.person.photo != null) {
      urlImage = provider.userData!.user.person.photo;
    }
    _email.text = provider.userData!.user.email ?? "";
    _number.text = provider.userData!.user.username;
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _lastname.dispose();
    _email.dispose();
    _uploading.dispose();
    _number.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        body: CustomScrollView(
          slivers: [
            DomiSliverAppBar("Mi perfil"),
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
                        child: _image == null && urlImage == null
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
                                  urlImage != null
                                      ? CircleAvatar(
                                          radius: 70,
                                          backgroundImage:
                                              NetworkImage(urlImage!))
                                      : CircleAvatar(
                                          radius: 70,
                                          backgroundImage: MemoryImage(
                                            _image!.readAsBytesSync(),
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
                      IndomiTextFormField(
                        hintText: "Correo electrónico (opcional)",
                        radius: 9,
                        maxLength: 200,
                        edgeInsetsGeometry: EdgeInsets.only(left: 16),
                        width: double.maxFinite,
                        controller: _email,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return VALID_EMAIL_MESSAGE;
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      IndomiTextFormField(
                        enabledNumber: false,
                        suffixIcon: Icon(Icons.lock),
                        hintText: "Numero",
                        radius: 9,
                        maxLength: 30,
                        controller: _number,
                        width: double.maxFinite,
                        edgeInsetsGeometry: EdgeInsets.only(left: 16, top: 10),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: _uploading,
                          builder: (context, value, child) {
                            return DomiContinueButton(
                              disabled: value,
                              voidCallback: _editProfile,
                              text: "Guardar",
                            );
                          }),
                      SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future getImage() async {
    final choice = await imageSourceBottomSheet(context);

    if (choice == null) {
      return;
    }
    final pickedFile = await picker.getImage(source: choice, imageQuality: 50);
    if (pickedFile != null) {
      _uploading.value = true;
      _image = File(pickedFile.path);
      if (await _image!.length() > MAX_IMAGE_SIZE) {
        showError(context, {"detail": IMAGE_SIZE_MESSAGE});
        return;
      }
      final response =
          await UserRepository.getPresignedData(_image!.uri.pathSegments.last);
      await GeneralRepository.uploadFile(response, _image!);
      urlImage = null;
      setState(() {});
      imageKey = response["fields"]["key"];
    } else {
      print('No image selected.');
    }
    _uploading.value = false;
  }

  Future<void> _editProfile() async {
    try {
      if (!_formState.currentState!.validate()) {
        return;
      }
      final response = await context.read(authProvider).editProfile(
            imageKey,
            _name.text,
            _lastname.text,
            _email.text == "" ? null : _email.text,
          );
      Navigator.of(context).pop();
    } catch (e) {
      showError(context, e);
      if (e is Map<String, dynamic>) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e["error"] ?? "")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Se ha producido un error intente mas tarde")));
      }
    }
  }
}
