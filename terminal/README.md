# Terminal Configuration

Конфигурация терминальных эмуляторов.

## Файлы

### Ghostty (основной терминал)

- **config** - Конфигурация Ghostty terminal emulator
  - **Тема:** TokyoNight Moon (dark) / TokyoNight Day (light)
  - **Шрифт:** Monaspace Neon Var Regular Light
  - **Vim-style навигация:** `cmd+shift+h/j/k/l` для переключения между сплитами
  - **Quick terminal:** `cmd+g` (глобальный hotkey)
  - **Другие hotkeys:**
    - `cmd+s` - новый split вниз
    - `cmd+i` - inspector
    - `cmd+r` - перезагрузка конфига
  - Window padding: 10px
  - Анимации включены

### Legacy (устаревшее)

- **sorokin.terminal-theme.terminal** - Тема для стандартного Terminal.app
  - Сейчас не используется (заменён на Ghostty)
  - Сохранён для совместимости

## Установка

### Ghostty

```bash
# Автоматическая установка через setup.sh
./scripts/setup.sh

# Или вручную
cp terminal/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
```

После копирования:
- Перезапусти Ghostty
- Или нажми `cmd+r` для перезагрузки конфига

### Terminal.app (legacy)

1. Открой Terminal → Preferences → Profiles
2. Нажми кнопку с шестерёнкой → Import...
3. Выбери `terminal/sorokin.terminal-theme.terminal`
4. Установи как Default

## Шрифты

⚠️ Требуется установка **Monaspace Neon Var**:

```bash
# Через Homebrew
brew install --cask font-monaspace

# Или скачай с GitHub
# https://github.com/githubnext/monaspace
```
