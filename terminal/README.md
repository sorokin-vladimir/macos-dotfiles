# Terminal Configuration

Конфигурация терминальных эмуляторов.

## Файлы

### Ghostty (основной терминал)

- **config** - Конфигурация Ghostty terminal emulator
  - **Тема:** TokyoNight Moon (dark) / TokyoNight Day (light)
  - **Шрифт:** MonaspiceNe Nerd Font Mono, начертание Light
  - **Vim-style навигация:** `cmd+shift+h/j/k/l` для переключения между сплитами
  - **Quick terminal:** `cmd+g` (глобальный hotkey)
  - **Другие hotkeys:**
    - `cmd+s` - новый split вниз
    - `cmd+i` - inspector
    - `cmd+r` - перезагрузка конфига
    - `shift+enter` - шлёт ESC+Enter (перенос строки без отправки, например в Claude Code)
  - Window padding: 4px
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

⚠️ Требуется **MonaspiceNe Nerd Font Mono** (`setup.sh` ставит его сам):

```bash
brew install --cask font-monaspice-nerd-font
```

Толщина задаётся отдельной строкой `font-style = Light`. Если написать её в
`font-family` (`"MonaspiceNe Nerd Font Mono Light"`), такого семейства нет, и
Ghostty молча откатится на встроенный JetBrains Mono. Проверить, какой шрифт
реально используется:

```bash
ghostty +show-face --cp=0x61 --font-family="MonaspiceNe Nerd Font Mono" --font-style=Light
```
