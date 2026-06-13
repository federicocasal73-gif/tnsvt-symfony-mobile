class ChatMessage {
  final int id;
  final int conversationId;
  final String? senderCode;
  final String? senderName;
  final String content;
  final String? photo;
  final bool isAi;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.conversationId,
    this.senderCode,
    this.senderName,
    required this.content,
    this.photo,
    this.isAi = false,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? 0,
      conversationId: json['conversation_id'] ?? 0,
      senderCode: json['sender_code'],
      senderName: json['sender_name'],
      content: json['content'] ?? '',
      photo: json['photo'],
      isAi: json['is_ai'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class ChatConversation {
  final int id;
  final String type;
  final String? title;
  final String? otherUserCode;
  final String? otherUserName;
  final int unreadCount;
  final ChatMessage? lastMessage;

  ChatConversation({
    required this.id,
    required this.type,
    this.title,
    this.otherUserCode,
    this.otherUserName,
    this.unreadCount = 0,
    this.lastMessage,
  });

  bool get isGroup => type == 'group';
  bool get isDm => type == 'dm';

  String get displayName {
    if (isGroup) return title ?? 'Grupo';
    return otherUserName ?? otherUserCode ?? '?';
  }

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    final lm = json['last_message'];
    return ChatConversation(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'group',
      title: json['title'],
      otherUserCode: json['other_user_code'],
      otherUserName: json['other_user_name'],
      unreadCount: json['unread_count'] ?? 0,
      lastMessage: lm is Map<String, dynamic> ? ChatMessage.fromJson(lm) : null,
    );
  }
}

class ChatUser {
  final String code;
  final String name;
  final bool isMe;

  ChatUser({required this.code, required this.name, this.isMe = false});

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      isMe: json['is_me'] ?? false,
    );
  }
}
