import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';

class EconomicEvent {
  final DateTime date;
  final String code;
  final String name;
  final String impact; // high, medium, low
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
}

class CalendarScreen extends StatelessWidget {
  CalendarScreen({super.key});

  static final List<EconomicEvent> _events = [
    EconomicEvent(
      date: DateTime.now().add(const Duration(days: 1, hours: 2)),
      code: 'FOMC',
      name: 'Federal Funds Rate Decision',
      impact: 'high',
      forecast: '5.25%',
      previous: '5.25%',
      currency: 'USD',
    ),
    EconomicEvent(
      date: DateTime.now().add(const Duration(days: 1, hours: 4)),
      code: 'CPI',
      name: 'Consumer Price Index (YoY)',
      impact: 'high',
      forecast: '3.2%',
      previous: '3.4%',
      currency: 'USD',
    ),
    EconomicEvent(
      date: DateTime.now().add(const Duration(days: 2, hours: 1)),
      code: 'NFP',
      name: 'Non-Farm Payrolls',
      impact: 'high',
      forecast: '180K',
      previous: '175K',
      currency: 'USD',
    ),
    EconomicEvent(
      date: DateTime.now().add(const Duration(days: 2, hours: 3)),
      code: 'PMI',
      name: 'Purchasing Managers Index',
      impact: 'medium',
      forecast: '52.1',
      previous: '51.8',
      currency: 'USD',
    ),
    EconomicEvent(
      date: DateTime.now().add(const Duration(days: 3, hours: 1)),
      code: 'GDP',
      name: 'Gross Domestic Product (QoQ)',
      impact: 'high',
      forecast: '2.1%',
      previous: '2.0%',
      currency: 'USD',
    ),
    EconomicEvent(
      date: DateTime.now().add(const Duration(days: 3, hours: 2)),
      code: 'RETAIL',
      name: 'Retail Sales (MoM)',
      impact: 'medium',
      forecast: '0.3%',
      previous: '0.1%',
      currency: 'USD',
    ),
    EconomicEvent(
      date: DateTime.now().add(const Duration(days: 4, hours: 1)),
      code: 'ECB',
      name: 'European Central Bank Rate',
      impact: 'high',
      forecast: '4.25%',
      previous: '4.25%',
      currency: 'EUR',
    ),
    EconomicEvent(
      date: DateTime.now().add(const Duration(days: 5, hours: 4)),
      code: 'BOE',
      name: 'Bank of England Rate',
      impact: 'medium',
      forecast: '5.00%',
      previous: '5.00%',
      currency: 'GBP',
    ),
    EconomicEvent(
      date: DateTime.now().add(const Duration(days: 6, hours: 1)),
      code: 'PMI',
      name: 'Services PMI',
      impact: 'low',
      forecast: '53.0',
      previous: '52.9',
      currency: 'USD',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('EEE dd MMM');
    final tf = DateFormat('HH:mm');
    final byDate = <String, List<EconomicEvent>>{};
    for (final e in _events) {
      final k = df.format(e.date);
      byDate.putIfAbsent(k, () => []).add(e);
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('CALENDARIO ECONÓMICO'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        itemCount: byDate.length,
        itemBuilder: (context, i) {
          final date = byDate.keys.elementAt(i);
          final events = byDate[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
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
              ...events.map((e) => _eventTile(e, tf)),
            ],
          );
        },
      ),
    );
  }

  Widget _eventTile(EconomicEvent e, DateFormat tf) {
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
                Text(tf.format(e.date),
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
                    Text(e.code,
                        style: TextStyle(
                          fontFamily: AppTheme.displayFont,
                          color: AppTheme.goldBright,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        )),
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    _miniStat('F', e.forecast, AppTheme.gold),
                    const SizedBox(width: 10),
                    _miniStat('P', e.previous, AppTheme.textMuted),
                  ],
                ),
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
        Text(value,
            style: TextStyle(
              fontFamily: AppTheme.labelFont,
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }
}
