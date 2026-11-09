import 'bi.dart';

class OrderLine {
  final Bi name;
  final String image;
  final int qty, price;
  final Bi? variant;
  const OrderLine(this.name, this.image, this.qty, this.price, this.variant);

  Map<String, dynamic> toJson() =>
      {'n': name.toJson(), 'i': image, 'q': qty, 'p': price, 'v': variant?.toJson()};
  factory OrderLine.fromJson(Map<String, dynamic> j) => OrderLine(
      Bi.fromJson(Map<String, dynamic>.from(j['n'])),
      j['i'] as String,
      j['q'] as int,
      j['p'] as int,
      j['v'] == null ? null : Bi.fromJson(Map<String, dynamic>.from(j['v'])));
}

class Order {
  final String id;
  final DateTime date;
  final List<OrderLine> lines;
  final int subtotal, shipping, discount, total;
  final String name, phone, city, address, payment; // payment: cod | card

  const Order({
    required this.id,
    required this.date,
    required this.lines,
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.total,
    required this.name,
    required this.phone,
    required this.city,
    required this.address,
    required this.payment,
  });

  int get itemCount => lines.fold(0, (s, l) => s + l.qty);

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'lines': lines.map((l) => l.toJson()).toList(),
        'sub': subtotal,
        'ship': shipping,
        'disc': discount,
        'total': total,
        'name': name,
        'phone': phone,
        'city': city,
        'address': address,
        'pay': payment,
      };

  factory Order.fromJson(Map<String, dynamic> j) => Order(
        id: j['id'] as String,
        date: DateTime.parse(j['date'] as String),
        lines: [
          for (final l in j['lines'] as List) OrderLine.fromJson(Map<String, dynamic>.from(l))
        ],
        subtotal: j['sub'] as int,
        shipping: j['ship'] as int,
        discount: j['disc'] as int,
        total: j['total'] as int,
        name: j['name'] as String,
        phone: j['phone'] as String,
        city: j['city'] as String,
        address: j['address'] as String,
        payment: j['pay'] as String,
      );
}
