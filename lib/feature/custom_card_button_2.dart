// import 'dart:ffi';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow ;
import 'package:comp_vis_project/styles/customBtnStyle.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class CustomCardButton2 extends StatelessWidget{
  final Widget title;
  final num? fontSize;
  final Color? bgColor;
  final Color? textColor;
  final String? subtitle;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? iconColor;
  final num? width;
  final bool shadowTitle;
  final bool shadowSubtitle;

  const CustomCardButton2({
    Key? key,
    required this.title,
    required this.shadowTitle,
    required this.shadowSubtitle,
    this.fontSize,
    this.bgColor,
    this.textColor,
    this.subtitle,
    this.onTap,
    this.icon,
    this.iconColor,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      child: Container(
        width: (width ?? 18).toDouble(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: bgColor ?? const Color(0xFFFFFFFF),
          boxShadow: Custombtnstyle.appearButton
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 16,
          ),
          
          leading: icon != null 
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(icon, color: iconColor ?? Colors.white),
                )
              : null,
          title: shadowTitle ? 
                DefaultTextStyle.merge(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor ?? const Color(0xFFFFFFFF),
                    shadows: [
                      const Shadow(
                        blurRadius: 10.0,
                        color: Color.fromARGB(119, 0, 0, 0),
                        offset: Offset(2.0, 2.0),
                      )
                    ],
                  ), 
                  child: title
                )
            : title,
          subtitle: subtitle != null ? Text(
            subtitle!, 
            style: TextStyle(
              color: textColor ?? const Color(0xFFFFFFFF),
              shadows: shadowTitle ? [
                const Shadow(
                  blurRadius: 10.0,
                  color: Color.fromARGB(119, 0, 0, 0),
                  offset: Offset(2.0, 2.0),
                )
              ] : null,
            ),
          ) 
          : null,
          // trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        )
      )
    );
  }
}