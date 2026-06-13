import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/macro_content.dart';

class MacroConceptsScreen extends StatefulWidget {
  const MacroConceptsScreen({super.key});

  @override
  State<MacroConceptsScreen> createState() => _MacroConceptsScreenState();
}

class _MacroConceptsScreenState extends State<MacroConceptsScreen> {
  final Set<String> _expandedIds = {};

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: MacroContent.concepts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final concept = MacroContent.concepts[i];
        final isOpen = _expandedIds.contains(concept.id);
        return _ConceptCard(
          concept: concept,
          isOpen: isOpen,
          onToggle: () {
            setState(() {
              if (isOpen) {
                _expandedIds.remove(concept.id);
              } else {
                _expandedIds.add(concept.id);
              }
            });
          },
        );
      },
    );
  }
}

class _ConceptCard extends StatelessWidget {
  final MacroConcept concept;
  final bool isOpen;
  final VoidCallback onToggle;

  const _ConceptCard({
    required this.concept,
    required this.isOpen,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOpen ? AppTheme.goldBright : AppTheme.violet.withOpacity(0.3),
          width: isOpen ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(concept.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          concept.title,
                          style: TextStyle(
                            color: isOpen ? AppTheme.goldBright : AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${concept.inlineQuizzes.length} pregunta${concept.inlineQuizzes.length == 1 ? '' : 's'}',
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isOpen ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.textMuted,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: AppTheme.textMuted),
                  const SizedBox(height: 12),
                  Text(
                    concept.summary,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final q in concept.inlineQuizzes) ...[
                    _InlineQuizCard(quiz: q, key: ValueKey(q.id)),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineQuizCard extends StatefulWidget {
  final MacroInlineQuiz quiz;
  const _InlineQuizCard({required this.quiz, super.key});

  @override
  State<_InlineQuizCard> createState() => _InlineQuizCardState();
}

class _InlineQuizCardState extends State<_InlineQuizCard> {
  String? _selectedLetter;
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final isCorrect = _selectedLetter == widget.quiz.correctLetter;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.violet.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.quiz.question,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          for (final opt in widget.quiz.options)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _OptionButton(
                option: opt,
                isSelected: _selectedLetter == opt.letter,
                isCorrect: opt.letter == widget.quiz.correctLetter,
                revealed: _revealed,
                onTap: _revealed
                    ? null
                    : () => setState(() {
                          _selectedLetter = opt.letter;
                          _revealed = true;
                        }),
              ),
            ),
          if (_revealed) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppTheme.success.withOpacity(0.15)
                    : AppTheme.danger.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isCorrect ? AppTheme.success : AppTheme.danger,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCorrect ? '✅' : '❌',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.quiz.explanation,
                      style: TextStyle(
                        color: isCorrect ? AppTheme.success : AppTheme.danger,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final MacroOption option;
  final bool isSelected;
  final bool isCorrect;
  final bool revealed;
  final VoidCallback? onTap;

  const _OptionButton({
    required this.option,
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
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor, width: revealed && (isCorrect || isSelected) ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: letterBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  option.letter,
                  style: TextStyle(color: letterText, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  option.text,
                  style: TextStyle(color: textColor, fontSize: 13, height: 1.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
