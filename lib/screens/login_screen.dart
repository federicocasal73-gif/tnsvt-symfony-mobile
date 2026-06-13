import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _codeCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _passFocus = FocusNode();
  bool _showPassword = false;
  bool _showAdminHint = false;

  @override
  void initState() {
    super.initState();
    _codeCtrl.addListener(_onCodeChanged);
  }

  void _onCodeChanged() {
    final code = _codeCtrl.text.trim().toUpperCase();
    final shouldShow = code == 'ADMIN01';
    if (shouldShow != _showPassword) {
      setState(() => _showPassword = shouldShow);
    }
    if (shouldShow != _showAdminHint) {
      setState(() => _showAdminHint = shouldShow);
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _passCtrl.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) {
      _showToast('⚠️ Ingresá tu código de acceso');
      return;
    }
    final password = _passCtrl.text.trim();
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(code, password: password.isEmpty ? null : password);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      _showToast('❌ ${auth.error ?? "Código inválido"}');
    }
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border.all(color: AppTheme.violet.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.gold.withOpacity(0.15),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⛧ T.N.S.V.T ⛧',
                    style: TextStyle(
                        fontFamily: AppTheme.displayFont,
                        color: AppTheme.goldBright,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4)),
                const SizedBox(height: 8),
                const Text('NEURO-SPIRITUAL VALUE THEORY',
                    style: TextStyle(
                        fontFamily: AppTheme.labelFont,
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                TextField(
                  controller: _codeCtrl,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'TU CÓDIGO DE ACCESO',
                    hintStyle: const TextStyle(color: AppTheme.textMuted),
                    prefixIcon: const Icon(Icons.key, color: AppTheme.gold),
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => _showPassword ? _passFocus.requestFocus() : _doLogin(),
                ),
                if (_showPassword) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passCtrl,
                    focusNode: _passFocus,
                    obscureText: true,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'CONTRASEÑA (solo admin)',
                      hintStyle: const TextStyle(color: AppTheme.textMuted),
                      prefixIcon: const Icon(Icons.lock, color: AppTheme.gold),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _doLogin(),
                  ),
                ],
                if (_showAdminHint) ...[
                  const SizedBox(height: 8),
                  const Text('👑 Admin: ingresá tu contraseña',
                      style: TextStyle(color: AppTheme.gold, fontSize: 12)),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.loading ? null : _doLogin,
                    child: auth.loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.black),
                          )
                        : const Text('ENTRAR AL GATEWAY',
                            style: TextStyle(
                                fontFamily: AppTheme.labelFont,
                                fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

