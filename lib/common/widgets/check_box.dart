import 'package:elabv01/common/theme.dart';
import 'package:flutter/material.dart';
class CheckboxCommon extends StatelessWidget {
   final bool isChecked;
   final void Function() onTap;
   const CheckboxCommon({super.key, required this.onTap, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return appTheme.primaryColor;
      }
      return appTheme.primaryColorDark;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
       onTap();
      },
    );
  }
}
