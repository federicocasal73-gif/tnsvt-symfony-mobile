class Trade {
  final int id;
  final DateTime? date;
  final String asset;
  final String dir;
  final String? entry;
  final String? sl;
  final String? tp;
  final String result;
  final double pnl;
  final String? ratio;
  final String? notes;
  final List<String> photos;

  Trade({
    required this.id,
    this.date,
    required this.asset,
    required this.dir,
    this.entry,
    this.sl,
    this.tp,
    this.result = 'OPEN',
    this.pnl = 0,
    this.ratio,
    this.notes,
    this.photos = const [],
  });

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      id: json['id'] ?? 0,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      asset: json['asset'] ?? '',
      dir: json['dir'] ?? 'BUY',
      entry: json['entry']?.toString(),
      sl: json['sl']?.toString(),
      tp: json['tp']?.toString(),
      result: json['result'] ?? 'OPEN',
      pnl: (json['pnl'] as num?)?.toDouble() ?? 0,
      ratio: json['ratio']?.toString(),
      notes: json['notes'],
      photos: (json['photos'] as List?)?.cast<String>() ?? const [],
    );
  }

  bool get isWin => result == 'WIN';
  bool get isLoss => result == 'LOSS';
  bool get isOpen => result == 'OPEN' || result == 'BE';
}
