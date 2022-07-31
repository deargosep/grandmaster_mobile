import 'package:flutter/material.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';

class Input extends StatelessWidget {
  Input({
    Key? key,
    String? this.label,
    this.defaultText = '',
    this.obscureText,
    TextEditingController? this.controller,
    ValueChanged<String>? this.onChanged,
    bool? this.expanded,
    String? this.icon,
    this.borderRadius,
    this.width,
    this.height,
    this.onFieldSubmitted,
    this.onTapCalendar,
    this.onTap,
  }) : super(key: key);

  String? label;
  String? defaultText;
  bool? obscureText = false;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? expanded = false;
  String? icon;
  final borderRadius;
  final width;
  final height;
  final Function(String)? onFieldSubmitted;
  final onTapCalendar;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        onFieldSubmitted: (text) {
          print(text);
          onFieldSubmitted!(text);
        },
        obscureText: obscureText == true,
        minLines: expanded == true ? 3 : 1,
        maxLines: expanded == true ? 3 : 1,
        controller: controller,
        onChanged: onChanged,
        initialValue: controller != null ? null : defaultText,
        decoration: InputDecoration(
          contentPadding: height != null
              ? EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0)
              : null,
          suffixIcon: icon != null
              ? Transform.scale(
                  scale: 0.45,
                  child: BrandIcon(
                    icon: icon,
                    onTapCalendar: onTapCalendar,
                    onTap: onTap,
                  ))
              : null,
          alignLabelWithHint: true,
          labelText: label ?? '',
          border: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}
