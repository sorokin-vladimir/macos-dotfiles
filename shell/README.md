# Shell Configuration

Конфигурация оболочки zsh с Oh My Zsh.

## Файлы

### Темы zsh (две версии)

#### **sorokin.zsh-theme** - Nerd Fonts Edition 🎨
Гибридный стиль с иконками Nerd Fonts и универсальными цветами.

**Требует:** Nerd Fonts (иконки ,  и др.)

**Особенности:**
- 🌓 Универсальные цвета работают на светлых и темных темах
- 🎯 Компактный и детальный git статус
- 📁 Иконки для файлов, git, времени
- ⚡ Яркие индикаторы состояния
- 🔄 Не требует перезапуска при смене темы терминала

**Пример:**
```
 ✓  ~/macos-dotfiles  main  · 🕐 14:32:45 · 📅 27/10
```

**Цветовая палитра:**
- Средне-зеленый, средне-синий, средне-пурпурный
- Оптимизировано для TokyoNight Moon (темная) и TokyoNight Day (светлая)
- Одинаково хорошая читаемость на обоих фонах

#### **sorokin-unicode.zsh-theme** - Unicode Edition
Та же тема, но с Unicode символами вместо Nerd Fonts.

**Требует:** Только стандартные Unicode символы

**Особенности:**
- 📁 Стандартные эмодзи и символы
- ⎇ Git branch с Unicode иконкой
- 🌓 Универсальные цвета работают на светлых и темных темах
- ✓ Работает с любым шрифтом
- 🔄 Не требует перезапуска при смене темы терминала

**Пример:**
```
✓ 📁 ~/macos-dotfiles ⎇ main ✓ · ⏰ 14:32:45 · 📅 27/10
```

**Цветовая палитра:** Та же универсальная палитра, что и в Nerd Fonts версии

## Основной конфиг

Главный файл конфигурации **[.zshrc](../.zshrc)** находится в корне репозитория.

### Что там внутри:

**Инструменты:**
- mise (mise-en-place) - менеджер версий
- thefuck - исправление ошибок команд
- zsh-autosuggestions и zsh-syntax-highlighting
- Git completion

**Кастомные алиасы:**
- `glg` - git log с графом
- `gl` - git log без графа
- `submodule` - обновить git submodules
- `cic` - перейти в iCloud Drive
- `cl` - перейти в Logseq docs
- `ter/tre` - перевод с английского/русского
- `n` - открыть neovim
- `y` - файловый менеджер yazi

**Переменные окружения:**
- GPG_TTY для подписи коммитов
- PNPM_HOME и PATH для pnpm
- Homebrew binaries в PATH

## Установка

### Шаг 1: Проверь поддержку Nerd Fonts

Запусти в терминале:
```bash
echo -e "\ue0a0 \uf09b \uf07c \uf017"
```

- **Видишь иконки** ( и др.) → используй `sorokin.zsh-theme` (Nerd Fonts)
- **Видишь квадратики** (□) → используй `sorokin-unicode.zsh-theme` (Unicode)

### Шаг 2: Установи Nerd Fonts (опционально)

Если хочешь использовать Nerd Fonts версию:

```bash
# Через Homebrew (рекомендуется)
brew install --cask font-monaspice-nerd-font

# Или поиск других Nerd Fonts
brew search nerd-font

# Или скачай вручную
# https://www.nerdfonts.com/font-downloads
```

**Популярные Nerd Fonts:**
- Monaspace Nerd Font (рекомендуется для этой темы)
- FiraCode Nerd Font
- JetBrainsMono Nerd Font
- Hack Nerd Font

**Примечание:** С мая 2024 команда `brew tap homebrew/cask-fonts` больше не нужна - все шрифты в основном репозитории.

После установки:
1. Перезапусти терминал
2. Установи Nerd Font в настройках терминала:
   - Для **Ghostty**: отредактируй `~/Library/Application Support/com.mitchellh.ghostty/config`
   - Установи: `font-family = "MonaspiceNe Nerd Font Mono"` и `font-style = Light` (или другой Nerd Font)
   - Перезагрузи Ghostty: `cmd+r` или перезапусти приложение

### Шаг 3: Установи тему

**Автоматически (через setup.sh):**
```bash
cd ~/Documents/macos-dotfiles
./scripts/setup.sh
```

Скрипт автоматически:
1. Копирует `.zshrc` в `~/.zshrc` (там уже прописано `ZSH_THEME="sorokin"`)
2. Копирует `sorokin.zsh-theme` в `~/.oh-my-zsh/custom/themes/`
3. Применяет изменения

**Вручную:**

Для Nerd Fonts версии:
```bash
cp .zshrc ~/.zshrc
cp shell/sorokin.zsh-theme ~/.oh-my-zsh/custom/themes/
source ~/.zshrc
```

Для Unicode версии:
```bash
cp .zshrc ~/.zshrc
cp shell/sorokin-unicode.zsh-theme ~/.oh-my-zsh/custom/themes/sorokin.zsh-theme
source ~/.zshrc
```

**Проверка:** После установки убедись, что тема активирована:
```bash
grep "ZSH_THEME" ~/.zshrc
# Должно быть: ZSH_THEME="sorokin"
```

### Шаг 4: Переключение между темами

В любой момент можешь переключиться:

```bash
# На Nerd Fonts версию
cp shell/sorokin.zsh-theme ~/.oh-my-zsh/custom/themes/
source ~/.zshrc

# На Unicode версию
cp shell/sorokin-unicode.zsh-theme ~/.oh-my-zsh/custom/themes/sorokin.zsh-theme
source ~/.zshrc
```

## Кастомизация

### Изменить цвета

Открой тему и измени цветовую палитру в начале файла:

```bash
nvim ~/.oh-my-zsh/custom/themes/sorokin.zsh-theme
```

**Текущие универсальные цвета** (256-color, работают на обоих фонах):
- `%F{35}` - universal_green (средне-зеленый)
- `%F{37}` - universal_cyan (средне-циан)
- `%F{133}` - universal_magenta (средне-пурпурный)
- `%F{33}` - universal_blue (средне-синий)
- `%F{172}` - universal_orange (средне-оранжевый)
- `%F{160}` - universal_red (средне-красный)
- `%F{178}` - universal_yellow (средне-желтый)
- `%F{243}` - dim_gray (серый для вторичной информации)

**Для темных тем:** Можешь использовать более яркие цвета (46, 51, 201, 39)
**Для светлых тем:** Можешь использовать более темные цвета (28, 24, 89, 22)

### Изменить иконки

Найди Nerd Fonts иконки: https://www.nerdfonts.com/cheat-sheet

**ВАЖНО:** В zsh темах используется специальный синтаксис для Unicode символов:
```bash
# ✅ ПРАВИЛЬНО - используй $'\uXXXX' для Nerd Fonts иконок
PROMPT="${electric_cyan}"$'\uf07c'" %2~${reset}"

# ❌ НЕПРАВИЛЬНО - обычные escape-последовательности не работают
PROMPT="${electric_cyan}\uf07c %2~${reset}"
```

Примеры замены иконок в теме:
```bash
# Папка: $'\uf07c' →  другая иконка папки $'\uf115'
# Git:   $'\ue0a0' →  другая иконка git $'\uf418' (или  $'\uf09b')
```

## Примеры всех состояний

### Nerd Fonts версия:

```bash
# Чистый репозиторий
 ✓  ~/macos-dotfiles  main  · 🕐 14:32:45 · 📅 27/10

# Есть изменения (dirty)
 ✓  ~/macos-dotfiles  main ⚡ · 🕐 14:32:45 · 📅 27/10

# Staged файлы
 ✓  ~/macos-dotfiles  main   · 🕐 14:32:45 · 📅 27/10

# Untracked файлы
 ✓  ~/macos-dotfiles  main   · 🕐 14:32:45 · 📅 27/10

# Ahead of remote
 ✓  ~/macos-dotfiles  main ⇡3 · 🕐 14:32:45 · 📅 27/10

# Behind remote
 ✓  ~/macos-dotfiles  main ⇣2 · 🕐 14:32:45 · 📅 27/10

# Комбо: modified + staged + ahead
 ✓  ~/macos-dotfiles  main ⚡ ⇡2 · 🕐 14:32:45 · 📅 27/10

# Ошибка в последней команде
 ✗  ~/macos-dotfiles  main ⚡  ⇡1 · 🕐 14:32:45 · 📅 27/10

# Merge конфликты
 ✗  ~/macos-dotfiles  main ⚠  · 🕐 14:32:45 · 📅 27/10
```

### Unicode версия:

```bash
# Чистый репозиторий
✓ 📁 ~/macos-dotfiles ⎇ main ✓ · ⏰ 14:32:45 · 📅 27/10

# Есть изменения (dirty)
✓ 📁 ~/macos-dotfiles ⎇ main ⚡ · ⏰ 14:32:45 · 📅 27/10

# Комбо: modified + staged + ahead
✓ 📁 ~/macos-dotfiles ⎇ main ⚡✚◯↑2 · ⏰ 14:32:45 · 📅 27/10
```

## Символы и их значение

| Символ | Значение | Nerd | Unicode |
|--------|----------|------|---------|
| Успех команды | Команда выполнена успешно | ✓ | ✓ |
| Ошибка | Команда завершилась с ошибкой | ✗ | ✗ |
| Папка | Текущая директория |  | 📁 |
| Git branch | Git ветка |  | ⎇ |
| Clean repo | Нет изменений |  | ✓ |
| Dirty repo | Есть изменения | ⚡ | ⚡ |
| Staged | Файлы в staging |  | ✚ |
| Modified | Изменённые файлы | ⚡ | ● |
| Untracked | Неотслеживаемые файлы |  | ◯ |
| Deleted | Удалённые файлы |  | ✖ |
| Ahead | Коммитов впереди remote | ⇡ | ↑ |
| Behind | Коммитов позади remote | ⇣ | ↓ |
| Conflicts | Merge конфликты | ⚠ | ⚠ |
| Stashed | Есть stash |  | ◈ |

## Troubleshooting

### Иконки отображаются как квадратики

**Причина:** Шрифт не поддерживает Nerd Fonts или иконки записаны неправильно.

**Решение:**
1. Проверь, что установлен Nerd Font:
   ```bash
   echo -e "\ue0a0 \uf09b \uf07c \uf017"
   ```
   Должны отображаться иконки, не квадратики.

2. Проверь конфиг Ghostty:
   ```bash
   grep "font-family" ~/Library/Application\ Support/com.mitchellh.ghostty/config
   ```
   Должно быть что-то вроде: `font-family = "MonaspiceNe Nerd Font Mono"` (толщина - отдельной строкой `font-style = Light`)

3. Проверь, что иконки в теме записаны правильно (через `$'\uXXXX'`, а не `\uXXXX`)

4. Если ничего не помогло - используй Unicode версию темы

### Цвета блёклые/неправильные

Убедись что терминал поддерживает 256 цветов:
```bash
echo $TERM
# Должно быть xterm-256color или screen-256color
```

Если нет, добавь в `.zshrc`:
```bash
export TERM=xterm-256color
```

### Тема не применяется

Проверь что в `.zshrc` установлена тема:
```bash
grep "ZSH_THEME" ~/.zshrc
# Должно быть: ZSH_THEME="sorokin"
```

Перезагрузи shell:
```bash
source ~/.zshrc
```
