import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/macro_content.dart';

class MacroOverviewScreen extends StatefulWidget {
  const MacroOverviewScreen({super.key});

  @override
  State<MacroOverviewScreen> createState() => _MacroOverviewScreenState();
}

class _MacroOverviewScreenState extends State<MacroOverviewScreen> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final selected = _selectedId == null
        ? null
        : MacroContent.flowNodes.firstWhere((n) => n.id == _selectedId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Cómo el Banco Central mueve la economía',
            style: TextStyle(
              color: AppTheme.goldBright,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tocá cada nodo para entender el flujo',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < MacroContent.flowNodes.length; i++) ...[
            _NodeButton(
              node: MacroContent.flowNodes[i],
              selected: _selectedId == MacroContent.flowNodes[i].id,
              onTap: () => setState(
                () => _selectedId = _selectedId == MacroContent.flowNodes[i].id
                    ? null
                    : MacroContent.flowNodes[i].id,
              ),
            ),
            if (i < MacroContent.flowNodes.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Icon(
                  Icons.arrow_downward,
                  color: AppTheme.violet,
                  size: 32,
                ),
              ),
          ],
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: selected == null
                ? _EmptyHint()
                : _NodeInfoCard(node: selected),
          ),
        ],
      ),
    );
  }
}

class _NodeButton extends StatelessWidget {
  final MacroFlowNode node;
  final bool selected;
  final VoidCallback onTap;

  const _NodeButton({
    required this.node,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: selected ? AppTheme.violet.withOpacity(0.25) : AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.goldBright : AppTheme.violet.withOpacity(0.4),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(node.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  node.label,
                  style: TextStyle(
                    color: selected ? AppTheme.goldBright : AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                selected ? Icons.expand_less : Icons.expand_more,
                color: AppTheme.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NodeInfoCard extends StatelessWidget {
  final MacroFlowNode node;
  const _NodeInfoCard({required this.node});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(node.id),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(node.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  node.label,
                  style: const TextStyle(
                    color: AppTheme.goldBright,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  node.text,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.textMuted.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.touch_app_outlined, color: AppTheme.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tocá un nodo del flujo para ver el detalle',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
