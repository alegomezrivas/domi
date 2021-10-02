import 'dart:async';

import 'package:domi/re_use/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IndomiTextFormField extends StatefulWidget {
  final List<TextInputFormatter>? formatters;
  final Color color;
  final double radius;
  final double width;
  final double height;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? edgeInsetsGeometry;
  final String? hintText;
  final TextAlign textAlign;
  final int? maxLength;
  final TextEditingController? controller;
  final AutovalidateMode? autovalidateMode;
  final bool? enabledNumber;
  final bool? lock;
  final bool? pointYellow;
  final int? minLines;
  final int? maxLines;
  final Widget? suffix;
  final Widget? suffixIcon;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onSaved;
  final String? labelText;
  final OutlineInputBorder? outlineInputBorder;

  IndomiTextFormField(
      {this.formatters,
      this.color = Colors.white,
      this.radius = 19,
      this.width = 273,
      this.height = 44,
      this.validator,
      this.keyboardType,
      this.edgeInsetsGeometry = const EdgeInsets.only(left: 14),
      this.hintText,
      this.textAlign = TextAlign.start,
      this.maxLength,
      this.controller,
      this.autovalidateMode,
      this.enabledNumber,
      this.lock,
      this.pointYellow,
      this.minLines,
      this.maxLines = 1,
      this.initialValue,
      this.suffix,
      this.onChanged,
      this.suffixIcon,
      this.onSaved,
      this.labelText,
      this.outlineInputBorder});

  @override
  _IndomiTextFormFieldState createState() => _IndomiTextFormFieldState();
}

class _IndomiTextFormFieldState extends State<IndomiTextFormField> {
  String? errorMessage;
  bool _mounted = false;
  StreamController<String> _validationController = StreamController<String>();

  @override
  void dispose() {
    _mounted = true;
    _validationController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.minLines);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          width: widget.width,
          height: widget.minLines != null || (widget.maxLines ?? 0) > 1
              ? null
              : widget.height,
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.radius)),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: widget.initialValue,
                  controller: widget.controller,
                  textAlign: widget.textAlign,
                  inputFormatters: widget.formatters,
                  enabled: widget.enabledNumber,
                  onSaved: widget.onSaved,
                  validator: widget.validator != null
                      ? (String? value) {
                          // if (widget.autovalidateMode ==
                          //     AutovalidateMode.onUserInteraction) {
                          //   Future.delayed(Duration(milliseconds: 100), () {
                          //     if (!_mounted) {
                          //       setState(() {
                          //         errorMessage = widget.validator!(value);
                          //       });
                          //     }
                          //   });
                          // } else {
                          //   if (!_mounted) {
                          //     setState(() {
                          //       errorMessage = widget.validator!(value);
                          //     });
                          //   }
                          // }
                          errorMessage = widget.validator!(value);
                          _validationController.sink.add(errorMessage ?? "");
                          return errorMessage;
                        }
                      : null,
                  keyboardType: widget.keyboardType,
                  maxLength: widget.maxLength,
                  autovalidateMode: widget.autovalidateMode,
                  decoration: InputDecoration(
                      labelText: widget.labelText,
                      errorStyle:
                          TextStyle(height: 0, color: Colors.transparent),
                      prefixIcon: widget.pointYellow == true
                          ? Icon(
                              Icons.location_pin,
                              color: inDomiYellow,
                            )
                          : null,
                      suffixIcon: widget.suffixIcon,
                      counterText: "",
                      contentPadding: widget.edgeInsetsGeometry,
                      border: InputBorder.none,
                      isDense: true,
                      hintText: widget.hintText,
                      hintStyle:
                          TextStyle(fontSize: 14, color: Color(0xffD1D1D1))),
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  onChanged: widget.onChanged,
                ),
              ),
              if (widget.suffix != null) widget.suffix!
            ],
          ),
        ),
        StreamBuilder<String>(
          stream: _validationController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return SizedBox();
            if (snapshot.data!.isEmpty) return SizedBox();
            return Padding(
              padding: EdgeInsets.only(top: 2, left: 5),
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            );
          },
        )
      ],
    );
  }
}
