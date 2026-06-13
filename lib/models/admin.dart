class AdminDashboardStats {
  final int totalUsers;
  final int activeUsers;
  final int inactiveUsers;
  final int students;
  final int admins;
  final List<RecentLogin> recentLogins;

  AdminDashboardStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.inactiveUsers,
    required this.students,
    required this.admins,
    required this.recentLogins,
  });

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) {
    final r = json['recentLogins'] ?? json['recent_logins'];
    return AdminDashboardStats(
      totalUsers: json['totalUsers'] ?? json['total_users'] ?? 0,
      activeUsers: json['activeUsers'] ?? json['active_users'] ?? 0,
      inactiveUsers: json['inactiveUsers'] ?? json['inactive_users'] ?? 0,
      students: json['students'] ?? 0,
      admins: json['admins'] ?? 0,
      recentLogins: r is List
          ? r
              .whereType<Map<String, dynamic>>()
              .map((j) => RecentLogin.fromJson(j))
              .toList()
          : [],
    );
  }
}

class RecentLogin {
  final String code;
  final String name;
  final String? lastLogin;
  RecentLogin({required this.code, required this.name, this.lastLogin});

  factory RecentLogin.fromJson(Map<String, dynamic> json) {
    return RecentLogin(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      lastLogin: json['lastLogin'] ?? json['last_login'],
    );
  }
}

class AdminUser {
  final int id;
  final String code;
  final String name;
  final bool active;
  final bool isAdmin;
  final String? lastLogin;

  AdminUser({
    required this.id,
    required this.code,
    required this.name,
    required this.active,
    this.isAdmin = false,
    this.lastLogin,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      active: json['active'] ?? true,
      isAdmin: json['isAdmin'] ?? json['is_admin'] ?? false,
      lastLogin: json['lastLogin'] ?? json['last_login'],
    );
  }
}
