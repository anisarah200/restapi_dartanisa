class Order {
  final int orderNum;
  final DateTime orderDate;
  final String custId;

  Order({
    required this.orderNum,
    required this.orderDate,
    required this.custId,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderNum: json['order_num'],
        orderDate: DateTime.parse(json['order_date']),
        custId: json['cust_id'],
      );

  Map<String, dynamic> toJson() => {
        'order_num': orderNum,
        'order_date': orderDate.toIso8601String(),
        'cust_id': custId,
      };
}
