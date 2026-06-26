import 'package:flutter/material.dart';
import '../models/product.dart';
import 'home_page.dart';

class AdminPage extends StatefulWidget {
  final VoidCallback onRestock; // callback ไป HomePage

  const AdminPage({super.key, required this.onRestock});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("จัดการสต็อกสินค้า"),
        backgroundColor: Colors.blue[200], 
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: demoProducts.length,
              itemBuilder: (context, index) {
                final product = demoProducts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color.fromARGB(255, 136, 133, 149), width: 1)), 
                  color: Colors.blue[50], 
                  elevation: 3,
                  child: ListTile(
                    leading: product.imageAsset.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Image.asset(product.imageAsset, width: 50, height: 50),
                          )
                        : null,
                    title: Text(product.name, style: const TextStyle(color: Colors.black)),
                    subtitle: Text('คงเหลือ: ${product.stock} ชิ้น',
                        style: const TextStyle(color: Colors.black)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          product.stock += 10; 
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${product.name} เติมสต็อก +10 ชิ้นเรียบร้อย'),
                            duration: const Duration(seconds: 1),
                          ),
                        );

                        widget.onRestock(); 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700], 
                      ),
                      child: const Text('เติมสต็อก +10', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                );
              },
            ),
          ),
          // ปุ่มเสร็จสิ้น
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700], 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black, width: 1), 
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "เสร็จสิ้น",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
