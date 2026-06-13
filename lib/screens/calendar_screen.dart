import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../services/calendar_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _service = CalendarService();
  final _df = DateFormat('EEE dd MMM');
  final _tf = DateFormat('HH:mm');

  static const _filters = ['ALL', 'USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD'];

  List<EconomicEvent>? _events;
  bool _loading = true;
  String? _error;
  DateTime? _lastUpdated;
  String _filter = 'ALL';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool force = false}) async {
    setState(() {
      _loading = _events == null;
      _error = null;
    });
    try {
      final events = await _service.fetchEvents(forceRefresh: force);
      if (!mounted) return;
      setState(() {
        _events = events;
        _loading = false;
        _lastUpdated = DateTime.now();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<EconomicEvent> _filteredEvents() {
    if (_events == null) return [];
    if (_filter == 'ALL') return _events!;
    return _events!.where((e) => e.currency == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('CALENDARIO ECONÓMICO'),
      ),
      body: _buildBody(),
    );
  }

  Widget _filterBar() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final f = _filters[i];
          final active = f == _filter;
          return ChoiceChip(
            label: Text(f == 'ALL' ? 'Todos' : f),
            selected: active,
            onSelected: (_) => setState(() => _filter = f),
            selectedColor: AppTheme.gold,
            backgroundColor: AppTheme.surface,
            labelStyle: TextStyle(
              fontFamily: AppTheme.labelFont,
              color: active ? Colors.black : AppTheme.textSecondary,
              fontSize: 10,
              fontWeight: active ? FontWeight.bold : FontWeight.w600,
              letterSpacing: 1.5,
            ),
            side: BorderSide(
              color: active ? AppTheme.gold : AppTheme.violet.withOpacity(0.3),
            ),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_loading && _events == null) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.gold));
    }
    if (_error != null && _events == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, color: AppTheme.danger, size: 48),
              const SizedBox(height: 12),
              Text('No se pudo cargar el calendario',
                  style: TextStyle(
                    fontFamily: AppTheme.displayFont,
                    color: AppTheme.goldBright,
                    fontSize: 16,
                  )),
              const SizedBox(height: 6),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  )),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _load(force: true),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('REINTENTAR'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.gold.withOpacity(0.5)),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (_events == null || _events!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Sin eventos para esta semana',
              style: TextStyle(
                fontFamily: AppTheme.displayFont,
                color: AppTheme.goldBright,
                fontSize: 14,
              )),
        ),
      );
    }

    final filtered = _filteredEvents();
    if (filtered.isEmpty) {
      return Column(
        children: [
          _filterBar(),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Sin eventos $_filter esta semana',
                        style: TextStyle(
                          fontFamily: AppTheme.displayFont,
                          color: AppTheme.goldBright,
                          fontSize: 14,
                        )),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () => setState(() => _filter = 'ALL'),
                      child: Text('Ver todos',
                          style: TextStyle(color: AppTheme.gold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    final byDate = <String, List<EconomicEvent>>{};
    for (final e in filtered) {
      final k = _df.format(e.date);
      byDate.putIfAbsent(k, () => []).add(e);
    }

    return RefreshIndicator(
      color: AppTheme.gold,
      onRefresh: () => _load(force: true),
      child: Column(
        children: [
          _filterBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
              itemCount: byDate.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 12),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: _loading ? AppTheme.gold : AppTheme.success),
                        const SizedBox(width: 6),
                        Text(
                          _lastUpdated != null
                              ? 'Actualizado ${DateFormat('HH:mm').format(_lastUpdated!)} · ${filtered.length} eventos'
                              : 'Cargando...',
                          style: TextStyle(
                            fontFamily: AppTheme.labelFont,
                            color: AppTheme.textMuted,
                            fontSize: 9,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final date = byDate.keys.elementAt(i - 1);
                final events = byDate[date]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                      child: Text(
                        date.toUpperCase(),
                        style: TextStyle(
                          fontFamily: AppTheme.labelFont,
                          color: AppTheme.goldBright,
                          fontSize: 11,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...events.map((e) => _eventTile(e)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventTile(EconomicEvent e) {
    final impactColor = e.impact == 'high'
        ? AppTheme.danger
        : e.impact == 'medium'
            ? AppTheme.warning
            : AppTheme.textMuted;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(left: BorderSide(color: impactColor, width: 3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: impactColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                Text(e.currency,
                    style: TextStyle(
                      fontFamily: AppTheme.labelFont,
                      color: impactColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    )),
                Text(_tf.format(e.date),
                    style: TextStyle(
                      color: impactColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    )),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(e.code,
                          style: TextStyle(
                            fontFamily: AppTheme.displayFont,
                            color: AppTheme.goldBright,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          )),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      e.impact == 'high'
                          ? Icons.warning_amber
                          : e.impact == 'medium'
                              ? Icons.info_outline
                              : Icons.circle_outlined,
                      size: 12,
                      color: impactColor,
                    ),
                  ],
                ),
                Text(
                  e.name,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 11,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (e.forecast.isNotEmpty || e.previous.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (e.forecast.isNotEmpty) _miniStat('F', e.forecast, AppTheme.gold),
                      if (e.forecast.isNotEmpty && e.previous.isNotEmpty)
                        const SizedBox(width: 10),
                      if (e.previous.isNotEmpty) _miniStat('P', e.previous, AppTheme.textMuted),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Row(
      children: [
        Text('$label:',
            style: TextStyle(
              fontFamily: AppTheme.labelFont,
              color: AppTheme.textMuted,
              fontSize: 9,
              letterSpacing: 1,
            )),
        const SizedBox(width: 4),
        Flexible(
          child: Text(value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppTheme.labelFont,
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              )),
        ),
      ],
    );
  }
}
