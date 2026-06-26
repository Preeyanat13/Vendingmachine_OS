import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'landing_page.dart';
import 'points_page.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cart;
  final VoidCallback onUpdate;
  final VoidCallback onClearPurchased;
  final Function(Product) onRemoveFromPurchased;

  const CartPage({
    super.key,
    required this.cart,
    required this.onUpdate,
    required this.onClearPurchased,
    required this.onRemoveFromPurchased,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double insertedAmount = 0;

  double get total =>
      widget.cart.fold(0, (sum, item) => sum + (item.product.price * item.qty));

  
  void showPhoneDialog() {
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.blue[50],
        title: const Text("📱 สะสมคะแนน", style: TextStyle(color: Colors.black87)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "กรุณากรอกเบอร์โทรศัพท์เพื่อสะสมคะแนนสมาชิก",
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: "เบอร์โทรศัพท์",
                hintText: "เช่น 0812345678",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.cart.clear();
              widget.onUpdate();
              widget.onClearPurchased();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LandingPage()),
                (route) => false,
              );
            },
            child: const Text("ข้าม", style: TextStyle(color: Colors.black87)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (phoneController.text.length < 9) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }

              final phone = phoneController.text.trim();

              
              final doc = FirebaseFirestore.instance.collection('points').doc(phone);
              final snapshot = await doc.get();
              if (snapshot.exists) {
                await doc.update({'points': snapshot['points'] + 10});
              } else {
                await doc.set({'points': 10});
              }

              Navigator.pop(ctx);
              widget.cart.clear();
              widget.onUpdate();
              widget.onClearPurchased();

              
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => PointsPage(phoneNumber: phone),
                ),
                (route) => false,
              );
            },
            child: const Text("ยืนยัน"),
          ),
        ],
      ),
    );
  }

  
  void completePayment() {
    Future.delayed(const Duration(seconds: 2), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text("🎉 ชำระเงินเรียบร้อยแล้ว",
              style: TextStyle(color: Colors.black87)),
          content: const Text("รับสินค้าได้เลย ขอบคุณที่ใช้บริการ 🙏",
              style: TextStyle(color: Colors.black87)),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(ctx);
                showPhoneDialog();
              },
              child: const Text("สะสมคะแนน"),
            ),
          ],
        ),
      );
    });
  }

  
  void confirmCashPayment() {
    if (insertedAmount < total) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'เงินไม่พอ ขาด ${(total - insertedAmount).toStringAsFixed(0)} บาท',
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      final change = insertedAmount - total;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            change > 0
                ? 'ชำระเสร็จสิ้น ทอน ${change.toStringAsFixed(0)} บาท'
                : 'ชำระเสร็จสิ้น',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          title: Text("⏳ กำลังตรวจสอบการชำระ",
              style: TextStyle(color: Colors.black87)),
          content: SizedBox(
            width: 100,
            height: 80,
            child: Center(
                child: CircularProgressIndicator(color: Colors.blueAccent)),
          ),
        ),
      );

      completePayment();
    }
  }

  
  void showCashDialog() {
    insertedAmount = 0;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          backgroundColor: Colors.blue[50],
          title: const Text("💵 ชำระด้วยเงินสด",
              style: TextStyle(color: Colors.black87)),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320, maxHeight: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('รวมทั้งหมด: ${total.toStringAsFixed(0)} บาท',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Text(
                      'กรุณาใส่เงินสด (รวม ${insertedAmount.toStringAsFixed(0)} บาท)',
                      style: const TextStyle(color: Colors.black87)),
                  const SizedBox(height: 12),
                  Column(
                    children: [1, 2, 5, 10, 20, 50, 100, 500]
                        .map(
                          (amount) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  setStateDialog(() {
                                    insertedAmount += amount;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black87,
                                ),
                                child: Text('$amount บาท'),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('ยกเลิก', style: TextStyle(color: Colors.black87)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.black87),
              onPressed: () {
                Navigator.pop(ctx);
                confirmCashPayment();
              },
              child: const Text('ชำระเงิน'),
            ),
          ],
        ),
      ),
    );
  }

  
  void showQrDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.blue[50],
        title: const Text("📱 สแกนเพื่อชำระเงิน",
            style: TextStyle(color: Colors.black87)),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('รวมทั้งหมด: ${total.toStringAsFixed(0)} บาท',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 12),
                SizedBox(
                  width: 180,
                  height: 180,
                  child: QrImageView(
                    data: 'PAY:${total.toStringAsFixed(0)}',
                    size: 180,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('กรุณาสแกนเพื่อชำระเงิน',
                    style: TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก', style: TextStyle(color: Colors.black87)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.black87),
            onPressed: () {
              Navigator.pop(ctx);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const AlertDialog(
                  title: Text("⏳ กำลังตรวจสอบการชำระ",
                      style: TextStyle(color: Colors.black87)),
                  content: SizedBox(
                    width: 100,
                    height: 80,
                    child: Center(
                        child:
                            CircularProgressIndicator(color: Colors.blueAccent)),
                  ),
                ),
              );
              completePayment();
            },
            child: const Text('เสร็จสิ้น'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar:
          AppBar(title: const Text('ตะกร้าสินค้า'), backgroundColor: Colors.blueAccent),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final item = widget.cart[index];
                return Dismissible(
                  key: ValueKey(item.product.name),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.blue[50],
                        title: const Text("ยืนยันการลบ",
                            style: TextStyle(color: Colors.black87)),
                        content: Text(
                          "คุณต้องการลบสินค้า '${item.product.name}' ออกจากตะกร้าหรือไม่?",
                          style: const TextStyle(color: Colors.black87),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text("ยกเลิก",
                                  style: TextStyle(color: Colors.black87))),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                  foregroundColor: Colors.black87),
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text("ลบ")),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    setState(() {
                      widget.cart.removeAt(index);
                    });
                    widget.onUpdate();
                    widget.onRemoveFromPurchased(item.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${item.product.name} ถูกลบออกจากตะกร้า',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black26, width: 1.5)),
                    color: Colors.white,
                    child: ListTile(
                      leading: item.product.imageAsset.isNotEmpty
                          ? Image.asset(item.product.imageAsset,
                              width: 40, height: 40)
                          : null,
                      title: Text(item.product.name,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text('${item.qty} ชิ้น',
                          style: const TextStyle(color: Colors.black87)),
                      trailing: Text(
                          '${(item.product.price * item.qty).toStringAsFixed(0)} บาท',
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.cart.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'รวมทั้งหมด: ${total.toStringAsFixed(0)} บาท',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: showCashDialog,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black87),
                  child: const Text('เงินสด'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: showQrDialog,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white),
                  child: const Text('สแกนจ่าย'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ] else
            const Padding(
              padding: EdgeInsets.all(16),
              child:
                  Text('ตะกร้าว่างเปล่า', style: TextStyle(color: Colors.black87)),
            ),
        ],
      ),
    );
  }
}
