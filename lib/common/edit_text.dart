import 'package:elabv01/common/theme.dart';
import 'package:flutter/material.dart';

class TextCommon extends StatelessWidget {
  const TextCommon(
      {Key? key,
      this.label,
      this.hintText,
      this.textEditingController,
      this.margin})
      : super(key: key);
  final String? label;
  final String? hintText;
  final TextEditingController? textEditingController;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (margin != null)
          ? EdgeInsets.fromLTRB(
              margin!.left, margin!.top, margin!.right, margin!.bottom)
          : EdgeInsets.zero,
      child: Column(
        children: [
          if (label != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  label!,
                  textAlign: TextAlign.start,
                  style: appTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          TextFormField(
            decoration: InputDecoration(
                hintText: (hintText != null) ? hintText : null,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.blue)),
                fillColor: Colors.white,// appTheme.dialogBackgroundColor,
                filled: true),
            controller: textEditingController,
            keyboardType: TextInputType.multiline,
            minLines: 1,//Normal textInputField will be displayed
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}

class TextOval extends StatelessWidget {
  const TextOval(
      {Key? key, this.icon,
      this.label,
      this.hintText,
      this.textEditingController,
      this.margin})
      : super(key: key);
  final String? label;
  final String? hintText;
  final Icon? icon;
  final TextEditingController? textEditingController;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (margin != null)
          ? EdgeInsets.fromLTRB(
              margin!.left, margin!.top, margin!.right, margin!.bottom)
          : EdgeInsets.zero,
      child:
          Row(
        children: [
          Flexible(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: appTheme.primaryColorDark,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextFormField(

                  controller: textEditingController,
                  autofillHints: const [AutofillHints.email],
                 // onEditingComplete: ()=>TextInput.finishAutofillContext(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: icon,
                      hintText: label,),

                  onChanged: (value){
                    //user.username=value;
                  },
              //    validator: (value) {
                    // if (value.isEmpty) {
                    //   return 'Please enter username';
                    // }
                  //  return null;
              //    },

                ),
              ),)
        ],
      ),
      // ),
    );
  }
}
