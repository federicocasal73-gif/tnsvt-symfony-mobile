import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../models/trade.dart';
import '../providers/auth_provider.dart';
import '../providers/journal_provider.dart';

class TradingJournalScreen extends StatefulWidget {
  const TradingJournalScreen({super.key});

  @override
  State<TradingJournalScreen> createState() => _TradingJournalScreenState();
}

class _TradingJournalScreenState extends State<TradingJournalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userCode = context.read<AuthProvider>().userCode;
      if (userCode != null) {
        context.read<JournalProvider>().fetch(userCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final journal = context.watch<JournalProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('📊 TRADING JOURNAL'),
      ),
      body: RefreshIndicator(
        color: AppTheme.gold,
        onRefresh: () async {
          if (auth.userCode != null) {
            await journal.fetch(auth.userCode!);
          }
        },
        child: _buildBody(journal),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        backgroundColor: AppTheme.gold,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: Text('NUEVO TRADE',
            style: TextStyle(
                fontFamily: AppTheme.labelFont,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1)),
      ),
    );
  }

  Widget _buildBody(JournalProvider journal) {
    if (journal.loading && journal.trades.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.gold),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
      children: [
        if (journal.trades.isNotEmpty) _buildStats(journal),
        const SizedBox(height: 12),
        if (journal.trades.isEmpty)
          _buildEmpty()
        else
          ...journal.trades.map((t) => _tradeTile(t)),
      ],
    );
  }

  Widget _buildStats(JournalProvider j) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _statBox('TRADES', '${j.trades.length}', AppTheme.goldBright),
          _divider(),
          _statBox('WINS', '${j.wins}', AppTheme.success),
          _divider(),
          _statBox('LOSS', '${j.losses}', AppTheme.danger),
          _divider(),
          _statBox('P/L', j.totalPnl.toStringAsFixed(0),
              j.totalPnl >= 0 ? AppTheme.success : AppTheme.danger),
          _divider(),
          _statBox('WIN %', j.winRate.toStringAsFixed(0) + '%', AppTheme.violet),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 30, color: AppTheme.gold.withOpacity(0.2));

  Widget _statBox(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                fontFamily: AppTheme.labelFont,
                color: AppTheme.textMuted,
                fontSize: 8,
                letterSpacing: 1,
              )),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                fontFamily: AppTheme.labelFont,
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              )),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Icon(Icons.assessment_outlined, color: AppTheme.textMuted, size: 60),
          const SizedBox(height: 16),
          Text('Sin trades registrados',
              style: TextStyle(
                fontFamily: AppTheme.displayFont,
                color: AppTheme.goldBright,
                fontSize: 16,
                letterSpacing: 1,
              )),
          const SizedBox(height: 8),
          Text(
            'Tocá NUEVO TRADE para registrar tu primera operación.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.labelFont,
              color: AppTheme.textSecondary,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tradeTile(Trade t) {
    final accent = t.isWin
        ? AppTheme.success
        : t.isLoss
            ? AppTheme.danger
            : AppTheme.violet;
    final dateFmt = t.date != null ? DateFormat('dd/MM HH:mm').format(t.date!.toLocal()) : '—';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(left: BorderSide(color: accent, width: 3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(t.asset,
                    style: TextStyle(
                      fontFamily: AppTheme.displayFont,
                      color: AppTheme.goldBright,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    )),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: t.dir == 'BUY' ? AppTheme.success.withOpacity(0.2) : AppTheme.danger.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(t.dir,
                    style: TextStyle(
                      fontFamily: AppTheme.labelFont,
                      color: t.dir == 'BUY' ? AppTheme.success : AppTheme.danger,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(width: 6),
              Text(t.result,
                  style: TextStyle(
                    fontFamily: AppTheme.labelFont,
                    color: accent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  )),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            [
              if (t.entry != null && t.entry!.isNotEmpty) 'E ${t.entry}',
              if (t.sl != null && t.sl!.isNotEmpty) 'SL ${t.sl}',
              if (t.tp != null && t.tp!.isNotEmpty) 'TP ${t.tp}',
            ].join('  ·  '),
            style: TextStyle(
              fontFamily: AppTheme.labelFont,
              color: AppTheme.textSecondary,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateFmt,
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  )),
              Text(
                t.pnl == 0 ? '—' : (t.pnl > 0 ? '+' : '') + t.pnl.toStringAsFixed(0),
                style: TextStyle(
                  fontFamily: AppTheme.labelFont,
                  color: t.pnl > 0 ? AppTheme.success : t.pnl < 0 ? AppTheme.danger : AppTheme.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (t.notes != null && t.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(t.notes!,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                )),
          ],
        ],
      ),
    );
  }

  void _openEditor(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _TradeEditor(),
    );
  }
}

class _TradeEditor extends StatefulWidget {
  const _TradeEditor();

  @override
  State<_TradeEditor> createState() => _TradeEditorState();
}

class _TradeEditorState extends State<_TradeEditor> {
  final _asset = TextEditingController();
  final _entry = TextEditingController();
  final _sl = TextEditingController();
  final _tp = TextEditingController();
  final _pnl = TextEditingController();
  final _notes = TextEditingController();
  String _dir = 'BUY';
  String _result = 'OPEN';
  bool _saving = false;

  @override
  void dispose() {
    _asset.dispose();
    _entry.dispose();
    _sl.dispose();
    _tp.dispose();
    _pnl.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_asset.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Indicá el activo')),
      );
      return;
    }
    setState(() => _saving = true);
    final auth = context.read<AuthProvider>();
    final journal = context.read<JournalProvider>();
    final ok = await journal.create(auth.userCode ?? '', {
      'asset': _asset.text.trim().toUpperCase(),
      'dir': _dir,
      'entry': _entry.text.trim(),
      'sl': _sl.text.trim(),
      'tp': _tp.text.trim(),
      'result': _result,
      'pnl': double.tryParse(_pnl.text.trim()) ?? 0,
      'notes': _notes.text.trim(),
    });
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${journal.error ?? "desconocido"}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.gold.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('REGISTRAR TRADE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.displayFont,
                  color: AppTheme.goldBright,
                  fontSize: 16,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _asset,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'ACTIVO',
                      labelStyle: TextStyle(color: AppTheme.gold, fontSize: 11, letterSpacing: 1.5),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _dirDropdown(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _mini(_entry, 'Entry')),
                const SizedBox(width: 6),
                Expanded(child: _mini(_sl, 'Stop')),
                const SizedBox(width: 6),
                Expanded(child: _mini(_tp, 'TP')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _mini(_pnl, 'P/L (pips o USD)'),
                ),
                const SizedBox(width: 6),
                Expanded(child: _resultDropdown()),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notes,
              maxLines: 3,
              minLines: 2,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'NOTAS',
                labelStyle: TextStyle(color: AppTheme.gold, fontSize: 11, letterSpacing: 1.5),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                    )
                  : const Icon(Icons.save),
              label: const Text('GUARDAR TRADE'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _dirDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border.all(color: AppTheme.gold.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: _dir,
        underline: const SizedBox(),
        isExpanded: true,
        dropdownColor: AppTheme.surfaceLight,
        style: TextStyle(
          color: _dir == 'BUY' ? AppTheme.success : AppTheme.danger,
          fontWeight: FontWeight.bold,
        ),
        items: ['BUY', 'SELL']
            .map((d) => DropdownMenuItem(value: d, child: Text(d)))
            .toList(),
        onChanged: (v) => setState(() => _dir = v ?? 'BUY'),
      ),
    );
  }

  Widget _resultDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border.all(color: AppTheme.gold.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: _result,
        underline: const SizedBox(),
        isExpanded: true,
        dropdownColor: AppTheme.surfaceLight,
        style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
        items: const [
          DropdownMenuItem(value: 'OPEN', child: Text('OPEN')),
          DropdownMenuItem(value: 'WIN', child: Text('WIN')),
          DropdownMenuItem(value: 'LOSS', child: Text('LOSS')),
          DropdownMenuItem(value: 'BE', child: Text('BREAK EVEN')),
        ],
        onChanged: (v) => setState(() => _result = v ?? 'OPEN'),
      ),
    );
  }

  Widget _mini(TextEditingController c, String label) {
    return TextField(
      controller: c,
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1.5),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
    );
  }
}
