import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class MacroTwoStepsScreen extends StatelessWidget {
  const MacroTwoStepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surface,
                  border: Border.all(color: AppTheme.danger.withOpacity(0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.danger.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.lock_outline, color: AppTheme.danger, size: 48),
              ),
              const SizedBox(height: 24),
              Text(
                'METODOLOGÍA 2 STEPS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.displayFont,
                  color: AppTheme.goldBright,
                  fontSize: 18,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.danger.withOpacity(0.15),
                  border: Border.all(color: AppTheme.danger.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '🔒 BLOQUEADO',
                  style: TextStyle(
                    fontFamily: AppTheme.labelFont,
                    color: AppTheme.danger,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Edición Completa',
                style: TextStyle(
                  fontFamily: AppTheme.displayFont,
                  color: AppTheme.violet,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Trading Neuro-Spiritual Value Theory (2026)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.labelFont,
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.workspace_premium, color: AppTheme.gold, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Acceso exclusivo para discípulos avanzados',
                            style: TextStyle(
                              fontFamily: AppTheme.labelFont,
                              color: AppTheme.textPrimary,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.checklist, color: AppTheme.success, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Completar los módulos del Multifractal',
                            style: TextStyle(
                              fontFamily: AppTheme.labelFont,
                              color: AppTheme.textPrimary,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.timeline, color: AppTheme.violet, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '30 días de operación consistente',
                            style: TextStyle(
                              fontFamily: AppTheme.labelFont,
                              color: AppTheme.textPrimary,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
