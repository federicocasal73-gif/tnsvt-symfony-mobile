import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme.dart';
import '../../data/macro_content.dart';

class MacroQuizScreen extends StatefulWidget {
  const MacroQuizScreen({super.key});

  @override
  State<MacroQuizScreen> createState() => _MacroQuizScreenState();
}

class _MacroQuizScreenState extends State<MacroQuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _revealed = false;
  bool _finished = false;

  void _select(int index) {
    if (_revealed) return;
    HapticFeedback.selectionClick();
    setState(() {
      _selectedOptionIndex = index;
      _revealed = true;
      if (index == MacroContent.quiz[_currentIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _next() {
    if (_currentIndex < MacroContent.quiz.length - 1) {
      HapticFeedback.lightImpact();
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _revealed = false;
      });
    } else {
      HapticFeedback.mediumImpact();
      setState(() => _finished = true);
    }
  }

  void _reset() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedOptionIndex = null;
      _revealed = false;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return _ResultView(score: _score, total: MacroContent.quiz.length, onReset: _reset);

    final q = MacroContent.quiz[_currentIndex];
    final isCorrect = _selectedOptionIndex == q.correctIndex;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: AppTheme.surface,
          child: Row(
            children: [
              Text(
                'Pregunta ${_currentIndex + 1}/${MacroContent.quiz.length}',
                style: const TextStyle(color: AppTheme.goldBright, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                'Score: $_score',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        LinearProgressIndicator(
          value: (_currentIndex + 1) / MacroContent.quiz.length,
          backgroundColor: AppTheme.surfaceLight,
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.goldBright),
          minHeight: 3,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.violet.withOpacity(0.3)),
                  ),
                  child: Text(
                    q.question,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < q.options.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _QuizOption(
                      option: q.options[i],
                      index: i,
                      isSelected: _selectedOptionIndex == i,
                      isCorrect: i == q.correctIndex,
                      revealed: _revealed,
                      onTap: () => _select(i),
                    ),
                  ),
                if (_revealed) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? AppTheme.success.withOpacity(0.12)
                          : AppTheme.danger.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isCorrect ? AppTheme.success : AppTheme.danger,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCorrect ? '✅' : '❌',
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isCorrect ? '¡Correcto!' : 'Incorrecto',
                                style: TextStyle(
                                  color: isCorrect ? AppTheme.success : AppTheme.danger,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                q.explanation,
                                style: TextStyle(
                                  color: isCorrect ? AppTheme.success : AppTheme.danger,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _next,
                    icon: Icon(_currentIndex == MacroContent.quiz.length - 1
                        ? Icons.flag
                        : Icons.arrow_forward),
                    label: Text(_currentIndex == MacroContent.quiz.length - 1
                        ? 'Ver resultado'
                        : 'Siguiente pregunta'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuizOption extends StatelessWidget {
  final MacroOption option;
  final int index;
  final bool isSelected;
  final bool isCorrect;
  final bool revealed;
  final VoidCallback onTap;

  const _QuizOption({
    required this.option,
    required this.index,
    required this.isSelected,
    required this.isCorrect,
    required this.revealed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppTheme.violet.withOpacity(0.3);
    Color bg = AppTheme.surface;
    Color textColor = AppTheme.textPrimary;
    Color letterBg = AppTheme.violet.withOpacity(0.2);
    Color letterText = AppTheme.violet;

    if (revealed) {
      if (isCorrect) {
        borderColor = AppTheme.success;
        bg = AppTheme.success.withOpacity(0.15);
        textColor = AppTheme.success;
        letterBg = AppTheme.success;
        letterText = Colors.black;
      } else if (isSelected && !isCorrect) {
        borderColor = AppTheme.danger;
        bg = AppTheme.danger.withOpacity(0.15);
        textColor = AppTheme.danger;
        letterBg = AppTheme.danger;
        letterText = Colors.black;
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: revealed && (isCorrect || isSelected) ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: letterBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  option.letter,
                  style: TextStyle(color: letterText, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option.text,
                  style: TextStyle(color: textColor, fontSize: 14, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onReset;

  const _ResultView({required this.score, required this.total, required this.onReset});

  @override
  Widget build(BuildContext context) {
    final List<List<String>> tiers = [
      ['Seguí estudiando 💪', 'La macroeconomía se aprende con repetición.'],
      ['Vas por buen camino 📈', 'Tenés las bases sólidas.'],
      ['Nivel Avanzado ⭐', 'Entendés el ciclo macro y la geopolítica.'],
      ['Dominio Estructural 🏆', 'Excelente. Combiná con análisis técnico.'],
    ];
    final int t = score < 4 ? 0 : score < 7 ? 1 : score < 9 ? 2 : 3;
    final colorForTier = [AppTheme.textMuted, AppTheme.warning, AppTheme.violet, AppTheme.goldBright];
    final color = colorForTier[t];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏁', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            const Text(
              'Resultado',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              '$score/$total',
              style: const TextStyle(
                color: AppTheme.goldBright,
                fontSize: 56,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    tiers[t][0],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: color,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tiers[t][1],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Volver a intentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
