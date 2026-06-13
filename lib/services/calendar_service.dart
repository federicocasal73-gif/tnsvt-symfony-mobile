import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EconomicEvent {
  final DateTime date;
  final String code;
  final String name;
  final String impact; // high, medium, low, holiday
  final String forecast;
  final String previous;
  final String currency;

  EconomicEvent({
    required this.date,
    required this.code,
    required this.name,
    required this.impact,
    this.forecast = '—',
    this.previous = '—',
    this.currency = 'USD',
  });

  factory EconomicEvent.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date'] as String? ?? '';
    DateTime parsed;
    try {
      parsed = DateTime.parse(dateStr).toLocal();
    } catch (_) {
      parsed = DateTime.now();
    }
    return EconomicEvent(
      date: parsed,
      code: _codeFromTitle(json['title'] as String? ?? ''),
      name: json['title'] as String? ?? '',
      impact: _impactFromString(json['impact'] as String? ?? 'Low'),
      forecast: (json['forecast'] as String? ?? '').trim(),
      previous: (json['previous'] as String? ?? '').trim(),
      currency: json['country'] as String? ?? 'USD',
    );
  }

  static String _impactFromString(String s) {
    final l = s.toLowerCase();
    if (l == 'high') return 'high';
    if (l == 'medium') return 'medium';
    if (l == 'holiday') return 'holiday';
    return 'low';
  }

  static String _codeFromTitle(String title) {
    final t = title.toUpperCase();
    final m = RegExp(r'^(FOMC|CPI|NFP|PMI|GDP|RETAIL|ECB|BOE|BOC|RBA|RBNZ|BOC|SNB|API|ADP|IFO|ZEW|EIA)').firstMatch(t);
    return m?.group(0) ?? _initials(title);
  }

  static String _initials(String t) {
    final words = t.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0].substring(0, words[0].length.clamp(0, 4)).toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }
}

class CalendarService {
  static const _url = 'https://nfs.faireconomy.media/ff_calendar_thisweek.json';
  static const _cacheTtl = Duration(hours: 6);

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Accept': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Mobile Safari/537.36 TNSVT/1.0',
    },
  ));

  List<EconomicEvent>? _cache;
  DateTime? _cachedAt;
  bool _hydrated = false;

  static const _prefsKey = 'calendar_events_json';
  static const _prefsTsKey = 'calendar_events_ts';

  Future<void> _hydrate() async {
    if (_hydrated) return;
    _hydrated = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final ts = prefs.getString(_prefsTsKey);
      if (ts == null) return;
      final cachedAt = DateTime.tryParse(ts);
      if (cachedAt == null) return;
      if (DateTime.now().difference(cachedAt) >= _cacheTtl) return;
      final json = prefs.getString(_prefsKey);
      if (json == null) return;
      final List<dynamic> data = jsonDecode(json) as List<dynamic>;
      _cache = data
          .map((e) => EconomicEvent.fromJson(e as Map<String, dynamic>))
          .where((e) => e.impact != 'holiday')
          .toList();
      _cache!.sort((a, b) => a.date.compareTo(b.date));
      _cachedAt = cachedAt;
    } catch (_) {
      // Silently ignore hydrate failures
    }
  }

  Future<void> _persist() async {
    if (_cache == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(_cache!.map((e) => {
            'title': e.name,
            'country': e.currency,
            'date': e.date.toUtc().toIso8601String(),
            'impact': e.impact,
            'forecast': e.forecast,
            'previous': e.previous,
          }).toList());
      await prefs.setString(_prefsKey, json);
      await prefs.setString(_prefsTsKey, DateTime.now().toIso8601String());
    } catch (_) {
      // Silently ignore persist failures
    }
  }

  Future<List<EconomicEvent>> fetchEvents({bool forceRefresh = false}) async {
    await _hydrate();
    if (!forceRefresh && _cache != null && _cachedAt != null) {
      if (DateTime.now().difference(_cachedAt!) < _cacheTtl) {
        return _cache!;
      }
    }
    final response = await _dio.get(_url);
    if (response.statusCode == 429 || response.statusCode == 503) {
      if (_cache != null) return _cache!;
      throw Exception('ForexFactory rate-limit. Reintentá en 5 minutos.');
    }
    if (response.statusCode != 200) {
      if (_cache != null) return _cache!;
      throw Exception('HTTP ${response.statusCode}');
    }
    final body = response.data;
    if (body is String && body.contains('Request Denied')) {
      if (_cache != null) return _cache!;
      throw Exception('ForexFactory bloqueó la petición. Reintentá en 5 min.');
    }
    final List<dynamic> data = body as List<dynamic>;
    final events = data
        .map((e) => EconomicEvent.fromJson(e as Map<String, dynamic>))
        .where((e) => e.impact != 'holiday')
        .toList();
    events.sort((a, b) => a.date.compareTo(b.date));
    _cache = events;
    _cachedAt = DateTime.now();
    await _persist();
    return events;
  }
}
