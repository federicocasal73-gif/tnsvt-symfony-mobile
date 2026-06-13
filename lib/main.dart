import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/feed_provider.dart';
import 'providers/academia_provider.dart';
import 'providers/tasks_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/admin_provider.dart';
import 'providers/journal_provider.dart';
import 'screens/login_screen.dart';
import 'screens/hub_screen.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';
import 'services/image_service.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.instance.init();
  runApp(const TnsvtApp());
}

class TnsvtApp extends StatelessWidget {
  const TnsvtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<StorageService>(create: (_) => StorageService()),
        Provider<ImageService>(create: (_) => ImageService()),
        ChangeNotifierProvider<AuthProvider>(
          create: (ctx) => AuthProvider(
            ctx.read<ApiService>(),
            ctx.read<StorageService>(),
          )..tryRestoreSession(),
        ),
        ChangeNotifierProvider<FeedProvider>(
          create: (ctx) => FeedProvider(
            ctx.read<ApiService>(),
            ctx.read<AuthProvider>(),
          ),
        ),
        ChangeNotifierProvider<AcademiaProvider>(
          create: (ctx) => AcademiaProvider(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider<TasksProvider>(
          create: (ctx) => TasksProvider(
            ctx.read<ApiService>(),
            ctx.read<StorageService>(),
          ),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (ctx) => ChatProvider(
            ctx.read<ApiService>(),
            ctx.read<AuthProvider>(),
          ),
        ),
        ChangeNotifierProvider<AdminProvider>(
          create: (ctx) => AdminProvider(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider<JournalProvider>(
          create: (ctx) => JournalProvider(ctx.read<ApiService>()),
        ),
      ],
      child: MaterialApp(
        title: 'T.N.S.V.T Mobile',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    // Mostrar splash un instante mínimo
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const SplashScreen();
    final auth = context.watch<AuthProvider>();
    if (auth.user == null) {
      return const LoginScreen();
    }
    return const HubScreen();
  }
}
