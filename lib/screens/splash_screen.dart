import 'package:flutter/material.dart';
import '../config/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.gold, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.gold.withOpacity(0.2),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Center(
                child: Text('⛧',
                    style: TextStyle(color: AppTheme.goldBright, fontSize: 48)),
              ),
            ),
            const SizedBox(height: 24),
            const Text('T.N.S.V.T',
                style: TextStyle(
                  color: AppTheme.goldBright,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                )),
            const SizedBox(height: 8),
            const Text('NEURO-SPIRITUAL VALUE THEORY',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                  letterSpacing: 2,
                )),
            const SizedBox(height: 30),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppTheme.gold,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
