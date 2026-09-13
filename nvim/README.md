# Neovim Configuration

Конфигурация для Neovim с LazyVim.

## Структура

```
nvim/
├── lazyvim.json       # LazyVim extras (включённые пакеты экстр)
├── config/
│   ├── keymaps.lua    # Кастомные кейбинды
│   └── options.lua    # Опции редактора
└── plugins/
    ├── cmp.lua        # Автодополнение (nvim-cmp)
    ├── codeium.lua    # AI assistant Codeium
    ├── colorscheme.lua # Цветовая схема
    ├── lint.lua        # Линтер (nvim-lint), настройка по типу файла
    ├── surround.lua    # Плагин surround для работы со скобками/кавычками
    └── which-key.lua   # Настройка which-key (отключение presets для операторов)
```

## Основные кейбинды

### Mode switching
- `jj` или `kk` в insert mode → escape в normal mode

### Навигация
- `Shift+H` / `Shift+L` - переключение между буферами

### Visual mode операции
- `J` / `K` - двигать строки вверх/вниз (остаёмся в visual mode)
- `<` / `>` - отступы влево/вправо (остаёмся в visual mode)

### Leader key команды (Space)
- `<leader>v` - заменить текущее слово из clipboard
- `<leader>i` - разделить строку на месте курсора

### Console.log команды
- `<leader>dl` - вставить console.log
- `<leader>dcl` - залогировать содержимое буфера
- `<leader>dwl` - залогировать текущее слово
- `<leader>dwcl` - залогировать текущее слово с deep clone

### Путь к файлу
- `<leader>cP` - показать полный путь к файлу
- `<leader>cp` - показать относительный путь от cwd

## Плагины

### Codeium AI
- Автодополнение с AI
- Показывает подсказки как virtual text
- Работает для всех языков

### nvim-cmp
- Система автодополнения
- Интеграция с LSP, snippets, buffer

### nvim-lint
- Линтер на основе `mfussenegger/nvim-lint`
- Конфигурация по типу файла через `linters_by_ft`
- Текущая настройка: Go — без дополнительных линтеров (используется встроенный LSP)

### Surround
- Быстрая работа со скобками, кавычками, тегами
- `ys`, `ds`, `cs` операции

### which-key
- Подсказки для клавиш в командном режиме
- Отключены presets для операторов (`g`, `d`, `c`, `y` и т.п.) — убирает задержку и лишние подсказки
- `delay = 0` — мгновенный показ

## Установка

### 1. Установи LazyVim

`setup.sh` делает это сам, если в `~/.config/nvim` ещё нет `init.lua`. Вручную:

```bash
# Клонировать LazyVim starter
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

### 2. Скопируй конфиги

```bash
# Автоматически через setup.sh
cd ~/Documents/macos-dotfiles
./scripts/setup.sh

# Или вручную
mkdir -p ~/.config/nvim/lua/config ~/.config/nvim/lua/plugins
cp nvim/lazyvim.json ~/.config/nvim/lazyvim.json
cp nvim/config/*.lua ~/.config/nvim/lua/config/
cp nvim/plugins/*.lua ~/.config/nvim/lua/plugins/
```

### 3. Добавь в init.vim

```vim
set relativenumber
```

### 4. Проверь здоровье

```bash
nvim
# В Neovim:
:LazyHealth
```

## Требования

- Neovim >= 0.9.0
- Установлен через Homebrew: `brew install neovim`
- Шрифт MonaspiceNe Nerd Font Mono (для корректного отображения иконок)
