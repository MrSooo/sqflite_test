class User {
  final int id;
  final String name;
  final String address;

  User({
    required this.id,
    required this.name,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }

  Map toJson() => {
        'id': id,
        'name': name,
        'address': address,
      };

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      address: map['address'],
    );
  }
}
