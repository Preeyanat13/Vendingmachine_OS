import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/product.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  final List<CartItem> cart;
  final VoidCallback onUpdate;
  final VoidCallback onClearPurchased;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.onAdd,
    required this.cart,
    required this.onUpdate,
    required this.onClearPurchased,
  });

  Future<void> _handleAdd(BuildContext context) async {
    final purchasedCount = cart.fold<int>(0, (sum, item) => sum + item.qty);

    if (purchasedCount >= 1) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 400);
      }
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/alert.mp3'));

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text("แจ้งเตือน", style: TextStyle(color: Colors.red)),
            ],
          ),
          content: const Text("คุณซื้อของได้ทีละชิ้นเท่านั้น ไม่สามารถซื้อสินค้าเพิ่มได้"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("แก้ไขสินค้า"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartPage(
                      cart: cart,
                      onUpdate: onUpdate,
                      onClearPurchased: onClearPurchased,
                      onRemoveFromPurchased: (product) {},
                    ),
                  ),
                );
              },
              child: const Text("ชำระเงิน"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700], 
              ),
            ),
          ],
        ),
      );
      return;
    }

    onAdd();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.blue[200], 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (product.imageAsset.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 255, 255, 255), 
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  product.imageAsset,
                  width: 380,
                  height: 380,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(height: 16),
            Text('ชื่อสินค้า: ${product.name}', style: const TextStyle(fontSize: 18, color: Colors.black)),
            Text('ราคา: ${product.price.toStringAsFixed(0)} บาท', style: const TextStyle(fontSize: 18, color: Colors.black)),
            Text('คงเหลือ: ${product.stock}', style: const TextStyle(fontSize: 18, color: Colors.black)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: product.stock > 0 ? () => _handleAdd(context) : null,
                icon: const Icon(Icons.add_shopping_cart, color: Colors.black),
                label: const Text('กดรับ', style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700], 
                  padding: const EdgeInsets.symmetric(vertical: 12),
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
  }
}
