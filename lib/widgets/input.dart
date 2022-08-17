import 'package:flutter/material.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';

class Input extends StatelessWidget {
  Input(
      {Key? key,
      this.label,
      this.defaultText = '',
      this.obscureText = false,
      this.controller,
      this.onChanged,
      this.expanded = false,
      this.icon,
      this.borderRadius,
      this.width,
      this.height,
      this.onFieldSubmitted,
      this.onTapCalendar,
      this.onTap,
      this.centerText = false,
      this.textStyle})
      : super(key: key);

  final String? label;
  final String? defaultText;
  final bool? obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool? expanded;
  final String? icon;
  final borderRadius;
  final double? width;
  final double? height;
  final Function(String)? onFieldSubmitted;
  final onTapCalendar;
  final onTap;
  final TextStyle? textStyle;
  final bool centerText;

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
        style: textStyle ??
            TextStyle(
                color: Color(
                  0xFF927474,
                ),
                fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          contentPadding: height != null
              ? centerText
                  ? EdgeInsets.fromLTRB(20, 10.0, 20.0, 10.0)
                  : EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0)
              : centerText
                  ? EdgeInsets.fromLTRB(52, 10.0, 20.0, 52.0)
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
