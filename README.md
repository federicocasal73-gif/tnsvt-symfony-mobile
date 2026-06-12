# T.N.S.V.T Mobile

App Android/iOS/Web hecha con **Flutter** que consume la API del proyecto TNSVT-Symfony.

## Stack

- **Flutter 3.24.5** (Dart 3.5.4)
- **Dio** para HTTP
- **Provider** para state management
- **shared_preferences** para storage local

## Setup

### 1. Instalar Flutter
Descargar de https://docs.flutter.dev/get-started/install/windows

### 2. Configurar backend
El backend Symfony debe estar corriendo en `http://localhost:8000` con CORS habilitado.

### 3. URL base

Por defecto la app apunta a `http://10.0.2.2:8000` (IP del host desde el emulador Android).

Para apuntar a otra URL, compilar con:
```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:8000
```

## Correr

```bash
# Instalar deps
flutter pub get

# Web (rápido para probar)
flutter run -d chrome

# Android emulator
flutter emulators --launch <emulator_id>
flutter run

# Build APK
flutter build apk --release
# APK queda en build/app/outputs/flutter-apk/app-release.apk
```

## Estructura

```
lib/
├── config/       # API config, theme
├── models/       # User, FeedPost, etc
├── services/     # ApiService, StorageService
├── providers/    # Auth, Feed, Chat (state)
├── screens/      # Login, Home, Feed, Academia, Chat, etc
├── widgets/      # Componentes reutilizables
└── main.dart
```

## Login

- **Alumno:** código `ALUMNO01` a `ALUMNO11` (sin contraseña)
- **Admin:** código `ADMIN01` + contraseña `admin:TNSVT`

## Estado actual

✅ Fases 0-1 completas (setup + login + navegación)
⏳ Fases 2-7 pendientes (feed, academia, journal, chat, tareas, admin)
