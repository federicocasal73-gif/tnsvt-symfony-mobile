import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/feed_post.dart';
import '../providers/feed_provider.dart';
import '../services/image_service.dart';

class FeedComposeScreen extends StatefulWidget {
  const FeedComposeScreen({super.key});

  @override
  State<FeedComposeScreen> createState() => _FeedComposeScreenState();
}

class _FeedComposeScreenState extends State<FeedComposeScreen> {
  final _textCtrl = TextEditingController();
  final _imageService = ImageService();

  String _category = 'general';
  bool _showSignal = false;
  String? _photoBase64;

  final _assetCtrl = TextEditingController();
  final _entryCtrl = TextEditingController();
  final _slCtrl = TextEditingController();
  final _tp1Ctrl = TextEditingController();
  final _tp2Ctrl = TextEditingController();
  String _dir = 'BUY';

  @override
  void dispose() {
    _textCtrl.dispose();
    _assetCtrl.dispose();
    _entryCtrl.dispose();
    _slCtrl.dispose();
    _tp1Ctrl.dispose();
    _tp2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final base64 = await _imageService.pickImageAsBase64();
    if (base64 != null) setState(() => _photoBase64 = base64);
  }

  void _removeImage() => setState(() => _photoBase64 = null);

  Future<void> _publish() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty && _photoBase64 == null && !_showSignal) {
      _toast('Escribí algo o adjuntá una foto');
      return;
    }
    if (_showSignal && _assetCtrl.text.trim().isEmpty) {
      _toast('Indicá el activo para la señal');
      return;
    }

    SignalData? signal;
    if (_showSignal) {
      signal = SignalData(
        asset: _assetCtrl.text.trim().toUpperCase(),
        dir: _dir,
        entry: _entryCtrl.text.trim(),
        sl: _slCtrl.text.trim(),
        tp1: _tp1Ctrl.text.trim(),
        tp2: _tp2Ctrl.text.trim().isEmpty ? null : _tp2Ctrl.text.trim(),
      );
    }

    final feed = context.read<FeedProvider>();
    final ok = await feed.createPost(
      text: text,
      category: _category,
      signal: signal,
      photo: _photoBase64,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
      _toast('✅ Post publicado');
    } else {
      _toast('❌ Error al publicar');
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Post'),
        actions: [
          TextButton(
            onPressed: _publish,
            child: const Text(
              'PUBLICAR',
              style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('CATEGORÍA',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11,
                letterSpacing: 1,
              )),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: [
              _catChip('general', 'General'),
              _catChip('señales', 'Señal', icon: Icons.bolt),
              _catChip('resultados', 'Resultado'),
              _catChip('proyecciones', 'Proyección'),
              _catChip('pregunta', 'Pregunta'),
            ],
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _textCtrl,
            maxLines: 5,
            minLines: 3,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: const InputDecoration(
              hintText: '¿Qué querés compartir?',
              hintStyle: TextStyle(color: AppTheme.textMuted),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => setState(() => _showSignal = !_showSignal),
                icon: Icon(
                  _showSignal ? Icons.check_box : Icons.check_box_outline_blank,
                  color: _showSignal ? AppTheme.success : AppTheme.textSecondary,
                ),
                label: const Text('📊 Es señal'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: _showSignal
                        ? AppTheme.success
                        : AppTheme.violet.withOpacity(0.3),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _photoBase64 == null ? _pickImage : _removeImage,
                icon: Icon(
                  _photoBase64 == null ? Icons.add_photo_alternate : Icons.delete,
                  color: _photoBase64 == null
                      ? AppTheme.textSecondary
                      : AppTheme.danger,
                ),
                label: Text(_photoBase64 == null ? '📷 Foto' : 'Quitar foto'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: _photoBase64 == null
                        ? AppTheme.violet.withOpacity(0.3)
                        : AppTheme.danger.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),

          if (_showSignal) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.success.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📊 DATOS DE LA SEÑAL',
                      style: TextStyle(
                        color: AppTheme.success,
                        fontSize: 10,
                        letterSpacing: 1,
                      )),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _assetCtrl,
                          textCapitalization: TextCapitalization.characters,
                          style: const TextStyle(color: AppTheme.textPrimary),
                          decoration: const InputDecoration(
                            hintText: 'Activo (ej: NAS100)',
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButton<String>(
                          value: _dir,
                          underline: const SizedBox(),
                          dropdownColor: AppTheme.surfaceLight,
                          style: TextStyle(
                            color: _dir == 'BUY' ? AppTheme.success : AppTheme.danger,
                            fontWeight: FontWeight.bold,
                          ),
                          items: ['BUY', 'SELL']
                              .map((d) => DropdownMenuItem(
                                    value: d,
                                    child: Text(d),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => _dir = v ?? 'BUY'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _miniField(_entryCtrl, 'Entry')),
                      const SizedBox(width: 6),
                      Expanded(child: _miniField(_slCtrl, 'Stop')),
                      const SizedBox(width: 6),
                      Expanded(child: _miniField(_tp1Ctrl, 'TP1')),
                      const SizedBox(width: 6),
                      Expanded(child: _miniField(_tp2Ctrl, 'TP2')),
                    ],
                  ),
                ],
              ),
            ),
          ],

          if (_photoBase64 != null) ...[
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.violet.withOpacity(0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  ImageService.base64ToBytes(_photoBase64!),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _catChip(String value, String label, {IconData? icon}) {
    final active = value == _category;
    final accent = switch (value) {
      'señales' => AppTheme.gold,
      'resultados' => AppTheme.success,
      'proyecciones' => AppTheme.violet,
      'pregunta' => AppTheme.violet,
      _ => AppTheme.violet,
    };
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: active ? Colors.white : accent),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: active,
      onSelected: (_) {
        setState(() {
          _category = value;
          if (value == 'señales') _showSignal = true;
        });
      },
      selectedColor: accent,
      backgroundColor: AppTheme.surface,
      labelStyle: TextStyle(
        fontFamily: AppTheme.labelFont,
        color: active ? Colors.black : AppTheme.textSecondary,
        fontSize: 10,
        fontWeight: active ? FontWeight.bold : FontWeight.w600,
        letterSpacing: 1,
      ),
      side: BorderSide(
        color: active ? accent : accent.withOpacity(0.5),
      ),
    );
  }

  Widget _miniField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
    );
  }
}
