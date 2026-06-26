import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import 'landing_page.dart';
import 'admin_login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Category selectedCategory = Category.all;
  String search = '';
  final List<CartItem> cart = [];
  final List<Product> purchased = [];

  List<Product> get filtered => demoProducts.where((p) {
        if (selectedCategory != Category.all && p.category != selectedCategory)
          return false;
        if (search.isNotEmpty &&
            !p.name.toLowerCase().contains(search.toLowerCase())) return false;
        return true;
      }).toList();

  void addToCart(Product p) {
    if (p.stock <= 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("สินค้าหมด"),
          content: Text("ขออภัย สินค้า '${p.name}' หมดแล้ว"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  cart.clear();
                  purchased.clear();
                });
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LandingPage()),
                    (route) => false);
              },
              child: const Text("ยกเลิกออเดอร์"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const HomePage()));
              },
              child: const Text("เลือกสินค้าอื่น"),
            ),
          ],
        ),
      );
      return;
    }

    final existing = cart.where((c) => c.product.id == p.id).toList();
    setState(() {
      if (existing.isNotEmpty) {
        existing.first.qty++;
      } else {
        cart.add(CartItem(product: p));
      }
      p.stock--;
      purchased.add(p);
    });
  }

  void openCart() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CartPage(
          cart: cart,
          onUpdate: () => setState(() {}),
          onClearPurchased: () => setState(() => purchased.clear()),
          onRemoveFromPurchased: (product) => setState(() => purchased.remove(product)),
        ),
      ),
    );
    setState(() {});
  }

  void openAdmin() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AdminLoginPage()));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("ตู้กดของใช้ประจำวัน"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(onPressed: openAdmin, icon: const Icon(Icons.settings)),
          Stack(
            children: [
              IconButton(onPressed: openCart, icon: const Icon(Icons.shopping_cart)),
              if (cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        color: Colors.orange, shape: BoxShape.circle),
                    child: Text('${cart.fold<int>(0, (s, c) => s + c.qty)}',
                        style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'ค้นหาสินค้า...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none),
              ),
              onChanged: (value) => setState(() => search = value),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: Category.values.map((cat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat.title),
                    selected: selectedCategory == cat,
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey[300],
                    labelStyle: TextStyle(
                        color: selectedCategory == cat ? Colors.white : Colors.black),
                    onSelected: (_) => setState(() => selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final product = filtered[index];
                return ProductCard(
                  product: product,
                  cart: cart,
                  onAdd: () => addToCart(product),
                  onUpdate: () => setState(() {}),
                  onClearPurchased: () => setState(() => purchased.clear()),
                );
              },
            ),
          ),
          if (purchased.isNotEmpty)
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.orange.shade50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: purchased.length,
                itemBuilder: (context, index) {
                  final p = purchased[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 3,
                                    offset: Offset(2, 2))
                              ]),
                          child: p.imageAsset.isNotEmpty ? Image.asset(p.imageAsset) : null,
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 60,
                          child: Text(p.name,
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
