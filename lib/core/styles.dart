import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/core/colors.dart';

/// Contains all re-usable styles for app wide configurations
/// @author Paul Okeke
class Styles {
  static final ButtonStyle primaryButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: Styles.defaultFont)),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled))
          return Colors.primaryColor.withOpacity(0.5);
        else if (states.contains(MaterialState.pressed))
          return Colors.primaryColor.withOpacity(0.5);
        else
          return Colors.primaryColor;
      }),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))));

  static final ButtonStyle whiteButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          color: Colors.primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 16,
          fontFamily: Styles.defaultFont)),
      foregroundColor: MaterialStateProperty.all(Colors.primaryColor),
      backgroundColor: MaterialStateProperty.all(Colors.white),
      overlayColor:
          MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.2)),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))));

  static final ButtonStyle primaryDarkButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: Styles.defaultFont)),
      backgroundColor: MaterialStateProperty.all(Colors.colorPrimaryDark),
      overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))));

  static final String defaultFont = "CircularStd";

  /// A Generic Primary Button
  static ElevatedButton appButton(
      {required VoidCallback? onClick,
      required String text,
      Color? textColor,
      double? paddingStart,
      double? paddingTop,
      double? paddingBottom,
      double? paddingEnd,
      double? padding,
      ButtonStyle? buttonStyle,
      double? elevation,
      double? borderRadius}) {
    var mButtonStyle = buttonStyle ?? Styles.primaryButtonStyle;
    if (padding != null) {
      mButtonStyle = mButtonStyle.copyWith(
          padding: MaterialStateProperty.all(EdgeInsets.all(padding)));
    } else if (paddingStart != null ||
        paddingEnd != null ||
        paddingBottom != null ||
        paddingTop != null) {
      mButtonStyle = mButtonStyle.copyWith(
        padding: MaterialStateProperty.all(EdgeInsets.only(
            left: paddingStart ?? 0,
            top: paddingTop ?? 0,
            right: paddingEnd ?? 0,
            bottom: paddingBottom ?? 0)),
      );
    }
    if (elevation != null) {
      mButtonStyle = mButtonStyle.copyWith(
          elevation: MaterialStateProperty.all(elevation));
    }
    return ElevatedButton(
        onPressed: onClick, child: Text(text), style: mButtonStyle);
  }

  static TextFormField appEditText({
    String? hint,
    double borderRadius = 4,
    Color? borderColor,
    double? drawablePadding,
    double? fontSize,
    ValueChanged<String>? onChanged,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormats,
    bool isPassword = false,
    bool animateHint = false,
    Icon? startIcon,
    Widget? endIcon,
    int? maxLength,
    String? errorText,
    TextEditingController? controller,
    Function(bool)? focusListener,
    EdgeInsets? padding,
  }) {
    String? labelText = (animateHint) ? hint : null;

    //TODO how do we dispose this
    // FocusNode mFocusNode = new FocusNode();
    // mFocusNode.addListener(() => focusListener?.call(mFocusNode.hasFocus));

    return TextFormField(
      inputFormatters: inputFormats,
      maxLength: maxLength,
      controller: controller,
      onChanged: onChanged,
      // focusNode: mFocusNode,
      style: TextStyle(
          fontFamily: Styles.defaultFont,
          fontSize: fontSize ?? 16,
          color: Colors.textColorBlack
      ),
      keyboardType: inputType,
      obscureText: isPassword,
      enableSuggestions: (isPassword) ? false : true,
      autocorrect: (isPassword) ? false : true,
      decoration: InputDecoration(
          errorText: errorText,
          // hintText: hint,
          labelText: labelText,
          contentPadding: padding,
          // hintStyle: TextStyle(fontFamily: Styles.defaultFont, fontSize: fontSize ?? 16, color: Colors.textHintColor.withOpacity(0.29)),
          labelStyle: TextStyle(
              fontFamily: Styles.defaultFont,
              fontSize: fontSize ?? 16,
              color: Colors.textHintColor.withOpacity(0.29)
          ),
          prefixIcon: (startIcon == null)
              ? null
              : Padding(
                  padding: EdgeInsets.only(
                      right: drawablePadding ?? 16,
                      left: drawablePadding ?? 16),
                  child: startIcon),
          suffixIcon: (endIcon == null) ? null : endIcon,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(color: Colors.colorFaded, width: 0.6)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(color: Colors.primaryColor, width: 1.4)
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(color: Colors.colorFaded, width: 1.5)
          )
      ),
    );
  }
}
