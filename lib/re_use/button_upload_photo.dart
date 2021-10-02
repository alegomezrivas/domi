import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ButtonUploadPhoto extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final ValueChanged<String>? onImageSelected;
  final picker = ImagePicker();
  final bool valid;
  final bool loading;

  ButtonUploadPhoto(
      {this.title,
      this.subTitle,
      this.onImageSelected,
      this.valid = false,
      this.loading = false});

  Future getImage(BuildContext context) async {
    final choice = await imageSourceBottomSheet(context);

    if (choice == null) {
      return;
    }

    final pickedFile = await picker.getImage(source: choice, imageQuality: 50);

    if (pickedFile != null) {
      onImageSelected!(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        getImage(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: TextStyle(
                        color: inDomiGreyBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subTitle!,
                    style: TextStyle(color: inDomiGreyBlack, fontSize: 11),
                  )
                ],
              ),
              Spacer(),
              Image(
                image: AssetImage("assets/icons/Grupo 1361@2x.png"),
                height: 44,
                width: 134,
              ),
              SizedBox(
                width: 4,
              ),
              if (loading) CircularProgressIndicator(strokeWidth: 2),
              if (valid && !loading)
                Icon(
                  Icons.check_circle_outline,
                  color: inDomiBluePrimary,
                  size: 23,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
