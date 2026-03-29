class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String get firstName => name.split(' ').first;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}
