import 'package:flutter/material.dart';
import '../models/product.dart';
import '../pages/product_detail_page.dart';
import '../pages/cart_page.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAdd;
  final List<CartItem> cart;
  final VoidCallback onUpdate;
  final VoidCallback onClearPurchased;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    required this.cart,
    required this.onUpdate,
    required this.onClearPurchased,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get cartQty {
    final existing = widget.cart.where((c) => c.product.id == widget.product.id);
    return existing.isNotEmpty ? existing.first.qty : 0;
  }

  void _onTapAdd() async {
    await _controller.forward();
    await _controller.reverse();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(
          product: widget.product,
          onAdd: widget.onAdd,
          cart: widget.cart,
          onUpdate: widget.onUpdate,
          onClearPurchased: widget.onClearPurchased,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Stack(
        children: [
          Card(
            elevation: 8,
            shadowColor: Colors.black38,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: const Color.fromARGB(255, 80, 127, 255),
                width: 2,
              ),
            ),
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // รูปสินค้า
                  if (widget.product.imageAsset.isNotEmpty)
                    Flexible(
                      flex: 5,
                      child: Image.asset(
                        widget.product.imageAsset,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  const SizedBox(height: 4),
                  // ชื่อสินค้า
                  Flexible(
                    flex: 2,
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // ราคา
                  Text(
                    '${widget.product.price.toStringAsFixed(0)} บาท',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const Spacer(),
                  // ปุ่มเพิ่ม
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: widget.product.stock > 0 ? _onTapAdd : null,
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: const Text('เพิ่ม'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 36),
                        backgroundColor: widget.product.stock > 0
                            ? Colors.amber[600]
                            : Colors.grey,
                        foregroundColor: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (cartQty > 0)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26, blurRadius: 3, offset: Offset(2, 2))
                  ],
                ),
                child: Text(
                  '$cartQty',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
