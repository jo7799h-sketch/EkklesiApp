import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow ;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class Custombtnstyle {
  static List<BoxShadow> neumorphicShadows = [
    BoxShadow(
      color: Colors.white,
      // spreadRadius: 1,
      blurRadius: 50,
      offset: Offset(-6, -5),
      // offset: const Offset(-4, -4),
      // inset: false, // kalau mau efek "cekung" bisa true
    ),
    BoxShadow(
      color: Colors.white,
      // spreadRadius: 1,
      blurRadius: 30,
      offset: Offset(28, 28),
      // offset: const Offset(-4, -4),
      inset: true, // kalau mau efek "cekung" bisa true
    ),
    BoxShadow(
      color: Colors.black54,
      // spreadRadius: 1,
      blurRadius: 30,
      offset: Offset(2, 19),
      inset: true
    ),
    BoxShadow(
      color: Colors.grey.shade300, // abu-abu lembut
      blurRadius: 25,
      offset: Offset(8, 8), // arah kanan bawah
    ),
  ];

  static List<BoxShadow> appearButton = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      spreadRadius: 0,
      blurRadius: 20,
      offset: Offset(0, 10),
    ),
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.2),
      spreadRadius: 0,
      blurRadius: 10,
      offset: Offset(0, -5),
      // offset: const Offset(-4, -4),
      // inset: true, // kalau mau efek "cekung" bisa true
    ),
    BoxShadow(
      color: Color(0xA254059).withValues(alpha: 0.35),
      inset: true,
      offset: Offset(-1, 1),
      blurRadius: 10,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black54,
      inset: true,
      offset: Offset(1, -5),
      blurRadius: 10,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black54,
      inset: true,
      offset: Offset(-1, 1),
      blurRadius: 10,
      spreadRadius: 0,
    )
  ];
}