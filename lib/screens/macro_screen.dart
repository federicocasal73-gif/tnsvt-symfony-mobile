import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'macro/macro_overview_screen.dart';
import 'macro/macro_calculator_screen.dart';
import 'macro/macro_cycle_screen.dart';
import 'macro/macro_concepts_screen.dart';
import 'macro/macro_quiz_screen.dart';
import 'macro/macro_two_steps_screen.dart';

class MacroScreen extends StatelessWidget {
  const MacroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('MACRO'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            indicatorColor: AppTheme.goldBright,
            labelColor: AppTheme.goldBright,
            unselectedLabelColor: AppTheme.textMuted,
            tabs: const [
              Tab(icon: Icon(Icons.account_tree_outlined), text: 'Flujo'),
              Tab(icon: Icon(Icons.calculate_outlined), text: 'Calculadora'),
              Tab(icon: Icon(Icons.refresh), text: 'Ciclo'),
              Tab(icon: Icon(Icons.menu_book_outlined), text: 'Conceptos'),
              Tab(icon: Icon(Icons.quiz_outlined), text: 'Quiz'),
              Tab(
                icon: Icon(Icons.lock_outline, size: 18),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('2 Pasos',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                    SizedBox(width: 4),
                    Icon(Icons.lock, size: 12, color: AppTheme.danger),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MacroOverviewScreen(),
            MacroCalculatorScreen(),
            MacroCycleScreen(),
            MacroConceptsScreen(),
            MacroQuizScreen(),
            MacroTwoStepsScreen(),
          ],
        ),
      ),
    );
  }
}
