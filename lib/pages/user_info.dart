import 'package:flutter/material.dart';
import 'package:comp_vis_project/model_data.dart';
import 'package:comp_vis_project/pages/edit_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoPage extends StatelessWidget {
  final UserProfile user;

  const UserInfoPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final currentFirebaseUser = FirebaseAuth.instance.currentUser;

    if (currentFirebaseUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Informasi Pengguna")),
        body: const Center(
          child: Text("User tidak ditemukan"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Informasi Pengguna"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Get latest data from Firebase before editing
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentFirebaseUser.uid)
                  .get();

              if (userDoc.exists) {
                final data = userDoc.data()!;
                final latestUser = UserProfile(
                  fullName: data['name'] ?? user.fullName,
                  age: data['age'] ?? user.age,
                  address: data['address'] ?? user.address,
                  phone: data['phone'] ?? user.phone,
                  email: data['email'] ?? user.email,
                  dob: data['dob'] ?? user.dob,
                  personalToken: currentFirebaseUser.uid,
                  exp: data['exp'] ?? user.exp,
                  streak: data['streak'] ?? user.streak,
                  counter: data['counter'] ?? user.counter,
                );

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditUserInfo(user: latestUser),
                  ),
                );

                // No need to setState as StreamBuilder will auto-update
                if (result != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Data berhasil diperbarui!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentFirebaseUser.uid)
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
          final userEmail = data['email'] ?? '';
          final userAge = data['age'] ?? 0;
          final userAddress = data['address'] ?? '';
          final userPhone = data['phone'] ?? '';
          final userDob = data['dob'] ?? '';
          final streak = data['streak'] ?? 0;
          final exp = data['exp'] ?? 0;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Color.fromARGB(255, 170, 170, 170),
                    child: Icon(Icons.person, size: 70, color: Colors.white),
                  ),
                  const SizedBox(height: 24),

                  // Stats Card - Real-time from Firebase
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.blue[50],
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
                  const SizedBox(height: 32),

                  // User Information Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Informasi Pribadi",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                            icon: Icons.person,
                            label: "Nama Lengkap",
                            value: userName,
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            icon: Icons.cake,
                            label: "Umur",
                            value: "$userAge tahun",
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            icon: Icons.calendar_today,
                            label: "Tanggal Lahir",
                            value: userDob.isNotEmpty ? userDob : "-",
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            icon: Icons.email,
                            label: "Email",
                            value: userEmail,
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            icon: Icons.phone,
                            label: "No. Telepon",
                            value: userPhone.isNotEmpty ? userPhone : "-",
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            icon: Icons.home,
                            label: "Alamat",
                            value: userAddress.isNotEmpty ? userAddress : "-",
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Edit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final latestUser = UserProfile(
                          fullName: userName,
                          age: userAge,
                          address: userAddress,
                          phone: userPhone,
                          email: userEmail,
                          dob: userDob,
                          personalToken: currentFirebaseUser.uid,
                          exp: exp,
                          streak: streak,
                          counter: 0,
                        );

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditUserInfo(user: latestUser),
                          ),
                        );

                        if (result != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Data berhasil diperbarui!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Informasi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.teal, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}