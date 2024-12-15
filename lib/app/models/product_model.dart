class Product {
  final String prodId;
  final String vendId;
  final String prodName;
  final double prodPrice;
  final String prodDesc;

  Product({
    required this.prodId,
    required this.vendId,
    required this.prodName,
    required this.prodPrice,
    required this.prodDesc,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        prodId: json['prod_id'],
        vendId: json['vend_id'],
        prodName: json['prod_name'],
        prodPrice: json['prod_price'],
        prodDesc: json['prod_desc'],
      );

  Map<String, dynamic> toJson() => {
        'prod_id': prodId,
        'vend_id': vendId,
        'prod_name': prodName,
        'prod_price': prodPrice,
        'prod_desc': prodDesc,
      };
}
