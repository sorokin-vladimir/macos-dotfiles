# Scripts

Автоматизированные скрипты для установки и обслуживания системы.

## Файлы

### setup.sh
**Главный скрипт установки окружения**

Автоматически устанавливает и настраивает:
- Xcode Command Line Tools (если их нет)
- Homebrew и все пакеты
- Oh My Zsh с кастомной темой
- Git конфигурацию
- Git completion
- SSH ключи
- mise runtime manager
- Копирует все конфигурационные файлы
- Раскладки ABC + Russian - PC, Cmd+Space для переключения языка, Spotlight выключен

**Использование:**
```bash
# Полная интерактивная установка
./scripts/setup.sh

# Неинтерактивный режим (все yes по умолчанию)
./scripts/setup.sh --non-interactive

# Пропустить определённые шаги
./scripts/setup.sh --skip-homebrew
./scripts/setup.sh --skip-apps
./scripts/setup.sh --skip-shell
./scripts/setup.sh --skip-git-completion
./scripts/setup.sh --skip-macos

# Только обновить конфиги (без установки пакетов)
./scripts/setup.sh --skip-homebrew --skip-apps --skip-shell --non-interactive
```

**Особенности:**
- Идемпотентный (можно запускать несколько раз)
- Создаёт бэкапы перед заменой файлов
- Поддержка Apple Silicon и Intel Mac
- Цветной вывод и понятные сообщения

### raycast_backup.sh
**Backup конфигурации Raycast**

Создаёт резервную копию всех настроек Raycast для ручного переноса на новую машину (без облачной синхронизации).

Копирует:
- `raycast-enc.sqlite*` - все настройки, хоткеи, aliases
- `extensions/` - установленные расширения
- `NodeJS/` - runtime для расширений
- `raycast-activities-enc.sqlite*` - история (опционально)
- `com.raycast.macos.plist` - системные preferences

**Использование:**
```bash
./scripts/raycast_backup.sh
```

Файлы сохраняются в `raycast/backup/` (не коммитится в git)

Подробнее см. **[../raycast/BACKUP_INSTRUCTIONS.md](../raycast/BACKUP_INSTRUCTIONS.md)**

### raycast_restore.sh
**Восстановление конфигурации Raycast из backup**

Восстанавливает все настройки Raycast из backup на новой машине.

Выполняет:
- Проверку наличия backup файлов
- Проверку установки Raycast
- Автоматическое закрытие Raycast если запущен
- Восстановление всех баз данных и расширений
- Установку правильных прав доступа
- Опциональный запуск Raycast после восстановления

**Использование:**
```bash
# На новой машине после установки Raycast
./scripts/raycast_restore.sh
```

**Требования:**
- Raycast должен быть установлен: `brew install --cask raycast`
- Должен существовать backup в `raycast/backup/`

Подробнее см. **[../raycast/BACKUP_INSTRUCTIONS.md](../raycast/BACKUP_INSTRUCTIONS.md)**

### brew_upgrade_logged.sh
**Ручное обновление Homebrew с красивым выводом**

Выполняет:
- `brew update` - обновить сам Homebrew
- `brew outdated` - показать устаревшие пакеты
- `brew upgrade` - обновить все пакеты
- `brew cleanup` - очистка
- `brew autoremove` - удаление неиспользуемых зависимостей
- `brew doctor` - проверка здоровья

**Использование:**
```bash
./scripts/brew_upgrade_logged.sh
```

### brew_upgrade_cron.sh
**Автоматическое обновление Homebrew для launchd/cron**

Отличия от ручной версии:
- Логирование с ротацией по дате: `~/Library/Logs/homebrew-cron/`
- Три типа уведомлений через macOS Notification Center:
  - **Outdated:** если есть пакеты для обновления
  - **Doctor:** если обнаружены проблемы
  - **Финальное:** успех или ошибка всего процесса
- Автоматическое определение архитектуры (Apple Silicon/Intel)
- Обработка ошибок на каждом этапе

**Использование:**
```bash
# Ручной запуск для тестирования
./scripts/brew_upgrade_cron.sh

# Или запускается автоматически через launchd
```

### install_homebrew_autoupdate.sh
**Автоматическая установка launchd задачи для Homebrew**

Настраивает и устанавливает автоматические обновления Homebrew:
- Заменяет `$HOME` на реальный путь пользователя
- Создаёт директорию для логов
- Загружает launchd задачу
- Показывает команды управления

**Использование:**
```bash
./scripts/install_homebrew_autoupdate.sh
```

### com.user.homebrew-autoupdate.plist
**Конфигурация launchd для автоматических обновлений**

- Запускает `brew_upgrade_cron.sh` каждый день в 10:00
- Логирует в `~/Library/Logs/homebrew-cron/`
- Правильная настройка PATH для Homebrew
- Nice level 1 (низкий приоритет)
- Использует переменные `$HOME` (заменяются скриптом установки)

**Рекомендуемая установка:**
```bash
./scripts/install_homebrew_autoupdate.sh
```

**Ручная установка:**
```bash
sed "s|\$HOME|$HOME|g" scripts/com.user.homebrew-autoupdate.plist > ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist
launchctl load ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist
```

**Управление:**
```bash
# Запустить сейчас
launchctl start com.user.homebrew-autoupdate

# Остановить
launchctl stop com.user.homebrew-autoupdate

# Выгрузить (отключить)
launchctl unload ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist

# Загрузить (включить)
launchctl load ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist

# Проверить статус
launchctl list | grep homebrew
```

Подробнее см. **[../docs/HOMEBREW_AUTOUPDATE.md](../docs/HOMEBREW_AUTOUPDATE.md)**

## Требования

- macOS (Darwin)
- Bash
- Для автоматических обновлений: настроить launchd
- Для уведомлений: разрешить Terminal.app/Ghostty отправлять уведомления в System Settings
