import 'package:flutter/material.dart';
import 'package:grandmaster/widgets/images/brand_icon.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
      this.onTapIcon,
      this.centerText = false,
      this.textStyle,
      this.keyboardType,
      this.maxLength,
      this.onTap,
      this.validator,
      this.padding})
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
  final onTapIcon;
  final TextStyle? textStyle;
  final bool centerText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        validator: validator ??
            (String? text) {
              if (label != null && label!.contains('сообщение')) return null;
              if (text == '')
                return 'Необходим ввод';
              else
                return null;
            },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTap: onTap,
        readOnly: onTap != null,
        maxLength: maxLength,
        keyboardType: keyboardType,
        onFieldSubmitted: (text) {
          print(text);
          onFieldSubmitted!(text);
        },
        textAlign: TextAlign.center,
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
          contentPadding: padding != null
              ? padding
              : height != null
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
                    onTap: onTapIcon,
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
  const InputDate(
      {Key? key, required this.controller, this.label, this.validator})
      : super(key: key);
  final TextEditingController controller;
  final String? label;
  final FormFieldValidator<String>? validator;

  @override
  State<InputDate> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  @override
  Widget build(BuildContext context) {
    var maskFormatter = new MaskTextInputFormatter(
        mask: 'Dd.Mm.yyyy',
        filter: {
          "D": RegExp(r'[0-3]'),
          "d": RegExp(r'[0-9]'),
          "M": RegExp(r'[0-1]'),
          "m": RegExp(r'[0-9]'),
          "y": RegExp(r'[0-9]'),
        },
        type: MaskAutoCompletionType.lazy);

    validate(text) {
      if (widget.controller.text.length != "##.##.####".length) {
        return 'Введите дату';
      } else {
        return null;
      }
    }

    return TextFormField(
      // mask: "##.##.####",
      // inputFormatters: [maskFormatter],
      controller: widget.controller,
      maxLength: "##.##.####".length,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator ?? validate,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      onTap: () async {
        DateTime? datetime = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 5)),
            lastDate: DateTime.now().add(Duration(days: 60)));
        if (datetime != null)
          widget.controller.text = DateFormat('d.MM.y').format(datetime);
      },
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
  const InputPhone({Key? key, this.controller, this.label, this.onChanged})
      : super(key: key);
  final TextEditingController? controller;
  final String? label;
  final Function(String)? onChanged;

  @override
  State<InputPhone> createState() => _InputPhoneState();
}

class _InputPhoneState extends State<InputPhone> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // mask: "+# (###) ###-##-##",
      controller: widget.controller ?? null,
      maxLength: "+# (###) ###-##-##".length,
      keyboardType: TextInputType.phone,
      onChanged: widget.onChanged,
      validator: (text) {
        if (widget.controller?.text.length != "+# (###) ###-##-##".length)
          return 'Введите номер телефона';
        else
          return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
