import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow ;
import 'package:comp_vis_project/styles/customBtnStyle.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class CustomCardButton extends StatelessWidget{
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData? icon;

  const CustomCardButton({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
          boxShadow: Custombtnstyle.neumorphicShadows
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          
          leading: icon != null 
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(icon, color: Colors.black),
                )
              : null,
          title: Text(
            title, 
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        )
      )
    );
  }
}