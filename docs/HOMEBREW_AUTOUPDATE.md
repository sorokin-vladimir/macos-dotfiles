# Автоматическое обновление Homebrew

Автоматизация обновления Homebrew через launchd с логированием и уведомлениями.

## Что делает скрипт

Скрипт `brew_upgrade_cron.sh` автоматически:

1. Обновляет Homebrew (`brew update`)
2. Проверяет устаревшие пакеты (`brew outdated`)
3. Обновляет все пакеты (`brew upgrade`)
4. Очищает кэш (`brew cleanup`)
5. Удаляет неиспользуемые зависимости (`brew autoremove`)
6. Проверяет здоровье системы (`brew doctor`)

### Логирование

Все логи сохраняются с ротацией по дате:
- Основные логи: `~/Library/Logs/homebrew-cron/brew-update-YYYY-MM-DD.log`
- Логи launchd: `~/Library/Logs/homebrew-cron/launchd-stdout.log` и `launchd-stderr.log`

### Уведомления

Скрипт отправляет три типа уведомлений через macOS Notification Center:

1. **Outdated пакеты**: если есть пакеты для обновления - показывает их количество и список (до 5 пакетов)
2. **Doctor предупреждения**: если `brew doctor` нашел проблемы (не "Your system is ready to brew")
3. **Финальный статус**: успех или ошибка выполнения всего скрипта

## Установка

### Способ 1: Автоматическая установка (рекомендуется)

Запусти скрипт установки, который автоматически настроит все пути:

```bash
cd ~/Documents/macos-dotfiles
./scripts/install_homebrew_autoupdate.sh
```

Скрипт автоматически:
- Создаст директорию для логов
- Заменит `$HOME` на твой реальный путь
- Установит и загрузит launchd задачу
- Покажет команды для управления

Готово! После этого обновления будут происходить автоматически каждый день в 10:00.

### Способ 2: Ручная установка

Если предпочитаешь все делать вручную:

#### Шаг 1: Проверь пути в plist файле

Открой `com.user.homebrew-autoupdate.plist` и убедись, что пути указаны правильно:

Файл содержит переменные `$HOME` которые нужно заменить:

```bash
# Скопируй и замени $HOME на реальный путь
cd ~/Documents/macos-dotfiles
sed "s|\$HOME|$HOME|g" scripts/com.user.homebrew-autoupdate.plist > ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist
```

#### Шаг 2: Загрузи и активируй задачу

```bash
launchctl load ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist
```

#### Шаг 3: Проверь что задача загружена

```bash
launchctl list | grep homebrew
```

Должна появиться строка с `com.user.homebrew-autoupdate`.

## Изменение расписания

По умолчанию скрипт запускается **каждый день в 10:00 утра**.

Чтобы изменить расписание:

1. Выгрузи задачу:
   ```bash
   launchctl unload ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist
   ```

2. Отредактируй `~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist`:

   ```xml
   <!-- Запуск каждый день в 14:30 -->
   <key>StartCalendarInterval</key>
   <dict>
       <key>Hour</key>
       <integer>14</integer>
       <key>Minute</key>
       <integer>30</integer>
   </dict>
   ```

   Или несколько раз в день:

   ```xml
   <!-- Запуск в 10:00 и 18:00 -->
   <key>StartCalendarInterval</key>
   <array>
       <dict>
           <key>Hour</key>
           <integer>10</integer>
           <key>Minute</key>
           <integer>0</integer>
       </dict>
       <dict>
           <key>Hour</key>
           <integer>18</integer>
           <key>Minute</key>
           <integer>0</integer>
       </dict>
   </array>
   ```

   Или по определенным дням недели (0 = Воскресенье, 1 = Понедельник, и т.д.):

   ```xml
   <!-- Запуск только по понедельникам в 10:00 -->
   <key>StartCalendarInterval</key>
   <dict>
       <key>Weekday</key>
       <integer>1</integer>
       <key>Hour</key>
       <integer>10</integer>
       <key>Minute</key>
       <integer>0</integer>
   </dict>
   ```

3. Загрузи задачу заново:
   ```bash
   launchctl load ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist
   ```

## Управление задачей

### Запустить сейчас (не дожидаясь расписания)

```bash
launchctl start com.user.homebrew-autoupdate
```

### Остановить задачу (временно)

```bash
launchctl stop com.user.homebrew-autoupdate
```

### Выгрузить задачу (отключить автозапуск)

```bash
launchctl unload ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist
```

### Загрузить задачу обратно (включить автозапуск)

```bash
launchctl load ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist
```

### Полностью удалить задачу

```bash
# Выгрузи задачу
launchctl unload ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist

# Удали plist файл
rm ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist
```

### Проверить статус задачи

```bash
# Посмотреть все задачи с homebrew в названии
launchctl list | grep homebrew

# Детальная информация о задаче
launchctl print gui/$(id -u)/com.user.homebrew-autoupdate
```

## Проверка логов

### Посмотреть сегодняшний лог

```bash
tail -f ~/Library/Logs/homebrew-cron/brew-update-$(date +%Y-%m-%d).log
```

### Посмотреть все логи

```bash
ls -lh ~/Library/Logs/homebrew-cron/
```

### Посмотреть последние 50 строк

```bash
tail -n 50 ~/Library/Logs/homebrew-cron/brew-update-$(date +%Y-%m-%d).log
```

### Посмотреть логи launchd (если что-то не работает)

```bash
# Stdout
cat ~/Library/Logs/homebrew-cron/launchd-stdout.log

# Stderr
cat ~/Library/Logs/homebrew-cron/launchd-stderr.log
```

### Найти логи с ошибками

```bash
grep -r "❌" ~/Library/Logs/homebrew-cron/
grep -r "failed" ~/Library/Logs/homebrew-cron/
```

## Ручной запуск для тестирования

Перед настройкой launchd можешь протестировать скрипт вручную:

```bash
cd ~/Documents/macos-dotfiles
./brew_upgrade_cron.sh
```

Должны прийти уведомления, а логи появятся в `~/Library/Logs/homebrew-cron/`.

## Проблемы и решения

### Задача не запускается

Проверь:

1. Правильность путей в plist файле:
   ```bash
   cat ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist
   ```

2. Права на выполнение скрипта:
   ```bash
   ls -l ~/Documents/macos-dotfiles/brew_upgrade_cron.sh
   # Должно быть: -rwxr-xr-x
   ```

3. Логи launchd на предмет ошибок:
   ```bash
   cat ~/Library/Logs/homebrew-cron/launchd-stderr.log
   ```

### Уведомления не приходят

1. Проверь разрешения для Terminal.app или Ghostty в:
   **System Settings → Notifications**

2. Запусти скрипт вручную и проверь, приходят ли уведомления:
   ```bash
   ./brew_upgrade_cron.sh
   ```

### Скрипт не может найти brew

Проверь PATH в plist файле. Для Apple Silicon должно быть `/opt/homebrew/bin`, для Intel - `/usr/local/bin`.

### Очистка старых логов

Логи накапливаются ежедневно. Чтобы удалить старые:

```bash
# Удалить логи старше 30 дней
find ~/Library/Logs/homebrew-cron/ -name "brew-update-*.log" -mtime +30 -delete
```

Или добавь это в конец скрипта для автоматической очистки.

## Полезные команды

```bash
# Посмотреть когда задача запускалась в последний раз
launchctl print gui/$(id -u)/com.user.homebrew-autoupdate | grep LastExitTime

# Перезагрузить задачу (применить изменения в plist)
launchctl unload ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist
launchctl load ~/Library/LaunchAgents/com.user.homebrew-autoupdate.plist

# Посмотреть все задачи launchd
launchctl list

# Открыть логи в Console.app
open ~/Library/Logs/homebrew-cron/
```

## Дополнительно

Если хочешь чтобы скрипт запускался при входе в систему (в дополнение к расписанию), измени в plist:

```xml
<key>RunAtLoad</key>
<true/>
```

Но обычно это не нужно - достаточно запуска по расписанию.
