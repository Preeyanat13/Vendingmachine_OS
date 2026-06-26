import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    if (!kIsWeb) _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("th-TH");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speak() async {
    const message =
        "ตู้กดของใช้ในชีวิตประจำวันพร้อมใช้งานแล้ว หากต้องการซื้อสินค้า กรุณากดปุ่มซื้อสินค้า";

    if (kIsWeb) {
      final utterance = html.SpeechSynthesisUtterance(message);
      utterance.lang = "th-TH";
      html.window.speechSynthesis?.speak(utterance);
    } else {
      await flutterTts.speak(message);
    }
  }

  void goToShop(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSlot(IconData icon, String label) {
    return Container(
      width: 70,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.orange),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                "ตู้กดของใช้ในชีวิตประจำวัน",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 280,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueAccent, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: BlinkingLightsPainter(_controller.value),
                        );
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSlot(Icons.cleaning_services, "แปรงสีฟัน"),
                          _buildSlot(Icons.face, "โฟมล้างหน้า"),
                          _buildSlot(Icons.soap, "สบู่"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSlot(Icons.power, "ปลั๊กไฟ"),
                          _buildSlot(Icons.charging_station, "สายชาร์จ"),
                          _buildSlot(Icons.headset, "หูฟัง"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSlot(Icons.cleaning_services, "สำลี"),
                          _buildSlot(Icons.cut, "มีดโกน"),
                          _buildSlot(Icons.favorite, "ลิปมัน"),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => goToShop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 6,
                        ),
                        child: const Text(
                          "🛒 ซื้อสินค้า",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: _speak,
                        icon: const Icon(Icons.volume_up, color: Colors.orange),
                        label: const Text(
                          "ฟังเสียง",
                          style: TextStyle(color: Colors.orange, fontSize: 16),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlinkingLightsPainter extends CustomPainter {
  final double progress;
  BlinkingLightsPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final radius = 6.0;
    final colors = [Colors.orange, Colors.yellow, Colors.cyan];

    for (int i = 0; i < 20; i++) {
      final angle = (2 * math.pi * i / 20) + (progress * 2 * math.pi);
      final x = size.width / 2 + (size.width / 2 - 10) * math.cos(angle);
      final y = size.height / 2 + (size.height / 2 - 10) * math.sin(angle);
      paint.color = colors[i % colors.length].withOpacity(0.8);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BlinkingLightsPainter oldDelegate) => true;
}
