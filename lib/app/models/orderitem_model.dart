class OrderItem {
  final int orderItem;
  final int orderNum;
  final String prodId;
  final int quantity;
  final int size;

  OrderItem({
    required this.orderItem,
    required this.orderNum,
    required this.prodId,
    required this.quantity,
    required this.size,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        orderItem: json['order_item'],
        orderNum: json['order_num'],
        prodId: json['prod_id'],
        quantity: json['quantity'],
        size: json['size'],
      );

  Map<String, dynamic> toJson() => {
        'order_item': orderItem,
        'order_num': orderNum,
        'prod_id': prodId,
        'quantity': quantity,
        'size': size,
      };
}
