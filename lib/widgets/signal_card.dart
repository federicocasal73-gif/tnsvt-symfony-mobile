import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/feed_post.dart';

class SignalCard extends StatelessWidget {
  final SignalData signal;
  const SignalCard({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final isBuy = signal.dir == 'BUY';
    final dirColor = isBuy ? AppTheme.success : AppTheme.danger;
    final dirBg = isBuy
        ? AppTheme.success.withOpacity(0.12)
        : AppTheme.danger.withOpacity(0.12);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: dirColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: dirBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  signal.dir,
                  style: TextStyle(
                    color: dirColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                signal.asset,
                style: const TextStyle(
                  color: AppTheme.goldBright,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              if (signal.status.isNotEmpty)
                Text(
                  '• ${signal.status}',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _level('Entry', signal.entry, AppTheme.textSecondary),
              _level('Stop', signal.sl, AppTheme.danger),
              _level('TP1', signal.tp1, AppTheme.success),
              if (signal.tp2 != null && signal.tp2!.isNotEmpty)
                _level('TP2', signal.tp2!, AppTheme.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _level(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 9,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value.isEmpty ? '—' : value,
              style: TextStyle(
                color: valueColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
