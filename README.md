# macos-dotfiles

Персональная конфигурация macOS окружения для разработки.

## Быстрый старт

### Шаг 0: SSH-ключ

Делается **до** всего остального: репозиторий клонируется по SSH, поэтому
рабочий ключ нужен раньше, чем появится сам скрипт. Скрипт ключ не создаёт -
только проверяет, что он есть.

```bash
# Создать ключ
ssh-keygen -t ed25519 -C "your@email"

# Положить в agent, пароль подхватится из Keychain
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Скопировать публичный ключ - и добавить на github.com/settings/keys
pbcopy < ~/.ssh/id_ed25519.pub
```

Отдельный `ssh-agent` поднимать не надо: в macOS он уже запущен через launchd.

Проверить, что GitHub принял ключ:

```bash
ssh -T git@github.com
```

### Шаг 1: Клонировать и запустить

```bash
git clone git@github.com:sorokin-vladimir/macos-dotfiles.git ~/Documents/macos-dotfiles
cd ~/Documents/macos-dotfiles

./scripts/setup.sh
```

Скрипт установит Homebrew, все необходимые инструменты, настроит shell и git,
проверит SSH и скопирует конфигурационные файлы.

📖 Подробная инструкция: **[docs/SETUP.md](docs/SETUP.md)**

## Содержание

- [🐚 Shell Configuration](#-shell-configuration) - zsh с oh-my-zsh
- [🖥️ Terminal](#%EF%B8%8F-terminal) - Ghostty и Terminal.app
- [🚀 Productivity](#-productivity) - Raycast launcher
- [📝 Editors](#-editors) - Neovim
- [🔧 Scripts](#-scripts) - Автоматизация и обслуживание
- [📚 Documentation](#-documentation) - Детальные инструкции
- [🎹 Miscellaneous](#-miscellaneous) - Дополнительные конфиги

---

## 🐚 Shell Configuration

**Папка:** [`shell/`](shell/)

- **[.zshrc](.zshrc)** (в корне) - основной конфиг zsh
- **[sorokin.zsh-theme](shell/sorokin.zsh-theme)** - кастомная тема с git индикаторами

**Основные возможности:**
- mise, thefuck, zsh-autosuggestions, zsh-syntax-highlighting
- Git алиасы: `glg`, `gl`, `submodule`
- Навигация: `cic` (iCloud), `cl` (Logseq)
- Утилиты: `ter`/`tre` (перевод), `n` (neovim), `y` (yazi)

📖 Подробнее: **[shell/README.md](shell/README.md)**

---

## 🖥️ Terminal

**Папка:** [`terminal/`](terminal/)

### Ghostty (основной)
- TokyoNight тема (Moon/Day)
- Шрифт: Monaspace Neon Var
- Vim-style навигация: `cmd+shift+hjkl`
- Quick terminal: `cmd+g`

### Terminal.app (legacy)
- Старая тема для совместимости

📖 Подробнее: **[terminal/README.md](terminal/README.md)**

---

## 🚀 Productivity

**Папка:** [`raycast/`](raycast/)

### Raycast - Productivity Launcher

Замена Spotlight с расширенными возможностями:
- Управление окнами (window management)
- История буфера обмена
- Интеграция с приложениями (Spotify)
- Калькулятор и конвертер валют
- Сниппеты и быстрые заметки

**Установленные расширения:**
- **Spotify Player** - управление Spotify с menu bar
- **Google Translate** - быстрый перевод
- **URL Encoder/Decoder**

**Настройка на новой машине:**
```bash
./scripts/raycast_restore.sh  # Восстановить из backup
```

Затем:
1. Отключить Spotlight в System Settings
2. Проверить хоткей `Ctrl+Space` в Raycast (должен восстановиться автоматически)

📖 Подробнее: **[raycast/README.md](raycast/README.md)**

---

## 📝 Editors

### Neovim + LazyVim

**Папка:** [`nvim/`](nvim/)

```
nvim/
├── config/           # Кейбинды и опции
│   ├── keymaps.lua
│   └── options.lua
└── plugins/          # Настройки плагинов
    ├── cmp.lua
    ├── codeium.lua
    ├── colorscheme.lua
    └── surround.lua
```

**Основные кейбинды:**
- `jj`/`kk` - выход из insert mode
- `<leader>dl` - console.log
- `<leader>cP` - показать путь к файлу
- `Shift+H`/`Shift+L` - навигация между буферами

📖 Подробнее: **[nvim/README.md](nvim/README.md)**

---

## 🔧 Scripts

**Папка:** [`scripts/`](scripts/)

### setup.sh
Главный скрипт автоматической установки окружения.

```bash
./scripts/setup.sh                    # Полная установка
./scripts/setup.sh --non-interactive  # Без вопросов
./scripts/setup.sh --skip-apps        # Пропустить приложения
```

### Homebrew Maintenance

**Ручное обновление:**
```bash
./scripts/brew_upgrade_logged.sh
```

**Автоматическое обновление (launchd):**
```bash
./scripts/brew_upgrade_cron.sh                    # Тест
./scripts/install_homebrew_autoupdate.sh          # Установка (рекомендуется)
```

Скрипт будет запускаться ежедневно в 10:00 с уведомлениями о:
- Количестве доступных обновлений
- Проблемах из `brew doctor`
- Успехе/ошибке операции

📖 Подробнее: **[scripts/README.md](scripts/README.md)** | **[docs/HOMEBREW_AUTOUPDATE.md](docs/HOMEBREW_AUTOUPDATE.md)**

---

## 📚 Documentation

**Папка:** [`docs/`](docs/)

- **[SETUP.md](docs/SETUP.md)** - полная инструкция по установке (на русском)
- **[HOMEBREW_AUTOUPDATE.md](docs/HOMEBREW_AUTOUPDATE.md)** - настройка автообновлений

---

## 🎹 Miscellaneous

**Папка:** [`misc/`](misc/)

- Конфигурация клавиатуры KBD67 MKII RGB V3 (VIA)

📖 Подробнее: **[misc/README.md](misc/README.md)**

---

## Установка компонентов

### Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Пакеты

**CLI tools:**
```bash
brew install mise thefuck gnupg git tlrc translate-shell neovim \
  zsh-autosuggestions zsh-syntax-highlighting fd fzf ripgrep \
  lazygit lazysql curl yazi ast-grep bat btop ncdu gh glow \
  golangci-lint goreleaser unar pnpm

# Custom tap
brew tap sorokin-vladimir/tap
brew trust --tap sorokin-vladimir/tap
brew install tele tele-beta
```

**GUI apps:**
```bash
brew install --cask claude-code

# Tap for Claude Usage Tracker
brew tap hamed-elfayome/claude-usage
brew trust --tap hamed-elfayome/claude-usage
brew install --cask anki claude firefox \
  zen hey-desktop keepassxc logseq simplenote spotify \
  telegram vlc ghostty raycast \
  bruno dbeaver-community neohtop \
  orbstack ungoogled-chromium zed claude-usage-tracker
```

**Редко используемые:**
```bash
brew install --cask discord transmission tunnelblick zoom
```

**GUI-альтернатива для анализа диска** (не ставится скриптом, в наборе есть CLI - `ncdu`):
```bash
brew install --cask grandperspective
```

### Claude Code CLI

```bash
# Native install
curl -fsSL https://claude.ai/install.sh | bash
claude auth login
```

### Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Шрифты ⚠️ ОБЯЗАТЕЛЬНО

```bash
# Nerd-патченый Monaspace. Ghostty настроен именно на него:
# font-family = "MonaspiceNe Nerd Font Mono Light"
brew install --cask font-monaspice-nerd-font
```

Обрати внимание на написание: каск называется `font-monasp**i**ce-nerd-font`
(Nerd Fonts переименовывает Monaspace в Monaspice). Обычный `font-monaspace`
не подойдёт - в нём нет иконок, которые использует zsh-тема.

Исходники шрифта: [github.com/githubnext/monaspace](https://github.com/githubnext/monaspace)

### Git

```bash
# Алиас для force push
git config --global alias.please 'push --force-with-lease'

# Git completion
mkdir -p ~/.zsh && cd ~/.zsh
curl -o git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o _git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
rm ~/.zcompdump  # После первого запуска
```

### Mise

```bash
mise use -g node@24
mise use -g go@latest

# Go tools (aqua backend)
mise use -g aqua:sqlc-dev/sqlc
mise use -g aqua:golang-migrate/migrate
```

### npm Global Packages

```bash
npm install -g @rivolink/leaf   # Terminal Markdown viewer
```

**leaf** — просмотрщик Markdown в терминале: подсветка синтаксиса, рендеринг LaTeX, TOC с активной секцией, live reload, fuzzy-поиск файлов, 5 тем.

### Neovim + LazyVim

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
# Добавь в ~/.config/nvim/init.vim: set relativenumber
nvim  # Запусти и дай плагинам установиться
:LazyHealth  # Проверь здоровье
```

### Ollama (опционально)

```bash
brew install ollama
ollama pull codellama:13b
ollama pull deepseek-coder:6.7b
ollama pull llama2:7b
ollama pull mistral
```

GUI (скриптом не ставятся, оба нужно устанавливать вручную):
[mindMac](https://mindmac.app/) или [Msty](https://msty.app/)

---

## Структура репозитория

```
macos-dotfiles/
├── .zshrc                    # Главный конфиг shell
├── README.md                 # Этот файл
├── docs/                     # 📚 Документация
│   ├── SETUP.md
│   └── HOMEBREW_AUTOUPDATE.md
├── shell/                    # 🐚 Shell конфиги
│   └── sorokin.zsh-theme
├── terminal/                 # 🖥️ Терминалы
│   ├── config (Ghostty)
│   └── sorokin.terminal-theme.terminal
├── raycast/                  # 🚀 Raycast launcher
│   ├── README.md
│   └── BACKUP_INSTRUCTIONS.md
├── nvim/                     # 📝 Neovim
│   ├── config/
│   └── plugins/
├── scripts/                  # 🔧 Скрипты
│   ├── setup.sh
│   ├── brew_upgrade_logged.sh
│   ├── brew_upgrade_cron.sh
│   └── com.user.homebrew-autoupdate.plist
└── misc/                     # 🎹 Разное
    └── kbd67mkiirgbv3.layout.json
```

---

## После установки

```bash
# Перезапусти терминал или
source ~/.zshrc

# Проверь установку
brew --version
mise --version
nvim --version
git --version
node --version

# Проверь алиасы
alias | grep -E "(glg|gl|ter|tre)"

# Проверь Neovim
nvim
:LazyHealth
```

---

## Полезные ссылки

- [Homebrew](https://brew.sh/)
- [Oh My Zsh](https://ohmyz.sh/)
- [LazyVim](https://www.lazyvim.org/)
- [Ghostty Terminal](https://ghostty.org/)
- [Raycast](https://www.raycast.com/)
- [Monaspace Font](https://github.com/githubnext/monaspace)
- [mise (runtime manager)](https://mise.jdx.dev/)

---

## Лицензия

Личная конфигурация. Используй на своё усмотрение.
