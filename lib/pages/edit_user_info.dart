import 'package:flutter/material.dart';
import 'package:comp_vis_project/model_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditUserInfo extends StatefulWidget {
  final UserProfile user;

  const EditUserInfo({super.key, required this.user});

  @override
  State<EditUserInfo> createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfo> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.fullName);
    ageController = TextEditingController(text: widget.user.age.toString());
    addressController = TextEditingController(text: widget.user.address);
    phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    // Validate input
    if (nameController.text.trim().isEmpty) {
      _showSnackBar("Nama tidak boleh kosong", Colors.red);
      return;
    }

    final age = int.tryParse(ageController.text);
    if (age == null || age < 1 || age > 150) {
      _showSnackBar("Umur tidak valid", Colors.red);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final currentFirebaseUser = FirebaseAuth.instance.currentUser;

      if (currentFirebaseUser == null) {
        _showSnackBar("User tidak ditemukan", Colors.red);
        return;
      }

      // Update to Firebase
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentFirebaseUser.uid)
          .update({
        "name": nameController.text.trim(),
        "age": age,
        "address": addressController.text.trim(),
        "phone": phoneController.text.trim(),
        "updatedAt": FieldValue.serverTimestamp(),
      });

      // Create updated user profile to pass back
      final updatedUser = UserProfile(
        fullName: nameController.text.trim(),
        age: age,
        address: addressController.text.trim(),
        phone: phoneController.text.trim(),
        email: widget.user.email,
        dob: widget.user.dob,
        personalToken: widget.user.personalToken,
        exp: widget.user.exp,
        streak: widget.user.streak,
        counter: widget.user.counter,
      );

      // Update global currentUser if needed
      if (currentUser != null) {
        currentUser = updatedUser;
      }

      _showSnackBar("Perubahan berhasil disimpan!", Colors.green);

      // Wait a bit to show snackbar, then pop
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pop(context, updatedUser);
      }
    } catch (e) {
      print('Error saving changes: $e');
      _showSnackBar("Terjadi kesalahan: $e", Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _cancelChanges() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Informasi Pengguna")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Umur",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.cake),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "Alamat",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: widget.user.email),
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: "Email (tidak bisa diubah)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "No. Telepon",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveChanges,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(_isSaving ? "Menyimpan..." : "Simpan"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _cancelChanges,
                        icon: const Icon(Icons.cancel),
                        label: const Text("Batalkan"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Loading overlay
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          "Menyimpan perubahan...",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}