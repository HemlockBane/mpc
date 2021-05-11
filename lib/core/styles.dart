import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/DropDownItem.dart';

import 'custom_fonts.dart';

typedef OnItemClickListener<T, K extends num> = Function(T item, K index);

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

  static final ButtonStyle redButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 16,
          color: Colors.red,
          fontWeight: FontWeight.w500,
          fontFamily: Styles.defaultFont)),
      foregroundColor: MaterialStateProperty.all(Colors.red),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled))
          return Colors.red.withOpacity(0.5);
        else if (states.contains(MaterialState.pressed))
          return Colors.red.withOpacity(0.5);
        else
          return Colors.red.withOpacity(0.2);
      }),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))));

  static final ButtonStyle greyButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 16,
          color: Colors.deepGrey,
          fontWeight: FontWeight.w500,
          fontFamily: Styles.defaultFont)),
      foregroundColor: MaterialStateProperty.all(Colors.deepGrey),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled))
          return Colors.deepGrey.withOpacity(0.5);
        else if (states.contains(MaterialState.pressed))
          return Colors.deepGrey.withOpacity(0.5);
        else
          return Colors.deepGrey.withOpacity(0.2);
      }),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))));

  static const String defaultFont = "CircularStd";
  static const String ocraExtended = "Ocra";

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
      double? borderRadius,
      Widget? icon
      }) {
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
    return ElevatedButton.icon(
        icon: icon ?? SizedBox(),
        onPressed: onClick,
        label: Text(text),
        style: mButtonStyle
    );
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
    VoidCallback? onClick,
    bool enabled = true,
    bool readOnly = false
  }) {
    String? labelText = (animateHint) ? hint : null;

    //TODO how do we dispose this
    // FocusNode mFocusNode = new FocusNode();
    // mFocusNode.addListener(() => focusListener?.call(mFocusNode.hasFocus));

    return TextFormField(
      readOnly: readOnly,
      inputFormatters: inputFormats,
      maxLength: maxLength,
      controller: controller,
      onChanged: onChanged,
      onTap: onClick,
      enableInteractiveSelection: enabled,
      focusNode: (!enabled) ? AlwaysDisabledFocusNode() : null,
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
          hintText: (!animateHint) ? hint : null,
          labelText: labelText,
          contentPadding: padding,
          hintStyle: TextStyle(fontFamily: Styles.defaultFont, fontSize : fontSize ?? 16, color: Colors.textHintColor.withOpacity(0.29)),
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


  static Widget imageButton({
    String? srcCompat, String? src, double? width, double? height,
    VoidCallback? onClick
  }){
    assert(srcCompat != null || src != null);
    return GestureDetector(
      onTap: onClick,
      child: (srcCompat != null) ? SvgPicture.asset(srcCompat, height: height, width: width) : Image.asset(src!),
    );
  }

  static Widget buildDropDown<T extends DropDownItem>(
      List<T> items,
      AsyncSnapshot<T> snapShot,
      OnItemClickListener<T?, int> valueChanged, {String? hint}) {
    return InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.colorFaded),
            borderRadius: BorderRadius.circular(2)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.colorFaded)),
        contentPadding: EdgeInsets.only(left: 16, right: 21, top: 5, bottom: 5),
      ),
      child: DropdownButton<T>(
          underline: Container(),
          hint: (hint != null) ? Text(hint, style: TextStyle(color: Colors.colorFaded),) : null,
          icon: Icon(CustomFont.dropDown, color: Colors.primaryColor, size: 6),
          isExpanded: true,
          value: snapShot.data,
          onChanged: (v) => valueChanged.call(v, (v != null) ? items.indexOf(v) : -1),
          style: const TextStyle(
              color: Colors.darkBlue,
              fontFamily: Styles.defaultFont,
              fontSize: 14
          ),
          items: items.map((T item) {
            return DropdownMenuItem(value: item, child: Text(item.getTitle()));
          }).toList()),
    );
  }
}


class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}