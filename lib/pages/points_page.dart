import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'landing_page.dart';

class PointsPage extends StatefulWidget {
  final String phoneNumber;
  const PointsPage({super.key, required this.phoneNumber});

  @override
  State<PointsPage> createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  int points = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    final doc = FirebaseFirestore.instance.collection('points').doc(widget.phoneNumber);
    final snapshot = await doc.get();

    if (snapshot.exists && snapshot.data()!.containsKey('points')) {
      setState(() {
        points = snapshot['points'];
        loading = false;
      });
    } else {
      await doc.set({'points': 0});
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("คะแนนสะสม"),
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator(color: Colors.blueAccent)
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 80),
                    const SizedBox(height: 20),
                    Text(
                      "เบอร์โทรศัพท์: ${widget.phoneNumber}",
                      style: const TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "คะแนนสะสมทั้งหมด",
                      style: const TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                    Text(
                      "$points คะแนน",
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LandingPage()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home),
                      label: const Text("กลับหน้าแรก", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
