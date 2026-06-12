import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/feed_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'services/image_service.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.user == null) {
      return const LoginScreen();
    }
    return const HomeScreen();
  }
}

