import 'package:flutter/material.dart';

class ButtonCommon extends StatelessWidget {
  final String label;
  final Function onTap;
  final IconData? icon;
  final Color color;

  final double padding;
  final Color? backgroundColor;

  const ButtonCommon(
      {Key? key,
      required this.label,
      required this.onTap,
      this.icon,
      required this.color,
      required this.padding,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(padding),
        child: InkWell(
          onTap: () async {
            onTap();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (backgroundColor ?? const Color(0xFF0F0BDB)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (icon!= null) Icon(icon, color: color),
              ],
            ),
          ),
        ));
  }
}

//
