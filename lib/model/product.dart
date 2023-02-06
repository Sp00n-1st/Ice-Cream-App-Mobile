class Product {
  final String nameProduct, descItem, category;
  final List<String> imageUrl;
  final num fat, protein, calori, price, carbo;
  final int stock;

  Product(
      {required this.nameProduct,
      required this.category,
      required this.imageUrl,
      //required this.imagePath,
      required this.price,
      required this.descItem,
      required this.calori,
      required this.carbo,
      required this.fat,
      required this.protein,
      required this.stock});

  Product.fromJson(Map<String, dynamic>? json)
      : this(
            nameProduct: json!['nameProduct'] as String,
            category: json['category'] as String,
            imageUrl: (json['imageUrl'] as List).cast<String>(),
            //imagePath: json['imagePath'] as String,
            price: json['price'] as num,
            descItem: json['descItem'] as String,
            calori: json['calori'] as num,
            carbo: json['carbo'] as num,
            fat: json['fat'] as num,
            protein: json['protein'] as num,
            stock: json['stock'] as int);

  Map<String, Object?> toJson() {
    return {
      'namaProduct': nameProduct,
      'category': category,
      'imageUrl': imageUrl,
      //'imagePath': imagePath,
      'price': price,
      'descItem': descItem,
      'calori': calori,
      'carbo': carbo,
      'fat': fat,
      'protein': protein,
      'stock': stock
    };
  }
}
