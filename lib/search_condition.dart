import 'package:flutter/material.dart';

import '../common/switch_button.dart';
import '../common/dropdown_common.dart';
import '../common/theme.dart';
import 'Common/footer.dart';

class SearchCondition extends StatelessWidget{
  const SearchCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Điều kiện tìm kiếm")),
      body: const EditConditionView(),
      bottomNavigationBar: const NavigationBottom(),
    );
  }

}
class EditConditionView extends StatefulWidget {
  const EditConditionView({Key? key}) : super(key: key);

  @override
  State<EditConditionView> createState() => _EditConditionViewState();
}
class _EditConditionViewState extends State<EditConditionView> {

  RangeValues _currentRangeValues = const RangeValues(20, 60);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          const MultiSelectDropdownCommon(title: 'Thể thao'),
          const MyGenderRadio(
            textStr: 'Giới tính',
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Cho phép tìm kiếm"),
              ),
              LocationSwitch()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Tuổi",
                    style: appTheme.textTheme.bodyMedium,
                  ),
                ),
              )
            ],
          ),
       // Expanded(
       //  child:
        RangeSlider(
          values: _currentRangeValues,
          min: 0,
          max: 100,
          divisions: 100,
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        )
     //  ),
        ],
      ),
    );
  }

}
enum Gender { nam, nu }

class MyGenderRadio extends StatefulWidget {
  const MyGenderRadio({
    Key? key,
    required this.textStr,
  }) : super(key: key);
  final String textStr;

  @override
  State<MyGenderRadio> createState() => _MyGenderRadioState();
}
class _MyGenderRadioState extends State<MyGenderRadio> {
  Gender gender = Gender.nam;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.textStr,
                  style: appTheme.textTheme.bodyMedium,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: ListTile(
                        title: Text(Gender.nam.name),
                        leading: Radio<Gender>(
                          value: Gender.nam,
                          groupValue: gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        title: Text(Gender.nu.name),
                        leading: Radio<Gender>(
                          value: Gender.nu,
                          groupValue: gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        )
      ],
    );
  }
}