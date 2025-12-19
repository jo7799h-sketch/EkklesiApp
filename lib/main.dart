// =====================================================
// FILE: main.dart - Fixed with proper imports
// =====================================================
import 'package:comp_vis_project/feature/custom_app_bar.dart';
import 'package:comp_vis_project/feature/custom_card_button_2.dart';
import 'package:comp_vis_project/feature/personal_absen_code.dart';
import 'package:comp_vis_project/feature/sorting_data_helper.dart';
import 'package:comp_vis_project/pages/detail_khotbah.dart';
import 'package:comp_vis_project/pages/login_page.dart';
import 'package:comp_vis_project/pages/persembahan.dart';
import 'package:comp_vis_project/pages/qr_scanner.dart';
import 'package:comp_vis_project/pages/warta_gereja.dart';
import 'package:comp_vis_project/pages/guest_restriction_page.dart';
import 'package:comp_vis_project/styles/customBtnStyle.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:comp_vis_project/model_data.dart';
import 'package:comp_vis_project/pages/halaman_khotbah.dart';
import 'package:comp_vis_project/pages/profile_page.dart';
import 'package:comp_vis_project/pages/halaman_warta.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:comp_vis_project/feature/custom_card_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan import ini
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomePage(),
      title: 'EkklesiApp',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white24,
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
      ),
      initialRoute: "/login",
      routes: {
        "/login": (context) => const WelcomePage(),
        "/main": (context) => const MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUser;

    final pages = [
      const HomePage(),
      const HalamanKhotbah(),
      const HalamanWarta(),
      user == null ? ProfilePage(user: null) : ProfilePage(user: user),
    ];

    return Scaffold(
      appBar: _selectedIndex == 3
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(127),
              child: CustomAppBar(
                username: isGuestMode
                    ? (guestName ?? 'Guest')
                    : isAdmin
                        ? '${user?.fullName ?? 'Guest'} 👑' // ← Admin badge
                        : (user?.fullName ?? 'Guest'),
                streak: isGuestMode ? 0 : (user?.streak ?? 0),
                avatarPath: "assets/images/Castorice_Maid.png",
              ),
            ),
      body: Stack(
        children: [
          pages[_selectedIndex],
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              width: 300,
              height: 70,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 247, 247, 247),
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                boxShadow: Custombtnstyle.appearButton,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.transparent,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.book), label: 'Khotbah'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.article), label: 'Warta'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.person), label: 'Profil'),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.black,
                    unselectedItemColor: Colors.white,
                    onTap: _onItemTapped,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCongregationCounterCard(context),
              const SizedBox(height: 20),
              _buildActionButtons(context),
              const SizedBox(height: 24),
              _buildRecentSermons(context),
              const SizedBox(height: 10),
              _buildWartaGereja(context),
              const SizedBox(height: kBottomNavigationBarHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCongregationCounterCard(BuildContext context) {
    // Get current event ID untuk filter attendance hari ini
    String getCurrentEventId() {
      final now = DateTime.now();
      final datePart =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      const timePart = "07.00";
      return "$datePart/$timePart";
    }

    final currentEventId = getCurrentEventId();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Image.asset(
              'assets/images/church.png',
              width: 640,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 56),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Real-time congregation counter from Firebase
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('lastEvent', isEqualTo: currentEventId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        int attendanceCount = 0;

                        if (snapshot.hasData) {
                          attendanceCount = snapshot.data!.docs.length;
                        }

                        return Text(
                          "$attendanceCount Jemaat",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC6C6C6),
                          ),
                        );
                      },
                    ),
                    const Text(
                      "Jumlah Kehadiran Saat Ini",
                      style: TextStyle(color: Color(0xFF8E8E8E)),
                    ),
                    const SizedBox(height: 20),
                    CustomCardButton2(
                      title: const Text('Absensi QR'),
                      width: 180,
                      shadowTitle: true,
                      shadowSubtitle: false,
                      icon: Icons.qr_code_scanner,
                      iconColor: Colors.black,
                      bgColor: const Color.fromARGB(255, 247, 247, 247),
                      textColor: Colors.black,
                      onTap: () {
                        // Check if guest mode
                        if (isGuestMode || currentUser == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GuestRestrictionPage(
                                featureName: 'Absensi QR',
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PersonalAbsenCode(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: CustomCardButton2(
            title: Text('QR Scanner'),
            shadowTitle: true,
            shadowSubtitle: false,
            bgColor: const Color(0xFFFA8181),
            textColor: const Color(0xFFFFFFFF),
            icon: Icons.qr_code_scanner,
            onTap: () {
              // Check if guest mode - let QrScanner handle admin check
              if (isGuestMode || currentUser == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GuestRestrictionPage(
                      featureName: 'QR Scanner',
                    ),
                  ),
                );
              } else {
                // Navigate to QrScanner - it will handle admin check internally
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => QrScanner()),
                );
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomCardButton2(
            title: Text('Persembahan'),
            shadowTitle: true,
            shadowSubtitle: false,
            fontSize: 16,
            bgColor: const Color(0xFFC6E068),
            textColor: const Color(0xFFFFFFFF),
            icon: Icons.card_giftcard,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Persembahan()),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildRecentSermons(BuildContext context) {
    final latestSermons = getLatestToLongestSermons(limit: 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 19),
          child: const Text(
            "Kotbah Terbaru",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final sermon = latestSermons[index];
            return CustomCardButton(
              title: sermon.title,
              subtitle:
                  "${sermon.preacher}\n${sermon.date.day}/${sermon.date.month}/${sermon.date.year}",
              icon: AppIcons.sermon,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKhotbah(sermon: sermon),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildWartaGereja(BuildContext context) {
    final longestWarta = getLongestToLatestWarta(limit: 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 19),
          child: const Text(
            "Warta Gereja",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final warta = longestWarta[index];
            return CustomCardButton(
              title: warta.title,
              subtitle:
                  "${warta.preacher}\n${warta.date.day}/${warta.date.month}/${warta.date.year}",
              icon: AppIcons.warta,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WartaGereja(warta: warta),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
