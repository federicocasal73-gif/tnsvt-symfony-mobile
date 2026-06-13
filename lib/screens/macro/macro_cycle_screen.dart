import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/macro_content.dart';

class MacroCycleScreen extends StatefulWidget {
  const MacroCycleScreen({super.key});

  @override
  State<MacroCycleScreen> createState() => _MacroCycleScreenState();
}

class _MacroCycleScreenState extends State<MacroCycleScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final phase = MacroContent.cyclePhases[_currentIndex];
    final colorForIndex = [AppTheme.danger, AppTheme.success, AppTheme.goldBright, AppTheme.warning];
    final color = colorForIndex[_currentIndex];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: AppTheme.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(MacroContent.cyclePhases.length, (i) {
              final p = MacroContent.cyclePhases[i];
              final isActive = i == _currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentIndex = i),
                  child: Column(
                    children: [
                      Opacity(
                        opacity: isActive ? 1.0 : 0.5,
                        child: Text(p.emoji, style: const TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isActive ? AppTheme.goldBright : AppTheme.textMuted,
                          fontSize: 11,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 3,
                        width: 30,
                        decoration: BoxDecoration(
                          color: isActive ? AppTheme.goldBright : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    phase.emoji,
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    phase.title,
                    style: TextStyle(
                      color: color,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Fase ${_currentIndex + 1} de ${MacroContent.cyclePhases.length}',
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.4), width: 1.5),
                  ),
                  child: Text(
                    phase.description,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _currentIndex == 0
                          ? null
                          : () => setState(() => _currentIndex--),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Anterior'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.goldBright,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _currentIndex == MacroContent.cyclePhases.length - 1
                          ? null
                          : () => setState(() => _currentIndex++),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Siguiente'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.goldBright,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
