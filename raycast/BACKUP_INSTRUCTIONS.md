# Инструкции по backup и восстановлению Raycast

## Файлы для backup (БЕЗ облачной синхронизации)

Так как аккаунта Raycast нет, нужно копировать файлы вручную.

### 1. Основная конфигурация

**Источник:** `~/Library/Application Support/com.raycast.macos/`

**Что копировать:**

```bash
# Основные базы данных (содержат все настройки, хоткеи, aliases)
raycast-enc.sqlite
raycast-enc.sqlite-shm
raycast-enc.sqlite-wal

# База активности (история, кеш - опционально)
raycast-activities-enc.sqlite
raycast-activities-enc.sqlite-shm
raycast-activities-enc.sqlite-wal

# Кеш эмодзи (опционально)
raycast-emoji.sqlite
raycast-emoji.sqlite-shm
raycast-emoji.sqlite-wal

# Установленные расширения (ОБЯЗАТЕЛЬНО)
extensions/

# NodeJS runtime для расширений
NodeJS/
```

**Важно:** `-shm` и `-wal` файлы - это части SQLite базы (Shared Memory и Write-Ahead Log). Копируйте их вместе с основными `.sqlite` файлами.

### 2. System Preferences

**Источник:** `~/Library/Preferences/`

```bash
com.raycast.macos.plist
```

Содержит системные настройки (позиция окна, некоторые UI preferences).

## Команды для backup

### Создать backup

```bash
# Создать директорию backup
mkdir -p ~/Documents/macos-dotfiles/raycast/backup

# Скопировать основную конфигурацию
cp -R ~/Library/Application\ Support/com.raycast.macos/extensions ~/Documents/macos-dotfiles/raycast/
cp -R ~/Library/Application\ Support/com.raycast.macos/NodeJS ~/Documents/macos-dotfiles/raycast/backup/

# Скопировать базы данных
cp ~/Library/Application\ Support/com.raycast.macos/raycast-enc.sqlite* ~/Documents/macos-dotfiles/raycast/backup/
cp ~/Library/Application\ Support/com.raycast.macos/raycast-activities-enc.sqlite* ~/Documents/macos-dotfiles/raycast/backup/
cp ~/Library/Application\ Support/com.raycast.macos/raycast-emoji.sqlite* ~/Documents/macos-dotfiles/raycast/backup/

# Скопировать plist
cp ~/Library/Preferences/com.raycast.macos.plist ~/Documents/macos-dotfiles/raycast/backup/
```

### Восстановить на новой машине

**Быстрый способ (рекомендуется):**

```bash
# 1. Установить Raycast
brew install --cask raycast

# 2. Запустить скрипт восстановления
./scripts/raycast_restore.sh
```

Скрипт автоматически:
- Проверит наличие backup
- Закроет Raycast если запущен
- Восстановит все файлы
- Установит правильные права доступа
- Предложит запустить Raycast

**Ручной способ:**

```bash
# 1. Установить Raycast через Homebrew
brew install --cask raycast

# 2. ВАЖНО: Запустить Raycast один раз, затем полностью закрыть
# Это создаст базовую структуру директорий

# 3. Закрыть Raycast полностью (Cmd+Q)
killall Raycast

# 4. Восстановить файлы
RAYCAST_DIR="$HOME/Library/Application Support/com.raycast.macos"
BACKUP_DIR="$HOME/Documents/macos-dotfiles/raycast/backup"

# Удалить дефолтные файлы
rm -f "$RAYCAST_DIR"/raycast*.sqlite*

# Копировать базы данных
cp "$BACKUP_DIR"/raycast-enc.sqlite* "$RAYCAST_DIR"/
cp "$BACKUP_DIR"/raycast-activities-enc.sqlite* "$RAYCAST_DIR"/
cp "$BACKUP_DIR"/raycast-emoji.sqlite* "$RAYCAST_DIR"/

# Копировать расширения
rm -rf "$RAYCAST_DIR/extensions"
cp -R ~/Documents/macos-dotfiles/raycast/extensions "$RAYCAST_DIR/"

# Копировать NodeJS runtime
rm -rf "$RAYCAST_DIR/NodeJS"
cp -R "$BACKUP_DIR/NodeJS" "$RAYCAST_DIR/"

# Копировать plist
cp "$BACKUP_DIR/com.raycast.macos.plist" ~/Library/Preferences/

# 5. Запустить Raycast
open -a Raycast
```

## Что содержит каждый файл

### raycast-enc.sqlite (ОБЯЗАТЕЛЬНО)
- Хоткеи (Ctrl+Space)
- Aliases для команд
- Настройки расширений
- Сниппеты
- Quicklinks
- Все персональные настройки UI

### extensions/ (ОБЯЗАТЕЛЬНО)
- Скомпилированный код установленных расширений:
  - `0e43920f-bbf6-4582-bc3f-5f63092c915f` - Google Translate
  - `320f40ef-a633-415a-ab0e-1e99515478f7` - Spotify Player
  - и другие

### NodeJS/ (ОБЯЗАТЕЛЬНО)
- Node.js runtime для выполнения расширений
- Без него расширения не будут работать

### raycast-activities-enc.sqlite (опционально)
- История команд
- Frequently used
- Recent items

### raycast-emoji.sqlite (опционально)
- Кеш emoji для быстрого поиска

### com.raycast.macos.plist (желательно)
- Позиция окна
- Некоторые UI preferences
- System-level настройки

## Размеры (для справки)

```
extensions/          ~3.3 MB
raycast-enc.sqlite   ~1.5 MB + WAL ~4 MB
NodeJS/              ~varies
```

## .gitignore

Данные Raycast не коммитятся - репозиторий публичный. В `.gitignore`:

```gitignore
raycast/backup/
raycast/extensions/
raycast/config.json
raycast/ai/
```

Базы зашифрованы, но содержат историю буфера обмена, сниппеты и заметки,
а кэш расширений хранит данные аккаунтов (Spotify и т.п.) открытым текстом.
Переносите бэкап между машинами напрямую: через AirDrop, внешний диск или
приватное облако.

## Важные замечания

1. **Расширения:** При восстановлении расширения должны работать сразу, так как копируется скомпилированный код

2. **Хоткеи:** Настройка `Ctrl+Space` сохраняется в `raycast-enc.sqlite`, восстановится автоматически

3. **Spotlight:** После восстановления не забудьте отключить Spotlight в System Settings

4. **Первый запуск:** Если после восстановления Raycast попросит авторизацию - просто закройте это окно, всё будет работать и без аккаунта

5. **Обновления расширений:** Без аккаунта расширения не будут обновляться автоматически. Нужно будет обновлять вручную через Store или переустанавливать

## Альтернатива: Использовать аккаунт Raycast

Если создать бесплатный аккаунт Raycast:
- Всё синхронизируется автоматически
- Расширения устанавливаются автоматически
- Настройки переносятся между машинами
- НЕ нужно копировать файлы вручную

Но если принципиально без аккаунта - следуйте инструкциям выше.
