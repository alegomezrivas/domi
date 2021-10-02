import 'dart:io';

import 'package:domi/main.dart';
import 'package:domi/re_use/domi_button_continue.dart';
import 'package:domi/re_use/message_strings.dart';
import 'package:domi/re_use/register/need_help_widget.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/general_repository.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ConfirmationId extends StatefulWidget {
  @override
  _ConfirmationIdState createState() => _ConfirmationIdState();
}

class _ConfirmationIdState extends State<ConfirmationId> {
  String? photoKey;
  bool showValidation = false;
  File? _image;
  final picker = ImagePicker();
  ValueNotifier<bool> _uploading = ValueNotifier<bool>(false);

  @override
  void initState() {
    final provider = context.read(registerProvider);
    if (provider.frontPhotoPath != null) {
      _image = File(provider.frontPhotoPath!);
      photoKey = provider.frontPhotoId;
    }
    super.initState();
  }

  @override
  void dispose() {
    _uploading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        body: CustomScrollView(
          slivers: [
            DomiSliverAppBar("Confirmación de ID"),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 28,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Subir foto sosteniendo el documento de identidad",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: inDomiGreyBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 17,
                            ),
                            InkWell(
                              onTap: getImage,
                              child: _image == null
                                  ? Column(
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              "assets/icons/Grupo 1370@2x.png"),
                                          height: 135,
                                          width: 115,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Image(
                                          image: AssetImage(
                                              "assets/icons/Grupo 1361@2x.png"),
                                          height: 44,
                                          width: 134,
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
                                    )
                                  : Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: 200,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
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
                                                  photoKey = null;
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
                            if (photoKey == null && showValidation)
                              messageErrorWidget(REQUIRED_MESSAGE,
                                  alignment: Alignment.center),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Tenga en cuenta lo siguiente:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: inDomiBluePrimary,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "La foto debe mostrar claramente la cara y el documento de identidad.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: inDomiGreyBlack,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Tome la foto con buena iluminación y buena calidad.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: inDomiGreyBlack,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "No tomar la foto con gafas o accesorios en el rostro.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: inDomiGreyBlack,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            DomiContinueButton(
                              voidCallback: _saveInfo,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            NeedHelpWidget(),
                          ],
                        ),
                      ),
                    ),
                  ],
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
      final response = await context
          .read(registerProvider.notifier)
          .getSignedData(_image!.uri.pathSegments.last);
      await GeneralRepository.uploadFile(response, _image!);
      photoKey = response["fields"]["key"];
      setState(() {});
    } else {
      print('No image selected.');
    }
    _uploading.value = false;
  }

  Future<void> _saveInfo() async {
    if (photoKey == null) {
      setState(() {
        showValidation = true;
      });
      return;
    }

    context.read(registerProvider.notifier).setPhotoID(photoKey!, _image!.path);
    Navigator.of(context).pop(1);
  }
}
