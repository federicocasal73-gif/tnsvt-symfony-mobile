import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme.dart';

class MacroCalculatorScreen extends StatefulWidget {
  const MacroCalculatorScreen({super.key});

  @override
  State<MacroCalculatorScreen> createState() => _MacroCalculatorScreenState();
}

class _MacroCalculatorScreenState extends State<MacroCalculatorScreen> {
  double _rate = 1;

  @override
  Widget build(BuildContext context) {
    final total = 1000 + (1000 * _rate / 100);
    final rate = _rate.round();
    final isLow = rate <= 3;
    final isMid = rate > 3 && rate <= 8;
    final isHigh = rate > 8;

    final acceptText = isLow
        ? 'Sí, es barato'
        : isMid
            ? 'Tal vez...'
            : 'No, demasiado caro';
    final acceptEmoji = isLow ? '😊' : isMid ? '😐' : '😤';

    final econText = isLow
        ? 'Se estimula'
        : isMid
            ? 'Neutral'
            : 'Se enfría';
    final econEmoji = isLow ? '📈' : isMid ? '↔️' : '📉';
    final econColor = isLow ? AppTheme.success : isMid ? AppTheme.warning : AppTheme.danger;

    final dollarText = isLow
        ? 'Se debilita'
        : isMid
            ? 'Neutral'
            : 'Se fortalece';
    final dollarEmoji = isLow ? '📉' : isMid ? '↔️' : '📈';
    final dollarColor = isLow ? AppTheme.danger : isMid ? AppTheme.warning : AppTheme.success;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Préstamo base',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text(
                  r'$1.000',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Tasa de interés anual',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '$rate%',
                  style: const TextStyle(
                    color: AppTheme.goldBright,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: _rate,
                  min: 1,
                  max: 15,
                  divisions: 14,
                  activeColor: AppTheme.goldBright,
                  inactiveColor: AppTheme.surfaceLight,
                  onChanged: (v) {
                    HapticFeedback.selectionClick();
                    setState(() => _rate = v);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1%', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                    Text('15%', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total a pagar', style: TextStyle(color: AppTheme.textSecondary)),
                      Text(
                        '\$${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}',
                        style: const TextStyle(
                          color: AppTheme.goldBright,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _DataCard(
            label: '¿Te conviene pedir el préstamo?',
            value: '$acceptEmoji  $acceptText',
            color: isLow ? AppTheme.success : isMid ? AppTheme.warning : AppTheme.danger,
          ),
          const SizedBox(height: 12),
          _DataCard(
            label: 'Efecto en la economía real',
            value: '$econEmoji  $econText',
            color: econColor,
          ),
          const SizedBox(height: 12),
          _DataCard(
            label: 'Efecto en el Dólar (USD)',
            value: '$dollarEmoji  $dollarText',
            color: dollarColor,
          ),
          const SizedBox(height: 24),
          _LegendCard(rate: rate),
        ],
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _DataCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendCard extends StatelessWidget {
  final int rate;
  const _LegendCard({required this.rate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.violet.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Leyenda',
            style: TextStyle(
              color: AppTheme.violet,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '• Tasas bajas (1-3%): crédito barato, economía se calienta, USD débil.',
            style: TextStyle(color: AppTheme.textPrimary, fontSize: 12, height: 1.5),
          ),
          Text(
            '• Tasas medias (4-8%): zona neutral, esperar para ver.',
            style: TextStyle(color: AppTheme.textPrimary, fontSize: 12, height: 1.5),
          ),
          Text(
            '• Tasas altas (9-15%): crédito caro, economía se enfría, USD fuerte.',
            style: TextStyle(color: AppTheme.textPrimary, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}
