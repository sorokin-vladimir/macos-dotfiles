# macos-dotfiles

[English](README.md) | **Русский**

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

📖 Подробная инструкция: **[docs/SETUP.ru.md](docs/SETUP.ru.md)**

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
- Навигация: `cic` (iCloud), `y` (yazi с переходом в текущую папку)
- Утилиты: `ter`/`tre` (перевод), `n` (neovim), `lg` (lazygit), `bupd` (обновить brew)

📖 Подробнее: **[shell/README.md](shell/README.md)** (на русском)

---

## 🖥️ Terminal

**Папка:** [`terminal/`](terminal/)

### Ghostty (основной)
- TokyoNight тема (Moon/Day)
- Шрифт: MonaspiceNe Nerd Font Mono, Light
- Vim-style навигация: `cmd+shift+hjkl`
- Quick terminal: `cmd+g`

### Terminal.app (legacy)
- Старая тема для совместимости

📖 Подробнее: **[terminal/README.md](terminal/README.md)** (на русском)

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
1. Хоткей Spotlight уже выключает `setup.sh` (шаг с клавиатурой); если шаг пропущен - отключить в System Settings
2. Проверить хоткей `Ctrl+Space` в Raycast (должен восстановиться автоматически)

📖 Подробнее: **[raycast/README.md](raycast/README.md)** (на русском)

---

## 📝 Editors

### Neovim + LazyVim

**Папка:** [`nvim/`](nvim/)

```
nvim/
├── config/           # Кейбинды и опции
│   ├── keymaps.lua
│   └── options.lua
├── plugins/          # Настройки плагинов
│   ├── cmp.lua
│   ├── codeium.lua
│   ├── colorscheme.lua
│   ├── lint.lua
│   ├── surround.lua
│   └── which-key.lua
└── lazyvim.json      # Включённые LazyVim extras
```

**Основные кейбинды:**
- `jj`/`kk` - выход из insert mode
- `<leader>dl` - console.log
- `<leader>cP` - показать путь к файлу
- `Shift+H`/`Shift+L` - навигация между буферами

📖 Подробнее: **[nvim/README.md](nvim/README.md)** (на русском)

---

## 🔧 Scripts

**Папка:** [`scripts/`](scripts/)

### setup.sh
Главный скрипт автоматической установки окружения.

```bash
./scripts/setup.sh                    # Полная установка
./scripts/setup.sh --non-interactive  # Без вопросов, берёт дефолты
./scripts/setup.sh --skip-apps        # Пропустить приложения
./scripts/setup.sh --skip-macos       # Пропустить раскладки и хоткеи
```

Вопросы задаются одной клавишей, а список GUI-приложений выбирается стрелками:
`space` - отметить, `a` - все, `enter` - подтвердить, `q` - пропустить.

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

Скрипт будет запускаться ежедневно в 11:09 с уведомлениями о:
- Количестве доступных обновлений
- Проблемах из `brew doctor`
- Успехе/ошибке операции

📖 Подробнее: **[scripts/README.md](scripts/README.md)** | **[docs/HOMEBREW_AUTOUPDATE.md](docs/HOMEBREW_AUTOUPDATE.md)** (на русском)

---

## 📚 Documentation

**Папка:** [`docs/`](docs/)

- **[SETUP.ru.md](docs/SETUP.ru.md)** - полная инструкция по установке
- **[HOMEBREW_AUTOUPDATE.md](docs/HOMEBREW_AUTOUPDATE.md)** - настройка автообновлений (на русском)

---

## 🎹 Miscellaneous

**Папка:** [`misc/`](misc/)

- Конфигурация клавиатуры KBD67 MKII RGB V3 (VIA)

📖 Подробнее: **[misc/README.md](misc/README.md)** (на русском)

---

## Установка компонентов

### Xcode Command Line Tools

```bash
xcode-select --install
```

### Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Пакеты

**CLI tools:**
```bash
brew install mise thefuck gnupg git tlrc translate-shell neovim \
  zsh-autosuggestions zsh-syntax-highlighting fd fzf ripgrep \
  lazygit lazysql ec gitlogue curl yazi ast-grep bat btop ncdu tokei gh glow \
  golangci-lint goreleaser unar pnpm lla tele

# Сторонние тапы: сначала trust, потом tap. С Homebrew 6 `brew tap` загружает
# все формулы для проверки тапа и падает на недоверенных
brew trust --tap sorokin-vladimir/tap
brew tap sorokin-vladimir/tap
brew install tele-beta

# weathr в homebrew-core нет
brew trust --tap veirt/veirt
brew tap veirt/veirt
brew install weathr

# lsoff в homebrew-core нет
brew trust --tap yutat23/tap
brew tap yutat23/tap
brew install lsoff
```

**GUI apps:**
```bash
# Tap for Claude Usage Tracker
brew trust --tap hamed-elfayome/claude-usage
brew tap hamed-elfayome/claude-usage
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

**Тренажёр слепой печати** (не ставится скриптом - поставить, когда понадобится):
```bash
# Делает упражнения из исходников текущего репозитория
brew install gittype
```

### Claude Code CLI

```bash
# Native install - то, что делает setup.sh
curl -fsSL https://claude.ai/install.sh | bash
claude auth login
```

Есть и каск `claude-code`, но скрипт использует native install: он сам себя
обновляет и кладётся в `~/.local/bin/claude`.

### Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Шрифты ⚠️ ОБЯЗАТЕЛЬНО

```bash
# Nerd-патченый Monaspace. Ghostty настроен именно на него:
# font-family = "MonaspiceNe Nerd Font Mono"
# font-style = Light
brew install --cask font-monaspice-nerd-font
```

Обрати внимание на написание: каск называется `font-monaspice-nerd-font`, через
`i`. Причина - лицензионная: `Monaspace` это Reserved Font Name по SIL OFL, так
что Nerd Fonts не имеет права назвать патченую версию так же. Обычный
`font-monaspace` не подойдёт - в нём нет иконок, которые использует zsh-тема.

Проверить, что иконки видны: `./shell/check-nerd-fonts.sh`

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

### Раскладки и хоткеи

`setup.sh` делает это на шаге с клавиатурой. Вручную, в System Settings > Keyboard:

- Input Sources: ABC и Russian - PC (запятая и точка на клавише у правого
  Shift, а не на Shift+6 / Shift+7)
- Keyboard Shortcuts > Input Sources: предыдущий источник ввода на `Cmd+Space`
- Keyboard Shortcuts > Spotlight: выключить, чтобы `Ctrl+Space` достался Raycast

### npm Global Packages

```bash
npm install -g @rivolink/leaf   # Terminal Markdown viewer
```

**leaf** — просмотрщик Markdown в терминале: подсветка синтаксиса, рендеринг LaTeX, TOC с активной секцией, live reload, fuzzy-поиск файлов, 5 тем.

### Neovim + LazyVim

`setup.sh` ставит starter сам, если нет `~/.config/nvim/init.lua`. Вручную:

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
├── README.md                 # Обзор (English)
├── README.ru.md              # Этот файл
├── LICENSE                   # MIT
├── docs/                     # 📚 Документация
│   ├── SETUP.md              # Установка (English)
│   ├── SETUP.ru.md           # Установка (на русском)
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

MIT - см. [LICENSE](LICENSE).

Это личная конфигурация: разбирай на части и бери что нужно, но имей в виду,
что дефолты подогнаны под конкретную машину и вкусы автора.
