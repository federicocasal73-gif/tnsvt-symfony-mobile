# TNSVT Mobile — Backlog & Workflow

Este archivo es la lista de cosas que faltan o se pueden mejorar.
Para agregar algo nuevo: editá este archivo, agregá una línea con el
formato `### [categoria] titulo corto — descripcion de 1 linea`.

Categorias: `feat`, `fix`, `ui`, `api`, `data`, `web-parity`.

## Workflow para pedir cambios

1. Decime "mira el TODO" o "agrega X al TODO"
2. Yo actualizo este archivo con la propuesta + checkboxes
3. Vos decis "dale" o "no" a cada item
4. Yo implemento los aprobados, marco el checkbox, commit + tag

Ejemplo de pedido:
> "agrega al TODO: feat, dark mode automatico segun hora del sistema"

---

## Pendiente

### [ui] HomeScreen — header con T.N.S.V.T + subtitulo
El Hub ya tiene "Reino del Cristo Integro" en AppBar. El HomeScreen (que aparece al tocar el hex del Hub) NO lo tiene. Agregar mismo subtitulo debajo del titulo "T.N.S.V.T" en home_screen.dart.

### [web-parity] † trigger circle abajo del Hub
El web tiene un circulo pequeño con "†" en el bottom del Hub. Decorar el Hub del mobile con un elemento similar (no navega, solo visual, anima con el pulso de los nodos).

### [web-parity] 2 Pasos — requisitos reales
La sub-tab 2 Pasos esta lockeada siempre. Web probablemente chequea requisitos (completar multifractal + 30 dias). Agregar chequeo real contra TasksProvider (cuantas tareas completadas) + storage local (fecha primer trade).

### [feat] Editar perfil
El web permite editar el codename custom (el "Alma Electa" hardcodeado). Agregar screen `EditProfileScreen` con input para `display_name` y persistir en backend (campo nuevo en User entity o tabla separada).

### [feat] Chat de Ejecutores — imagenes y adjuntos
El chat actual es solo texto. Web permite mandar imagenes. Agregar ImageService.pickImageAsBase64() al input del chat + endpoint backend `/api/chat/{id}/upload` (ver si ya existe en ChatController).

### [ui] PostCard — reactions backend-persisted
Las 3 reacciones (like/love/fire) son UI-local. Web no parece tenerlas. Decidir: (a) persistir en backend via nuevo endpoint `POST /api/posts/{id}/react` con body `{type: 'love'}`, o (b) dejar como UI-only. Opcion (a) es lo correcto para sincronizar entre devices.

### [data] Trade entity — falta campo `date` en create
El backend JournalController.create recibe `date` opcional pero el mobile no lo manda (siempre usa NOW). Agregar DatePicker al editor para registrar trades pasados (importante para backfill de journal).

### [fix] 2 Pasos tab — title overflow
El tab "2 Pasos" con candado es ancho. En pantallas chicas (Fold 6 cerrado) puede hacer overflow. Verificar.

### [feat] Admin panel — tasks reorder
Las tareas se muestran por `orden` ASC pero no hay UI para reordenarlas. Agregar long-press drag & drop en admin_tasks_tab.dart (usar `ReorderableListView`).

---

## Completado recientemente

- v1.2 (2026-06-13): ~~Journal con fotos~~ + ~~Calendar live ForexFactory~~
- v1.1 (2026-06-13): Calendar Economico + reacciones like/love/fire
- v1.0 (2026-06-13): Hub iluminado + Cristo Integro como gateway
- v0.9 (2026-06-13): 2 Pasos locked + Trading Journal
- v0.8 (2026-06-13): Profile web-style + feed chips con color + push banner
- v0.7 (2026-06-13): Hub como gateway post-login
- v0.6 (2026-06-13): Fonts Cinzel + Orbitron + Hub Central
- v0.5 (2026-06-13): Auth fixes + admin panel UX
- v0.4 (2026-06-13): FCM end-to-end push notifications
- v0.3 (2026-06-13): Seccion MACRO completa
- v0.2 (2026-06-13): Login + auth + first sections
