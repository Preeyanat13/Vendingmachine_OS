enum Category { all, daily, electronics, personal }

extension CategoryExt on Category {
  String get title {
    switch (this) {
      case Category.all:
        return 'ทั้งหมด';
      case Category.daily:
        return 'ของใช้ในชีวิตประจำวัน';
      case Category.electronics:
        return 'ของใช้ไฟฟ้า';
      case Category.personal:
        return 'ของใช้ส่วนตัว';
    }
  }
}

class Product {
  final String id;
  final String name;
  final Category category;
  final double price;
  int stock;
  final String imageAsset;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.imageAsset = '',
  });
}

class CartItem {
  final Product product;
  int qty;
  CartItem({required this.product, this.qty = 1});
}


final List<Product> demoProducts = [
  Product(id: 'p1', name: 'แปรงสีฟัน', category: Category.daily, price: 35, stock: 5, imageAsset: 'assets/images/toothbrush.webp'),
  Product(id: 'p2', name: 'ยาสีฟัน', category: Category.daily, price: 45, stock: 8, imageAsset: 'assets/images/toothpaste.jpg'),
  Product(id: 'p3', name: 'น้ำยาบ้วนปาก', category: Category.daily, price: 60, stock: 7, imageAsset: 'assets/images/mouthwash.webp'),
  Product(id: 'p4', name: 'โฟมล้างหน้า', category: Category.daily, price: 89, stock: 2, imageAsset: 'assets/images/foam.jpg'),
  Product(id: 'p5', name: 'สบู่', category: Category.daily, price: 25, stock: 10, imageAsset: 'assets/images/soap.webp'),
  Product(id: 'p6', name: 'ยาสระผม', category: Category.daily, price: 120, stock: 12, imageAsset: 'assets/images/shampoo.webp'),
  Product(id: 'p7', name: 'ครีมนวดผม', category: Category.daily, price: 110, stock: 10, imageAsset: 'assets/images/conditioner.jpg'),
  Product(id: 'p8', name: 'ทิชชู', category: Category.daily, price: 30, stock: 9, imageAsset: 'assets/images/tissue.jpg'),
  Product(id: 'p9', name: 'ปลั๊กไฟ', category: Category.electronics, price: 250, stock: 14, imageAsset: 'assets/images/powerstrip.jpeg'),
  Product(id: 'p10', name: 'สายชาร์จมือถือ', category: Category.electronics, price: 150, stock: 3, imageAsset: 'assets/images/charger.jpg'),
  Product(id: 'p11', name: 'หูฟัง', category: Category.electronics, price: 390, stock: 8, imageAsset: 'assets/images/earphones.jpg'),
  Product(id: 'p12', name: 'สำลี', category: Category.personal, price: 20, stock: 6, imageAsset: 'assets/images/cotton.webp'),
  Product(id: 'p13', name: 'มีดโกน', category: Category.personal, price: 55, stock: 14, imageAsset: 'assets/images/razor.jpg'),
  Product(id: 'p14', name: 'ผ้าอนามัย', category: Category.personal, price: 45, stock: 15, imageAsset: 'assets/images/pad.jpg'),
  Product(id: 'p15', name: 'โรลออน', category: Category.personal, price: 75, stock: 7, imageAsset: 'assets/images/deodorant.jpg'),
  Product(id: 'p16', name: 'ลิปมัน', category: Category.personal, price: 60, stock: 2, imageAsset: 'assets/images/lipbalm.jpg'),
];
