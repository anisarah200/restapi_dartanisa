class Vendor {
  final String vendId;
  final String vendName;
  final String vendAddress;
  final String vendKota;
  final String vendState;
  final String vendZip;
  final String vendCountry;

  Vendor({
    required this.vendId,
    required this.vendName,
    required this.vendAddress,
    required this.vendKota,
    required this.vendState,
    required this.vendZip,
    required this.vendCountry,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        vendId: json['vend_id'],
        vendName: json['vend_name'],
        vendAddress: json['vend_address'],
        vendKota: json['vend_kota'],
        vendState: json['vend_state'],
        vendZip: json['vend_zip'],
        vendCountry: json['vend_country'],
      );

  Map<String, dynamic> toJson() => {
        'vend_id': vendId,
        'vend_name': vendName,
        'vend_address': vendAddress,
        'vend_kota': vendKota,
        'vend_state': vendState,
        'vend_zip': vendZip,
        'vend_country': vendCountry,
      };
}
