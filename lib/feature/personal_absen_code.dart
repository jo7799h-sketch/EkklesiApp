// =====================================================
// FILE 2: personal_absen_code.dart - Real-Time Attendance
// =====================================================

import 'package:comp_vis_project/model_data.dart';
import 'package:comp_vis_project/pages/guest_restriction_page.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalAbsenCode extends StatefulWidget {
  const PersonalAbsenCode({super.key});

  @override
  State<PersonalAbsenCode> createState() => _PersonalAbsenCodeState();
}

class _PersonalAbsenCodeState extends State<PersonalAbsenCode> {
  String? userUID;
  bool _hasShownToast = false;

  @override
  void initState() {
    super.initState();
    _getUserUID();
  }

  void _getUserUID() {
    final currentFirebaseUser = FirebaseAuth.instance.currentUser;
    if (currentFirebaseUser != null) {
      setState(() {
        userUID = currentFirebaseUser.uid;
      });
    }
  }

  String _getCurrentEventId() {
    final now = DateTime.now();
    final datePart =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    const timePart = "07.00";
    return "$datePart/$timePart";
  }

  void _showSnackBar(String message, Color color) {
    if (_hasShownToast) return;

    _hasShownToast = true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : Icons.info,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    // Reset flag setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      _hasShownToast = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is guest
    if (isGuestMode || currentUser == null) {
      return const GuestRestrictionPage(featureName: 'Absensi QR');
    }

    // Check if Firebase user exists
    final currentFirebaseUser = FirebaseAuth.instance.currentUser;
    if (currentFirebaseUser == null) {
      return const GuestRestrictionPage(featureName: 'Absensi QR');
    }

    // Loading state
    if (userUID == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Personal QR Code Absen"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentEventId = _getCurrentEventId();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal QR Code Absen"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(userUID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    "Data user tidak ditemukan",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "UID: $userUID",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!.data()!;
          final lastEventRecorded = data["lastEvent"];
          final userName = data["name"] ?? "User";
          final streak = data["streak"] ?? 0;
          final exp = data["exp"] ?? 0;
          final attended = lastEventRecorded == currentEventId;

          // Show toast when attendance is marked (real-time)
          if (attended && !_hasShownToast) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showSnackBar("✓ Anda Berhasil Terabsen!", Colors.green);
            });
          }

          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: attended ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            attended ? Icons.check_circle : Icons.pending,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            attended ? "Sudah Terabsen" : "Belum Terabsen",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Instructions
                    const Text(
                      "Tolong perlihatkan QR ini\nke penjaga pintu yang bertugas.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Terima Kasih",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // User Info
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatChip(
                          icon: Icons.local_fire_department,
                          label: "Streak",
                          value: streak.toString(),
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 12),
                        _buildStatChip(
                          icon: Icons.star,
                          label: "Exp",
                          value: exp.toString(),
                          color: Colors.amber,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // QR Code
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 250,
                            height: 250,
                            child: PrettyQrView.data(
                              data: userUID!,
                              decoration: const PrettyQrDecoration(
                                shape: PrettyQrSmoothSymbol(),
                              ),
                              errorCorrectLevel: QrErrorCorrectLevel.H,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "ID: ${userUID!.substring(0, 8)}...",
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info Text
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "QR Code ini berlaku untuk event hari ini (${currentEventId.split('/')[0]})",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}