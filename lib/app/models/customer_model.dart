class Customer {
  final String custId;
  final String custName;
  final String custAddress;
  final String custCity;
  final String custState;
  final String custZip;
  final String custCountry;
  final String custTel;

  Customer({
    required this.custId,
    required this.custName,
    required this.custAddress,
    required this.custCity,
    required this.custState,
    required this.custZip,
    required this.custCountry,
    required this.custTel,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        custId: json['cust_id'],
        custName: json['cust_name'],
        custAddress: json['cust_address'],
        custCity: json['cust_city'],
        custState: json['cust_state'],
        custZip: json['cust_zip'],
        custCountry: json['cust_country'],
        custTel: json['cust_tel'],
      );

  Map<String, dynamic> toJson() => {
        'cust_id': custId,
        'cust_name': custName,
        'cust_address': custAddress,
        'cust_city': custCity,
        'cust_state': custState,
        'cust_zip': custZip,
        'cust_country': custCountry,
        'cust_tel': custTel,
      };
}
