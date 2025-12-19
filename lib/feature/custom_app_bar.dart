import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final int streak; // Fallback value
  final String avatarPath;

  const CustomAppBar({
    Key? key,
    required this.username,
    required this.streak,
    required this.avatarPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentFirebaseUser = FirebaseAuth.instance.currentUser;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 28),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, $username",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Kiranya kasih karunia Tuhan\nmenyertai Anda hari ini.",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.local_fire_department,
              color: Colors.amber,
              size: 31,
            ),
            const SizedBox(width: 4),
            // Real-time Streak from Firebase
            currentFirebaseUser != null
                ? StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentFirebaseUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.exists) {
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final realtimeStreak = data['streak'] ?? 0;
                        return Text(
                          '$realtimeStreak',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        );
                      }
                      // Fallback to provided streak
                      return Text(
                        '$streak',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      );
                    },
                  )
                : Text(
                    '$streak',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
            const SizedBox(width: 12),
            const CircleAvatar(
              radius: 25,
              backgroundColor: Color.fromARGB(255, 170, 170, 170),
              child: Icon(Icons.person, size: 35, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(127);
}