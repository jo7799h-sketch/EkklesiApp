import 'package:flutter/material.dart';
import 'package:comp_vis_project/model_data.dart';
import 'package:comp_vis_project/pages/login_page.dart';
import 'package:comp_vis_project/pages/user_info.dart'; // Tambahkan import ini
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final UserProfile? user;

  const ProfilePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final currentFirebaseUser = FirebaseAuth.instance.currentUser;
    final isGuest = isGuestMode || currentFirebaseUser == null;

    return Scaffold(
      body: SafeArea(
        child: isGuest
            ? _buildGuestProfile(context)
            : _buildUserProfile(context, currentFirebaseUser),
      ),
    );
  }

  

  Widget _buildGuestProfile(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 100, color: Colors.grey),
            const SizedBox(height: 24),
            Text(
              "Halo, ${guestName ?? 'Guest'}!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "Anda sedang menggunakan mode Guest.\nLogin untuk menikmati fitur lengkap!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomePage()),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text("Login Sekarang"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, User firebaseUser) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
            child: Text(
              "Data pengguna tidak ditemukan",
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final userName = data['name'] ?? 'User';
        final userEmail = data['email'] ?? firebaseUser.email ?? '';
        final streak = data['streak'] ?? 0;
        final exp = data['exp'] ?? 0;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Profile Header
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Color.fromARGB(255, 170, 170, 170),
                  child: Icon(Icons.person, size: 70, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userEmail,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Card - Real-time
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          icon: Icons.local_fire_department,
                          label: "Streak",
                          value: "$streak",
                          color: Colors.orange,
                        ),
                        Container(
                          height: 50,
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        _buildStatItem(
                          icon: Icons.star,
                          label: "Experience",
                          value: "$exp",
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Menu Items
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: "Informasi Pengguna",
                  onTap: () {
                    // Create UserProfile object from Firebase data
                    final userProfile = UserProfile(
                      fullName: userName,
                      age: data['age'] ?? 0,
                      address: data['address'] ?? '',
                      phone: data['phone'] ?? '',
                      email: userEmail,
                      dob: data['dob'] ?? '',
                      personalToken: firebaseUser.uid,
                      exp: exp,
                      streak: streak,
                      counter: data['counter'] ?? 0,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserInfoPage(user: userProfile),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.settings,
                  title: "Pengaturan",
                  onTap: () {
                    // TODO: Navigate to settings
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: "Bantuan",
                  onTap: () {
                    // TODO: Navigate to help
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildMenuItem(
                  context,
                  icon: Icons.logout,
                  title: "Keluar",
                  color: Colors.red,
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    currentUser = null;
                    isGuestMode = false;
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const WelcomePage()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 36),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.black),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color ?? Colors.black,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.grey[100],
      ),
    );
  }
}