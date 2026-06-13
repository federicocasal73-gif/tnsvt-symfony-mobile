class TaskItem {
  final int id;
  final String title;
  final String? description;
  final int orden;

  TaskItem({
    required this.id,
    required this.title,
    this.description,
    required this.orden,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      orden: json['orden'] ?? 999,
    );
  }
}
