# Raycast Configuration

Конфигурация для [Raycast](https://www.raycast.com/) - productivity launcher для macOS, заменяющий стандартный Spotlight.

## Содержание

- `BACKUP_INSTRUCTIONS.md` - инструкции по backup и восстановлению
- `backup/`, `extensions/` - локальные данные, создаются скриптами и НЕ коммитятся
- `ai/` - настройки AI функций (если используются)

Список установленных расширений ниже - он и есть та самая reference-информация,
которая нужна для переноса. Сами данные Raycast в репозитории не хранятся.

## Установленные расширения

### Основные

- **Spotify Player** (`spotify-player`) - управление Spotify
  - Поиск треков, альбомов, артистов, подкастов
  - Управление воспроизведением (play/pause, next, previous)
  - Добавление в плейлисты, создание радио
  - Menu bar плеер с отображением текущего трека
  - Управление громкостью и устройствами воспроизведения

- **Google Translate** (`translate`) - быстрый перевод
  - Мгновенный перевод выделенного текста
  - Автоматическое определение языка
  - Копирование или вставка перевода
  - Поддержка множества языковых пар

- **URL Encoder/Decoder** - кодирование/декодирование URL

- **Noview** - дополнительное расширение для работы с заметками

## Автоматическая установка

Установка Raycast выполняется автоматически через основной скрипт:

```bash
./scripts/setup.sh
```

Raycast устанавливается вместе с другими GUI приложениями через Homebrew.

## Настройка после установки

### 1. Отключить Spotlight

Так как используется только Raycast, отключите Spotlight:

1. Откройте **System Settings > Siri & Spotlight**
2. Снимите галочку с **Keyboard shortcut** или измените на другую комбинацию
3. Также можно отключить **Show Spotlight search** полностью

Альтернативно через терминал:
```bash
# Отключить Spotlight indexing (опционально, если вообще не нужен)
sudo mdutil -a -i off
```

### 2. Настроить горячую клавишу

1. Запустите Raycast
2. Откройте настройки (Cmd+,)
3. В разделе "General" установите:
   - **Raycast Hotkey**: `Ctrl + Space`

### 3. Настройка без аккаунта

Аккаунт Raycast НЕ используется. Все настройки и расширения хранятся локально в:
- `~/Library/Application Support/com.raycast.macos/`

Для переноса на новую машину см. **[BACKUP_INSTRUCTIONS.md](BACKUP_INSTRUCTIONS.md)**

### 4. Установить расширения

Расширения устанавливаются через встроенный Store:

1. Откройте Raycast (Ctrl+Space)
2. Введите "Store"
3. Найдите и установите:
   - Spotify Player
   - Google Translate
   - URL Encoder/Decoder

Или используйте команду:
```
# В Raycast введите: "install extensions"
```

## Важные замечания

### Безопасность и приватность

- Настройки хранятся в зашифрованных SQLite базах (не читаются напрямую)
- Для переноса нужно копировать файлы целиком
- `raycast/backup/` и `raycast/extensions/` в `.gitignore` и никогда не коммитятся.
  Базы зашифрованы, но содержат историю буфера обмена, сниппеты и заметки,
  а кэш расширений хранит данные аккаунтов открытым текстом. Репозиторий публичный -
  переносить эти файлы нужно напрямую между машинами, а не через git
  ```
  ~/Library/Application Support/com.raycast.macos/
  ```

### Хранение данных (без облачной синхронизации)

Все данные хранятся локально:
- Установленные расширения
- Горячие клавиши
- Aliases для команд
- Настройки расширений
- История команд
- Сниппеты и quicklinks

**Для переноса на новую машину:** см. **[BACKUP_INSTRUCTIONS.md](BACKUP_INSTRUCTIONS.md)**

## Резервное копирование

Так как облачная синхронизация НЕ используется, для переноса на новую машину нужно копировать файлы вручную.

**Быстрый способ (рекомендуется):**
```bash
# Автоматический backup
./scripts/raycast_backup.sh
```

Этот скрипт скопирует все необходимые файлы в `raycast/backup/`

**Полная инструкция:** **[BACKUP_INSTRUCTIONS.md](BACKUP_INSTRUCTIONS.md)**

**Что копируется:**
```bash
~/Library/Application Support/com.raycast.macos/
├── raycast-enc.sqlite*          # Все настройки (ОБЯЗАТЕЛЬНО)
├── extensions/                   # Расширения (ОБЯЗАТЕЛЬНО)
├── NodeJS/                       # Runtime (ОБЯЗАТЕЛЬНО)
└── raycast-activities-enc.sqlite* # История (опционально)

~/Library/Preferences/com.raycast.macos.plist  # Системные настройки
```

## Полезные команды Raycast

### Базовые

- `Ctrl + Space` - открыть Raycast
- `Cmd + ,` - настройки
- `Cmd + K` - показать действия (Action Panel)
- `Cmd + Shift + Enter` - выполнить без закрытия окна
- `Option + Enter` - альтернативное действие
- `Esc` - назад/закрыть

### Полезные встроенные команды

- `Window Management` - управление окнами (как Rectangle)
- `Clipboard History` - история буфера обмена
- `Snippets` - текстовые сниппеты
- `Floating Notes` - быстрые заметки
- `System` - системные команды (shutdown, restart, sleep)
- `File Search` - поиск файлов

## Настройка расширений

### Spotify Player

После установки настройте:
1. Авторизуйтесь в Spotify
2. В настройках расширения:
   - Включите Menu Bar Player (показывает текущий трек)
   - Настройте максимальную длину текста в menu bar
   - Выберите иконку (Spotify icon или обложка альбома)

### Google Translate

Настройте языковые пары в preferences расширения:
- Primary Language: Auto-Detect
- Secondary Language: русский

## Структура директорий Raycast

```
~/Library/Application Support/com.raycast.macos/
├── extensions/              # Установленные расширения
├── raycast-enc.sqlite       # Зашифрованная база с настройками
├── raycast-activities-enc.sqlite  # История активности
└── raycast-emoji.sqlite     # Кеш эмодзи

~/Library/Preferences/
└── com.raycast.macos.plist  # Системные preferences (не копируется)
```

## Миграция на новую систему

**Без облачной синхронизации** (используется этот метод):

```bash
# 1. Установить Raycast
./scripts/setup.sh  # или: brew install --cask raycast

# 2. Восстановить конфигурацию автоматически
./scripts/raycast_restore.sh

# 3. Отключить Spotlight в System Settings
```

**Или вручную:** см. **[BACKUP_INSTRUCTIONS.md](BACKUP_INSTRUCTIONS.md)**

**С облачной синхронизацией** (альтернатива):

1. Создать бесплатный аккаунт Raycast
2. Установить через `./scripts/setup.sh`
3. Войти в аккаунт - все синхронизируется автоматически

## Почему Raycast вместо Spotlight

**Преимущества Raycast:**
- Расширяемость через extensions
- Быстрые команды и aliases
- Clipboard History
- Window Management встроенный
- Snippets и Quick Notes
- Интеграция с приложениями (Spotify, etc.)
- Калькулятор с конвертацией валют
- AI интеграция
- Поиск файлов (как Spotlight, но с дополнительными действиями)

В этой конфигурации Spotlight полностью заменен на Raycast с хоткеем `Ctrl+Space`.

## Ссылки

- [Raycast Website](https://www.raycast.com/)
- [Raycast Store](https://www.raycast.com/store)
- [Raycast Documentation](https://developers.raycast.com/)
- [Raycast Slack Community](https://raycast.com/community)
