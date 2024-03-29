import 'package:elabv01/common/theme.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';




class DropdownCommon extends StatefulWidget {
  const DropdownCommon({super.key, required this.items, required this.onChanged, required this.title, required this.id});
  final List<String> items;
  final List<String> id;
  final String title;
  final Function onChanged;
  @override
  State<DropdownCommon> createState() => _DropdownCommonState();
}

class _DropdownCommonState extends State<DropdownCommon> {
  // final List<String> items = [
  //   'Item1',
  //   'Item2',
  //
  // ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) widget.items.add("None");
    return
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(
                  Icons.list,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 4,
                ),
                Flexible(

                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: widget.items
                .map((String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ))
                .toList(),
            value: selectedValue,
            onChanged: (String? value) {
              setState(() {
                selectedValue = value;
                widget.onChanged(value);
              });
            },
            buttonStyleData: ButtonStyleData(
              height: 50,
              width: 160,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.black26,
                ),
                color: appTheme.primaryColor,
              ),
              elevation: 2,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              iconSize: 14,
              iconEnabledColor: Colors.white,
              iconDisabledColor: Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: appTheme.primaryColor,
              ),
              offset: const Offset(-20, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        );
      //);
   // );
  }
}




class DropdownCommon2 extends StatefulWidget {
  const DropdownCommon2({Key? key, required this.list, required this.onChanged})
      : super(key: key);
  final List<String> list;
  final Function onChanged;


  @override
  State<DropdownCommon2> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownCommon2> {

  String? dropdownValue;


  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) widget.list.add("None");
    //dropdownValue ;
    return DropdownButton<String>(
      value: dropdownValue ?? widget.list.first,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
       //   print("da chon${value}");
          dropdownValue = value!;
           widget.onChanged(value);
        });
      },
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
            border: Border.all(
            color: Colors.green,
           // width: 8,
        ), //Border.al/
        ),
        child:Text(value)

        ));
        }).toList(),
    );
  }
}

class Sport {
  final int id;
  final String name;

  Sport({
    required this.id,
    required this.name,
  });
}

class MultiSelectDropdownCommon extends StatefulWidget {

  final String title;

  const MultiSelectDropdownCommon({Key? key, required this.title})
      : super(key: key);

  @override
  MultiSelectDropdownCommonState createState() =>
      MultiSelectDropdownCommonState();
}

class MultiSelectDropdownCommonState extends State<MultiSelectDropdownCommon> {
  static final List<Sport> _sports = [
    Sport(id: 1, name: "Run"),
    Sport(id: 2, name: "Swimming"),
    Sport(id: 3, name: "Tennis"),
    Sport(id: 4, name: "Football"),
    Sport(id: 5, name: "Climbing"),
    Sport(id: 6, name: "Walking"),
    Sport(id: 7, name: "Marathon"),
    Sport(id: 8, name: "Chess"),
  ];
  final _items = _sports
      .map((sport) => MultiSelectItem<Sport>(sport, sport.name))
      .toList();

  //List<Sport> _selectedAnimals = [];
// final  List<Sport> _selectedAnimals2 = [];
// final List<Sport> _selectedAnimals3 = [];
  //List<Animal> _selectedAnimals4 = [];
  // List<Sport> _selectedAnimals5 = [];
  // final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    // _selectedAnimals5 = _sports;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          //################################################################################################
          // Rounded blue MultiSelectDialogField
          //################################################################################################
          MultiSelectDialogField(
            items: _items,
            title: const Text("Sports"),
            selectedColor: Colors.green,
            decoration: BoxDecoration(
              color: appTheme.dialogBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(
                color: Colors.green,
                width: 2,
              ),
            ),
            buttonIcon: Icon(
                Icons.arrow_drop_down,
                color: appTheme.primaryColor //Colors.blue,
            ),
            buttonText: Text(
              widget.title,
              style: TextStyle(
                color: appTheme.primaryColor,
                fontSize: 16,
              ),
            ),
            onConfirm: (List<Sport> results) {
              //_selectedAnimals = results;
            },
          ),

        ],
      ),
    );
  }
}