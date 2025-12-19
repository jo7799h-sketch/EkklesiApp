import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

bool isGuestMode = false;
String? guestName;

// Admin system
bool isAdmin = false;
const String ADMIN_EMAIL = 'ekklesia.app1@gmail.com';



class AppIcons {
  static const IconData warta = Icons.book;
  static const IconData sermon = Icons.article;
}

class Warta {
  final String title;
  final String preacher;
  final DateTime date;
  final String content;

  Warta({
    required this.title,
    required this.preacher,
    required this.date,
    required this.content,
  });
}

// Data Dummy Warta untuk UI
final List<Warta> dummyWarta = [
  Warta(
    title: "Ibadah Yom Kippur",
    preacher: "Ps. Victor Purnomo",
    date: DateTime.now().add(const Duration(days: 7)),
    content:
        "Mari kita merayakan salah satu Harinya Tuhan, Yom Kippur, pada tanggal 22 Septermber 2025, pukul 17.00 WIB - selesai.",
  ),
  Warta(
    title: "Ibadah Natal",
    preacher: "Pdt. Michael Wijaya",
    date: DateTime.now().add(const Duration(days: 14)),
    content:
        "Natal akan tiba! Kita rayakan hari lahirnya Tuhan Yesus ke dunia. Catat tanggalnya, 24 Desember 2025, pukul 18.00 WIB - selesai",
  ),
  Warta(
    title: "Ibadah Tahun Baru",
    preacher: "Ev. Maria Grace",
    date: DateTime.now().add(const Duration(days: 21)),
    content:
        "Tahun lama akan berakhir dan tahun yang baru akan tiba. Nantikanlah Ibadah Tahun Baru, mari kita menyambut tahun yang penuh harapan dengan bersukacita dan tetap berjalanlah bersama Tuhan.",
  ),
];

// Model data sederhana untuk Kotbah dan Pengguna
class Sermon {
  final String title;
  final String preacher;
  final DateTime date;
  final String summary;

  Sermon({
    required this.title,
    required this.preacher,
    required this.date,
    required this.summary,
  });
}

// Data Dummy untuk UI
final List<Sermon> dummySermons = [
  Sermon(
    title: "Kasih yang Memulihkan",
    preacher: "Pdt. Abraham Santoso",
    date: DateTime.now().subtract(const Duration(days: 7)),
    summary:
        "Kotbah minggu ini membahas bagaimana kasih Tuhan dapat memulihkan setiap luka dan kepahitan. Berdasarkan ayat dari 1 Korintus 13, kita belajar tentang sifat-sifat kasih yang sejati...",
  ),
  Sermon(
    title: "Harapan di Tengah Badai",
    preacher: "Pdt. Michael Wijaya",
    date: DateTime.now().subtract(const Duration(days: 14)),
    summary:
        "Ketika badai kehidupan datang, di manakah kita menaruh harapan? Mari kita belajar dari kisah Nuh tentang bagaimana iman dan ketaatan membawa pada keselamatan dan harapan baru.",
  ),
  Sermon(
    title: "Menjadi Garam dan Terang Dunia",
    preacher: "Ev. Maria Grace",
    date: DateTime.now().subtract(const Duration(days: 21)),
    summary:
        "Yesus memanggil kita untuk menjadi garam yang memberi rasa dan terang yang menerangi kegelapan. Apa artinya panggilan ini dalam kehidupan kita sehari-hari di kantor, kampus, dan keluarga?",
  ),
];

class UserProfile {
  String fullName;
  String dob;
  int age;
  String address;
  String email;
  String phone;
  int exp;
  int streak;
  String personalToken;
  int counter;

  UserProfile({
    required this.fullName,
    required this.dob, // tambahkan ini
    required this.age,
    required this.address,
    required this.email,
    required this.phone,
    this.exp = 0,
    this.streak = 0,
    required this.personalToken,
    this.counter = 0,
  });
}

// BAGIAN INI DATA DUMMY USER
// final UserProfile dummyUser = UserProfile(
//   fullName: "Budi Setiawan",
//   dob: "2000-01-01",
//   age: 25,
//   address: "Jl. Mawar No. 123",
//   email: "budi.setiawan@email.com",
//   phone: "081234567890",
//   exp: 0,
//   streak: 0,
//   personalToken: "userTokenABC",
//   counter: 0,
// );

// Flag user login (null kalau belum login). BAGIAN INI UNTUK TES USER SDH LOGIN ATAU BLM
UserProfile? currentUser = null;