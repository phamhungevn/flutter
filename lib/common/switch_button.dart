import 'package:elabv01/common/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_switch/flutter_switch.dart';

class LocationSwitch extends StatefulWidget{
  const LocationSwitch({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LocationSwitchState();

}

class _LocationSwitchState extends State<LocationSwitch>{
  bool status = true;
  @override
  Widget build(BuildContext context) {
      return
        Padding(padding: const EdgeInsets.fromLTRB(10,0,10,10),child:FlutterSwitch(
          value: status,
          borderRadius: 30.0,
          padding: 8.0,
          showOnOff: true,
          activeColor: appTheme.primaryColorLight,
          inactiveColor: appTheme.primaryColorDark,
          onToggle: (val) {
            setState(() {
              status = val;
            });
          },
        ));
  }
}