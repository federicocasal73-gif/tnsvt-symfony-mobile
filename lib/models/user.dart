class AppUser {
  final String code;
  final String name;
  final bool isAdmin;
  final List<String> roles;

  AppUser({
    required this.code,
    required this.name,
    this.isAdmin = false,
    this.roles = const ['ROLE_USER'],
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      code: json['code'] ?? '',
      name: json['name'] ?? 'Usuario',
      isAdmin: json['isAdmin'] ?? false,
      roles: json['roles'] != null
          ? List<String>.from(json['roles'])
          : (json['isAdmin'] == true ? ['ROLE_USER', 'ROLE_ADMIN'] : ['ROLE_USER']),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'isAdmin': isAdmin,
        'roles': roles,
      };
}

