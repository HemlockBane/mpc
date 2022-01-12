import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
          fontWeight: FontWeight.bold,
          fontFamily: Styles.defaultFont
      )),
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
          fontWeight: FontWeight.bold,
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

  static final ButtonStyle redButtonStyle2 = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: Styles.defaultFont)),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled))
          return Colors.red.withOpacity(0.5);
        else if (states.contains(MaterialState.pressed))
          return Colors.red.withOpacity(0.8);
        else
          return Colors.red.withOpacity(1);
      }),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))));

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

  static final ButtonStyle redButtonStyleBordered = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 15,
          color: Colors.red,
          fontWeight: FontWeight.w500,
          fontFamily: Styles.defaultFont)),
      foregroundColor: MaterialStateProperty.all(Colors.red),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled))
          return Colors.red.withOpacity(0.1);
        else if (states.contains(MaterialState.pressed))
          return Colors.red.withOpacity(0.1);
        else
          return Colors.white;
      }),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: Color(0XFFE72E2A), width: 0.8)
      )));

  static final ButtonStyle greyButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 16,
          color: Colors.deepGrey,
          fontWeight: FontWeight.w500,
          fontFamily: Styles.defaultFont)
      ),
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

  static final ButtonStyle lightGreyButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 16,
          color: Colors.deepGrey,
          fontWeight: FontWeight.w500,
          fontFamily: Styles.defaultFont)
      ),
      foregroundColor: MaterialStateProperty.all(Colors.deepGrey),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled))
          return Colors.deepGrey.withOpacity(0.3);
        else if (states.contains(MaterialState.pressed))
          return Colors.deepGrey.withOpacity(0.3);
        else
          return Colors.deepGrey.withOpacity(0.1);
      }),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))
  );

  static final ButtonStyle savingsFlexButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: Styles.defaultFont)),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled))
          return Colors.savingsPrimary.withOpacity(0.5);
        else if (states.contains(MaterialState.pressed))
          return Colors.savingsPrimary.withOpacity(0.5);
        else
          return Colors.savingsPrimary;
      }),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))));

  static final ButtonStyle savingsSafeLockButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: Styles.defaultFont)),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled))
          return Colors.safeLockPrimary.withOpacity(0.5);
        else if (states.contains(MaterialState.pressed))
          return Colors.safeLockPrimary.withOpacity(0.5);
        else
          return Colors.safeLockPrimary;
      }),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))));

  static final ButtonStyle targetSavingsButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: Styles.defaultFont)),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled))
          return Colors.targetSavingsPrimary.withOpacity(0.5);
        else if (states.contains(MaterialState.pressed))
          return Colors.targetSavingsPrimary.withOpacity(0.5);
        else
          return Colors.targetSavingsPrimary;
      }),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))));


  static final ButtonStyle groupSavingsButtonStyle = ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: Styles.defaultFont)),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled))
          return Colors.groupSavingsPrimary.withOpacity(0.5);
        else if (states.contains(MaterialState.pressed))
          return Colors.groupSavingsPrimary.withOpacity(0.5);
        else
          return Colors.groupSavingsPrimary;
      }),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))));


  static const String defaultFont = "Inter";
  static const String ocraExtended = "Ocra";
  static const String circularStd = "CircularStd";

  /// A Generic Primary Button
  static ElevatedButton appButton(
      {required VoidCallback? onClick,
      required String text,
      Color? textColor,
      double? paddingStart = 20,
      double? paddingTop = 16,
      double? paddingBottom = 16,
      double? paddingEnd = 20,
      double? padding = 18,
      ButtonStyle? buttonStyle,
      double? elevation,
      double? borderRadius,
      Widget? icon,
      TextStyle? textStyle,
        Key? key,
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
            left: paddingStart ?? 20,
            top: paddingTop ?? 20,
            right: paddingEnd ?? 20,
            bottom: paddingBottom ?? 20)),
      );
    }
    if (elevation != null) {
      mButtonStyle = mButtonStyle.copyWith(
          elevation: MaterialStateProperty.all(elevation));
    }
    if(borderRadius != null) {
      mButtonStyle = mButtonStyle.copyWith(shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))));
    }

    if(textStyle != null) {
      mButtonStyle = mButtonStyle.copyWith(textStyle: MaterialStateProperty.all(textStyle));
    }
    return ElevatedButton.icon(
        key: key,
        icon: icon ?? SizedBox(),
        onPressed: onClick,
        label: Text(text),
        style: mButtonStyle
    );
  }

  /// Default EditText
  static TextFormField appEditText({
    String? hint,
    double borderRadius = 4,
    Color? borderColor,
    Color? focusedBorderColor,
    EdgeInsets? drawablePadding,
    double? fontSize,
    double? hintSize,
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
    bool readOnly = false,
    Color? fillColor = Colors.textFieldColor,
    int? maxLines = 1,
    int? minLines,
    String? value,
    Color? textColor,
    FontWeight? fontWeight,
    TextInputAction? textInputAction
  }) {
    String? labelText = (animateHint) ? hint : null;

    return TextFormField(
      initialValue: value,
      readOnly: readOnly,
      inputFormatters: inputFormats,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      controller: controller,
      onChanged: onChanged,
      onTap: onClick,
      enableInteractiveSelection: enabled,
      textInputAction: textInputAction,
      focusNode: (!enabled) ? AlwaysDisabledFocusNode() : null,
      // focusNode: mFocusNode,
      style: TextStyle(
          fontWeight: fontWeight ?? FontWeight.normal,
          fontFamily: Styles.defaultFont,
          fontSize: fontSize ?? 16,
          color: textColor ?? Colors.textColorBlack
      ),
      keyboardType: inputType,
      obscureText: isPassword,
      enableSuggestions: (isPassword) ? false : true,
      autocorrect: (isPassword) ? false : true,
      decoration: InputDecoration(
          filled: fillColor != null,
          fillColor: fillColor?.withOpacity(0.15) ?? null,
          errorText: errorText,
          hintText: (!animateHint) ? hint : null,
          labelText: labelText,
          contentPadding: padding,
          hintStyle: TextStyle(fontFamily: Styles.defaultFont, fontWeight: FontWeight.w400, fontSize : hintSize ?? fontSize ?? 16, color: Colors.textHintColor.withOpacity(0.3)),
          labelStyle: TextStyle(
              fontFamily: Styles.defaultFont,
              fontSize: fontSize ?? 16,
              color: Colors.textHintColor.withOpacity(0.29)
          ),
          prefixIcon: (startIcon == null)
              ? null
              : Padding(
                  padding: drawablePadding ?? EdgeInsets.only(right:16, left: 16),
                  child: startIcon),
          suffixIcon: (endIcon == null) ? null : endIcon,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(color: borderColor ?? Colors.transparent, width: 0.8)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(color: focusedBorderColor ?? Colors.textFieldColor.withOpacity(0.3), width: 1.8)
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: BorderSide(
                color: borderColor ?? Colors.transparent, width: 1.5)),
      ),
    );
  }

  /// Default Image Button
  static Widget imageButton({
    required Widget image,
    VoidCallback? onClick,
    BorderRadius? borderRadius,
    Color? color,
    Color? disabledColor,
    EdgeInsets? padding
  }){
    return Container(
      decoration: BoxDecoration(
        color: (onClick != null) ? color ?? Colors.primaryColor : disabledColor ?? Colors.deepGrey.withOpacity(0.5),
        borderRadius: borderRadius ??  BorderRadius.all(Radius.circular(4)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          borderRadius: borderRadius ??  BorderRadius.all(Radius.circular(4)),
          child: Container(
            padding: padding ?? EdgeInsets.all(18.5),
            child: image,
          ),
        ),
      ),
    );
  }

  /// Default App DropDown
  static Widget buildDropDown<T extends DropDownItem>(
      List<T> items,
      AsyncSnapshot<T?> snapShot,
      OnItemClickListener<T?, int> valueChanged,
      {
        String? hint,
        Color? fillColor = Colors.textFieldColor,
        Color? iconColor = Colors.primaryColor,
        TextStyle? itemStyle,
        TextStyle? buttonStyle
      }) {

    Widget errorLayout = (snapShot.hasError)
        ? Align(
        alignment: Alignment.centerLeft,
        child: Text(
            snapShot.error as String,
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.red, fontSize: 12)
        )
    ) : SizedBox();

    return Column(
      children: [
        InputDecorator(
          decoration: InputDecoration(
            filled: fillColor != null,
            fillColor: fillColor?.withOpacity(0.15) ?? null,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(2)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.textFieldColor.withOpacity(0.0))),
            contentPadding: EdgeInsets.only(left: 16, right: 21, top: 5, bottom: 5),
          ),
          child: DropdownButton<T>(
              underline: Container(),
              hint: (hint != null) ? Text(hint, style: TextStyle(color: Colors.textHintColor.withOpacity(0.29)),) : null,
              icon: Icon(CustomFont.dropDown, color: iconColor, size: 6),
              isExpanded: true,
              value: snapShot.data,
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (v) => valueChanged.call(v, (v != null) ? items.indexOf(v) : -1),
              style: buttonStyle ?? const TextStyle(color: Colors.darkBlue, fontFamily: Styles.defaultFont, fontSize: 14),
              items: items.map((T item) {
                return DropdownMenuItem(
                    value: item,
                    child: Text(item.getTitle(), style: itemStyle,)
                );
              }).toList()),
        ),
        SizedBox(height: 4),
        errorLayout
      ],
    );
  }

  static Widget statefulButton({
    required Stream<bool>? stream,
    required VoidCallback onClick,
    required String text,
    bool isLoading = false,
    ButtonStyle? buttonStyle,
    Color? textColor,
    double? elevation = 0,
    Color? loadingColor,
  }) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: StreamBuilder(
              stream: stream,
              builder: (BuildContext mContext, AsyncSnapshot<bool> snapshot) {
                final enableButton = (snapshot.hasData && snapshot.data == true) && !isLoading;
                return Styles.appButton(
                    elevation: elevation,
                    onClick: enableButton ? onClick: null,
                    text: text,
                    buttonStyle: buttonStyle,
                    textColor: textColor
                );
              }),
        ),
        Positioned(
            right: 16,
            top: 16,
            bottom: 16,
            child: isLoading
                ? SpinKitThreeBounce(size: 20.0, color: loadingColor ?? Colors.primaryColor.withOpacity(0.5))
                : SizedBox()
        )
      ],
    );
  }

  static Widget statefulButton2({
    required VoidCallback onClick,
    required String text,
    bool isValid = false,
    bool isLoading = false,
    ButtonStyle? buttonStyle,
    Color? textColor,
    double? elevation = 0,
    double? padding,
    Color? loadingColor,
  }) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Styles.appButton(
                    elevation: elevation,
                    onClick: isValid && !isLoading ? onClick: null,
                    text: text,
                    buttonStyle: buttonStyle,
                    textColor: textColor,
                    padding: padding
                )
          ),
        Positioned(
            right: 16,
            top: 16,
            bottom: 16,
            child: isLoading
                ? SpinKitThreeBounce(size: 20.0, color: loadingColor ?? Colors.primaryColor.withOpacity(0.5))
                : SizedBox())
      ],
    );
  }

  static TextStyle textStyle(BuildContext context,
      {FontWeight fontWeight = FontWeight.normal,
      double fontSize = 13,
      Color color = const Color(0xFF1A0C2F),
      double? letterSpacing,
      double? lineHeight}) {
    final defaultStyle = Theme.of(context).primaryTextTheme.bodyText2;
    return TextStyle(
        fontSize: fontSize,
        height: lineHeight ?? defaultStyle?.height,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing ?? defaultStyle?.letterSpacing,
        fontFamily: "Inter");
  }

  static Widget makeTextWithIcon(
      {required String src,
        required String text,
        VoidCallback? onClick,
        required double width,
        required double height,
        double spacing = 4}) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            src,
            fit: BoxFit.contain,
            width: width,
            height: height,
          ),
          SizedBox(height: spacing),
          Text(text,
              style: TextStyle(fontFamily: Styles.defaultFont, fontSize: 12, color: Colors.white)
          )
        ],
      ),
      onTap: onClick,
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
