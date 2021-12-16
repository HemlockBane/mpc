import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:moniepoint_flutter/core/views/custom_check_box.dart';

class ValidPasswordChecker extends StatefulWidget  {

  final String password;

  ValidPasswordChecker(this.password);

  @override
  State<StatefulWidget> createState() => _ValidPasswordChecker();

}

class _ValidPasswordChecker extends State<ValidPasswordChecker> with Validators{
  void _defaultFn(bool undefined) {
    /*do nothing*/
  }

  bool _isValidForKey(List<String>? passwordErrors, String key) {
    if(passwordErrors == null) return true;
    var isValid = true;

    passwordErrors.forEach((element) {
      if(element.toLowerCase().contains(key)) {
        isValid = false;
      }
    });

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final passwordErrors = validatePasswordWithMessage(widget.password).second;

    final hasLowerCase = _isValidForKey(passwordErrors, "valid password");
    final hasUpperCase = _isValidForKey(passwordErrors, "uppercase");
    final hasSpecialCase = _isValidForKey(passwordErrors, "special");
    final hasNumber = _isValidForKey(passwordErrors, "number");
    final has8Characters = _isValidForKey(passwordErrors, "8 characters");

    print(passwordErrors);

    final validTextStyle = TextStyle(color: Colors.textColorBlack, fontSize: 14);
    final invalidTextStyle = TextStyle(color: Color(0XFF9B9B9B), fontSize: 14);
    print("Updating container");
    return Container(
      padding: EdgeInsets.all(21),
      decoration: BoxDecoration(
          color: Colors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your password should contain:',
            style: TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(height: 8,),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CustomCheckBox(onSelect: _defaultFn, isSelected: hasLowerCase),
            title: Text('A lowercase letter (a-z) ', style: hasLowerCase ? validTextStyle : invalidTextStyle,),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CustomCheckBox(onSelect: _defaultFn, isSelected: hasUpperCase),
            title: Text('An uppercase letter (A-Z)', style: hasUpperCase ? validTextStyle : invalidTextStyle,),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CustomCheckBox(onSelect: _defaultFn, isSelected: hasSpecialCase),
            title: Text('A special character (e.g. !@#\$)', style: hasSpecialCase ? validTextStyle : invalidTextStyle,),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CustomCheckBox(onSelect: _defaultFn, isSelected:hasNumber),
            title: Text('A number (1-9) ', style: hasNumber ? validTextStyle : invalidTextStyle,),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CustomCheckBox(onSelect: _defaultFn, isSelected:has8Characters),
            title: Text('8 characters minimum', style: has8Characters ? validTextStyle : invalidTextStyle,),
          )
        ],
      ),
    );
  }
}