import 'package:flutter/material.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:masked_text/masked_text.dart';

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
      this.textStyle,
      this.keyboardType,
      this.maxLength})
      : super(key: key);

  final String? label;
  final String? defaultText;
  final bool? obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool expanded;
  final String? icon;
  final borderRadius;
  final double? width;
  final double? height;
  final Function(String)? onFieldSubmitted;
  final onTapCalendar;
  final onTap;
  final TextStyle? textStyle;
  final bool centerText;
  final TextInputType? keyboardType;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        maxLength: maxLength,
        keyboardType: keyboardType,
        onFieldSubmitted: (text) {
          print(text);
          onFieldSubmitted!(text);
        },
        obscureText: obscureText == true,
        minLines:
            expanded || label == 'Описание' || label == 'Название' ? 1 : 1,
        maxLines:
            expanded || label == 'Описание' || label == 'Название' ? 10 : 1,
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
          counterText: '',
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

class InputDate extends StatefulWidget {
  const InputDate({Key? key, this.controller, this.label}) : super(key: key);
  final TextEditingController? controller;
  final String? label;

  @override
  State<InputDate> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  @override
  Widget build(BuildContext context) {
    return MaskedTextField(
      mask: "##.##.####",
      controller: widget.controller ?? null,
      maxLength: "##.##.####".length,
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: Color(
            0xFF927474,
          ),
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        // contentPadding: height != null
        //     ? centerText
        //     ? EdgeInsets.fromLTRB(20, 10.0, 20.0, 10.0)
        //     : EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0)
        //     : centerText
        //     ? EdgeInsets.fromLTRB(52, 10.0, 20.0, 52.0)
        //     : null,
        // suffixIcon: icon != null
        //     ? Transform.scale(
        //     scale: 0.45,
        //     child: BrandIcon(
        //       icon: icon,
        //       onTapCalendar: onTapCalendar,
        //       onTap: onTap,
        //     ))
        //     : null,
        alignLabelWithHint: true,
        counterText: '',
        labelText: widget.label ?? '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}

class InputPhone extends StatefulWidget {
  const InputPhone({Key? key, this.controller, this.label}) : super(key: key);
  final TextEditingController? controller;
  final String? label;

  @override
  State<InputDate> createState() => _InputDateState();
}

class _InputPhoneState extends State<InputDate> {
  @override
  Widget build(BuildContext context) {
    return MaskedTextField(
      mask: "+# (###) ###-##-##",
      controller: widget.controller ?? null,
      maxLength: "+# (###) ###-##-##".length,
      keyboardType: TextInputType.phone,
      style: TextStyle(
          color: Color(
            0xFF927474,
          ),
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        // contentPadding: height != null
        //     ? centerText
        //     ? EdgeInsets.fromLTRB(20, 10.0, 20.0, 10.0)
        //     : EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0)
        //     : centerText
        //     ? EdgeInsets.fromLTRB(52, 10.0, 20.0, 52.0)
        //     : null,
        // suffixIcon: icon != null
        //     ? Transform.scale(
        //     scale: 0.45,
        //     child: BrandIcon(
        //       icon: icon,
        //       onTapCalendar: onTapCalendar,
        //       onTap: onTap,
        //     ))
        //     : null,
        alignLabelWithHint: true,
        counterText: '',
        labelText: widget.label ?? '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}
