import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow ;
import 'package:comp_vis_project/styles/customBtnStyle.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class CustomCardButton3 extends StatelessWidget{
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

  const CustomCardButton3({
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Card(
        color: Colors.transparent,
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0,
        child: Container(
          width: (width ?? 100).toDouble(),
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: bgColor ?? const Color(0xFFFFFFFF),
            boxShadow: Custombtnstyle.appearButton,
            
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              shadowTitle ? 
                  DefaultTextStyle.merge(
                    style: const TextStyle(
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
              if (subtitle != null) Text(
                subtitle!, 
                style: TextStyle(
                  color: textColor ?? const Color(0xFFFFFFFF),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  shadows: shadowTitle ? [
                    const Shadow(
                      blurRadius: 10.0,
                      color: Color.fromARGB(119, 0, 0, 0),
                      offset: Offset(2.0, 2.0),
                    )
                  ] 
                  : null,
                ),
              ), 
            ],
          ),
        ),
      ),
    );
  }
}
