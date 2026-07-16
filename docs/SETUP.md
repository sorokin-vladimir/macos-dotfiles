# Настройка macOS окружения

Скрипт для автоматической настройки всего, что нужно для работы на новом маке.

## Быстрый старт

```bash
# Перейди в папку с репозиторием
cd ~/Documents/macos-dotfiles

# Запусти скрипт
./setup.sh
```

Скрипт задаст несколько вопросов и сам всё поставит.

## Что делает скрипт автоматически

### 1. Установка Homebrew

- Проверяет, стоит ли уже Homebrew
- Если нет - ставит
- Настраивает PATH для Apple Silicon

### 2. Установка пакетов через Homebrew

**CLI инструменты (устанавливаются всегда):**

- `mise` - менеджер версий языков и инструментов (замена asdf)
- `thefuck` - исправление ошибок в командах
- `gnupg` - GPG для подписи коммитов
- `git` - в macOS свой git есть (идёт с Xcode CLT), но он заметно отстаёт: 2.50.1 против 2.55.0 в brew. Отдельная строка в PATH не нужна - формула не keg-only, а `/opt/homebrew/bin` и так стоит первым, так что brew-версия перекрывает системную сама
- `tlrc` - упрощенные man-страницы (клиент tldr)
- `translate-shell` - перевод в терминале
- `neovim` - текстовый редактор
- `zsh-autosuggestions` - автодополнение команд в zsh
- `zsh-syntax-highlighting` - подсветка синтаксиса команд
- `fd` - быстрый поиск файлов
- `fzf` - fuzzy finder
- `ripgrep` - быстрый grep
- `lazygit` - TUI для git
- `lazysql` - TUI для баз данных
- `yazi` - файловый менеджер в терминале
- `ast-grep` - поиск и рефакторинг кода по AST
- `bat` - cat с подсветкой синтаксиса
- `btop` - монитор ресурсов системы
- `ncdu` - интерактивный анализ занятого места
- `curl` - в Homebrew он keg-only, потому что свой curl есть в macOS. `.zshrc` добавляет `/opt/homebrew/opt/curl/bin` в начало PATH, иначе brew-версия не используется. Отличия от системной: OpenSSL вместо LibreSSL, HTTP/3, brotli, zstd
- `pnpm` - пакетный менеджер Node (`.zshrc` настраивает `PNPM_HOME`)
- `gh` - GitHub CLI
- `glow` - рендеринг Markdown в терминале
- `golangci-lint` - линтер для Go
- `goreleaser` - сборка и публикация релизов Go
- `unar` - распаковка архивов
- `tele` (tap `sorokin-vladimir/tap`) - TUI-клиент Telegram
- `tele-beta` (tap `sorokin-vladimir/tap`) - бета-канал `tele`, ставится как бинарь `tele-beta` (можно держать вместе со стабильным)

**Claude Code CLI (спросит перед установкой):**

- `claude` - терминальный AI coding assistant от Anthropic
- Native install: автоматические обновления, устанавливается в `~/.local/bin/claude`
- После установки запустить: `claude auth login`

**GUI приложения (выбор стрелками, space - отметить, enter - подтвердить):**

Отмеченные по умолчанию:

- `anki` - система интервальных повторений
- `claude` - Claude Desktop от Anthropic
- `firefox` - браузер
- `zen` - браузер (бывший `zen-browser`)
- `hey-desktop` - почтовый клиент HEY (бывший `hey`)
- `keepassxc` - менеджер паролей
- `logseq` - заметки и knowledge base
- `simplenote` - простые заметки
- `spotify` - музыка
- `telegram` - мессенджер
- `vlc` - медиаплеер
- `ghostty` - эмулятор терминала
- `raycast` - лаунчер вместо Spotlight
- `bruno` - API-клиент
- `dbeaver-community` - клиент баз данных
- `neohtop` - GUI-монитор процессов и ресурсов (htop on steroids)
- `orbstack` - Docker и Linux-контейнеры
- `ungoogled-chromium` - браузер
- `zed` - редактор кода
- `claude-usage-tracker` (tap `hamed-elfayome/claude-usage`) - мониторинг использования Claude

Не отмеченные по умолчанию (редко используемые):

- `discord` - мессенджер
- `transmission` - торрент-клиент
- `tunnelblick` - VPN клиент
- `zoom` - видеоконференции

### 3. Установка Oh My Zsh

- Ставит Oh My Zsh (фреймворк для zsh)
- В unattended режиме (не переключает shell в процессе)

### 4. Копирование конфигов

**Shell:**

- `.zshrc` → `~/.zshrc` (старый файл бэкапится)
- `sorokin.zsh-theme` → `~/.oh-my-zsh/custom/themes/`

**Ghostty:**

- `config` → `~/Library/Application Support/com.mitchellh.ghostty/config`

**Neovim (спросит перед копированием):**

- `config_keymaps.lua` → `~/.config/nvim/lua/config/keymaps.lua`
- `config_options.lua` → `~/.config/nvim/lua/config/options.lua`
- `plugins_*.lua` → `~/.config/nvim/lua/plugins/*.lua` (префикс `plugins_` убирается)

### 5. Настройка Git

- Спрашивает `user.name` и `user.email`, Enter оставляет дефолт
- Дефолт - то, что уже настроено в git; на чистой машине - Vladimir Sorokin <v.sorokin@hey.com>
- С `--non-interactive` берёт дефолт без вопросов
- Ставит nvim как редактор по умолчанию (`core.editor`)
- Добавляет alias `please` для `push --force-with-lease`

### 6. Установка Git completion

- Качает скрипты автодополнения для Git
- Сохраняет в `~/.zsh/`
- Удаляет старый кэш (`.zcompdump`)

### 7. Настройка mise

- Предлагает поставить Node.js 24 через mise
  - Команда: `mise use -g node@24`
- Предлагает поставить Go через mise
  - Команда: `mise use -g go@latest`
- Предлагает поставить Go-инструменты (aqua backend)
  - `mise use -g aqua:sqlc-dev/sqlc` - генератор кода из SQL
  - `mise use -g aqua:golang-migrate/migrate` - миграции БД

### 8. Проверка SSH

- Только проверяет, есть ли ключ, и печатает инструкцию, если нет
- Ключ не генерится: чтобы склонить этот репозиторий по SSH (см. README),
  рабочий ключ уже нужен, так что до скрипта дело всё равно не доходит.
  Да и `ssh-keygen` интерактивен, а публичный ключ всё равно добавлять
  в GitHub руками

## Опции командной строки

```bash
# Показать справку
./setup.sh --help

# Пропустить установку Homebrew (если уже установлен)
./setup.sh --skip-homebrew

# Пропустить установку приложений
./setup.sh --skip-apps

# Пропустить настройку shell (Oh My Zsh)
./setup.sh --skip-shell

# Пропустить установку Git completion
./setup.sh --skip-git-completion

# Неинтерактивный режим (все "yes" по умолчанию)
./setup.sh --non-interactive

# Комбинация опций
./setup.sh --skip-homebrew --skip-apps --non-interactive
```

## Что нужно доделать руками

### 1. Шрифты ⚠️ ОБЯЗАТЕЛЬНО

Скрипт ставит шрифт сам - спросит «Install Nerd Fonts?» и поставит
`font-monaspice-nerd-font`. Вручную то же самое:

```bash
brew install --cask font-monaspice-nerd-font
```

Важно про написание: нужен именно `font-monasp**i**ce-nerd-font`
(Nerd Fonts переименовывает Monaspace в Monaspice). Обычный `font-monaspace`
с [github.com/githubnext/monaspace](https://github.com/githubnext/monaspace) -
это другой каск, без иконок, и zsh-тема с ним поедет. Ghostty настроен на
`font-family = "MonaspiceNe Nerd Font Mono Light"`.

Проверить, что иконки видны: `./shell/check-nerd-fonts.sh`

### 2. Git (если нужно поменять)

**Скрипт спрашивает при установке (Enter - оставить дефолт):**

- `user.name` - дефолт: текущий из git, иначе Vladimir Sorokin
- `user.email` - дефолт: текущий из git, иначе v.sorokin@hey.com

**Ставит без вопросов:**

- `core.editor`: nvim

**Если захочешь поменять:**

```bash
# Поменять имя и email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Поменять редактор
git config --global core.editor "vim"

# Посмотреть что стоит
git config --global user.name
git config --global user.email
git config --global core.editor
```

### 3. GPG для подписи коммитов (если надо)

```bash
# Сгенери GPG ключ
gpg --full-generate-key

# Посмотри список ключей
gpg --list-secret-keys --keyid-format=long

# Настрой Git
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true

# Добавь публичный ключ в GitHub/GitLab
gpg --armor --export YOUR_KEY_ID
```

### 4. Перезапуск терминала

После установки перезапусти терминал или сделай:

```bash
source ~/.zshrc
```

### 5. Проверка Neovim

После первого запуска Neovim проверь что всё ок:

```bash
nvim
# В Neovim выполни:
:LazyHealth
```

### 6. SSH ключ для GitHub/GitLab

Скрипт ключ не создаёт - только проверяет наличие. Если его нет:

```bash
# Создать
ssh-keygen -t ed25519 -C "your@email"

# Положить в agent, пароль подхватится из Keychain
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Скопировать публичный ключ
pbcopy < ~/.ssh/id_ed25519.pub
```

Отдельный ssh-agent поднимать не надо: в macOS он уже запущен через launchd.
`.zshrc` только докидывает ключ, если агент пустой.

Добавь его:

- GitHub: Settings → SSH and GPG keys → New SSH key
- GitLab: Preferences → SSH Keys → Add key

### 7. Claude Code CLI (если поставил)

```bash
# Авторизуйся через браузер
claude auth login

# Проверь версию
claude --version

# Автообновления включены по умолчанию
```

### 8. Ollama (если нужны локальные LLM)

```bash
# Поставь Ollama
brew install ollama

# Запусти сервис
brew services start ollama

# Качай модели
ollama pull codellama:13b
ollama pull deepseek-coder:6.7b
ollama pull llama2:7b
ollama pull mistral
```

### 9. pnpm (если используешь)

pnpm уже настроен в `.zshrc`, но если нужна глобальная установка:

```bash
# Через npm
npm install -g pnpm

# Или через Homebrew
brew install pnpm
```

### 10. Terminal.app тема (если используешь стандартный терминал)

Если не используешь Ghostty, а стандартный Terminal.app:

1. Открой Terminal → Preferences → Profiles
2. Кнопка с шестеренкой → Import...
3. Выбери `sorokin.terminal-theme.terminal`
4. Поставь как Default

### 11. Клавиатура (если есть kbd67mkiirgbv3)

Если у тебя kbd67mkiirgbv3:

- Файл `kbd67mkiirgbv3.layout.json` - это layout
- Импорт через VIA или другую софтину

## Проверка

Проверь что всё работает:

```bash
# CLI инструменты
brew --version
mise --version
thefuck --version
nvim --version
git --version

# Claude Code CLI (если ставил)
claude --version

# Настройки Git
git config --global user.name
git config --global user.email
git config --global core.editor

# Node.js через mise
node --version
npm --version

# Shell плагины
# Введи неправильную команду, ESC, потом fuck

# Алиасы
alias | grep -E "(glg|gl|ter|tre|submodule)"

# Yazi
y  # должен открыть файловый менеджер

# Neovim
nvim  # должен открыться с LazyVim
```

## Полезные команды после установки

```bash
# Git
glg                    # Красивый git log с графом
gl                     # Git log без графа
git please             # git push --force-with-lease
submodule              # Обновить submodules

# Переводы
ter hello              # Перевести с EN на RU
tre привет             # Перевести с RU на EN

# Навигация
cic                    # Перейти в iCloud Drive
cl                     # Перейти в Logseq documents
n                      # Открыть neovim в текущей директории
y                      # Открыть yazi file manager

# mise
mise use node@20       # Установить Node.js 20 в текущем проекте
mise use -g python@3.11 # Установить Python 3.11 глобально
mise ls                # Показать установленные инструменты

# thefuck
fuck                   # Исправить последнюю команду (после ESC)
```

## Дополнительные инструменты (не в скрипте)

Эти инструменты не устанавливаются через `setup.sh`, но полезны знать.

### vhs

Записывает сессии терминала в GIF/MP4 по сценарию (`.tape`-файл): вводимые команды, тайминги, тема, размер окна.
Удобно для демок в README — запись воспроизводима и правится как код, без ручного перезаписывания видео.

- Установка: `brew install vhs`
- Репозиторий: [github.com/charmbracelet/vhs](https://github.com/charmbracelet/vhs)

### nethack

Классический roguelike в терминале.

- Установка: `brew install nethack`

### Pake

Оборачивает любой сайт в нативное лёгкое десктопное приложение (macOS, Windows, Linux).
Использует Tauri/Rust вместо Electron — приложения весят ~5 МБ.

- Установка: `npm install -g pake-cli`
- Репозиторий: [github.com/tw93/Pake](https://github.com/tw93/Pake)

### llm-checker

CLI инструмент, анализирует характеристики железа (RAM, GPU, VRAM) и рекомендует оптимальные локальные LLM модели.

### bento-pdf

Self-hosted веб-приложение для работы с PDF. Умеет объединять, разделять, сжимать, конвертировать, делать OCR и многое другое. Разворачивается через Docker.

- Репозиторий: [github.com/alam00000/bentopdf](https://github.com/alam00000/bentopdf)

## Если что-то сломалось

### Homebrew не находится

```bash
# Для Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Или просто перезапусти терминал
```

### zsh completion тупит

```bash
# Снеси кэш и перезагрузи
rm ~/.zcompdump*
source ~/.zshrc
```

### Oh My Zsh тема не работает

```bash
# Проверь что файл темы на месте
ls ~/.oh-my-zsh/custom/themes/sorokin.zsh-theme

# Проверь .zshrc
grep "ZSH_THEME" ~/.zshrc
# Должно быть: ZSH_THEME="sorokin"
```

### Neovim конфиг не работает

```bash
# Снеси конфиг
rm -rf ~/.config/nvim

# Запусти скрипт для копирования
cd ~/Documents/macos-dotfiles
./setup.sh --skip-homebrew --skip-apps --skip-shell --non-interactive

# Запусти Neovim - плагины поставятся сами
nvim
```

### Ghostty конфиг не применяется

```bash
# Проверь что файл на месте
ls ~/Library/Application\ Support/com.mitchellh.ghostty/config

# Перезапусти Ghostty или Cmd+R
```

### GPG signing не пашет

```bash
# Проверь что GPG_TTY есть
echo $GPG_TTY

# Если пусто, добавь в .zshrc (должно уже быть):
export GPG_TTY=$(tty)

# Перезагрузи shell
source ~/.zshrc
```

## Обновление конфигов

Если обновил файлы в репе и хочешь применить изменения:

```bash
# Только конфиги (без установки пакетов)
./setup.sh --skip-homebrew --skip-apps --skip-shell --non-interactive

# Или руками
cp .zshrc ~/.zshrc
cp sorokin.zsh-theme ~/.oh-my-zsh/custom/themes/
cp config ~/Library/Application\ Support/com.mitchellh.ghostty/config
source ~/.zshrc
```

## Откат

Если нужно всё откатить:

```bash
# Вернуть старый .zshrc
cp ~/.zshrc.backup ~/.zshrc

# Снести Oh My Zsh
uninstall_oh_my_zsh

# Снести Neovim конфиг
rm -rf ~/.config/nvim

# Снести Homebrew (аккуратно!)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

## Что где лежит

```
macos-dotfiles/
├── setup.sh                      # Скрипт установки
├── SETUP.md                      # Эта документация
├── README.md                     # Общая инфа
├── .zshrc                        # Конфиг zsh
├── sorokin.zsh-theme            # Кастомная тема Oh My Zsh
├── config                        # Конфиг Ghostty
├── config_keymaps.lua           # Кейбинды Neovim
├── config_options.lua           # Опции Neovim
├── plugins_*.lua                # Плагины Neovim (копируются без префикса)
├── kbd67mkiirgbv3.layout.json  # Layout клавиатуры
└── sorokin.terminal-theme.terminal # Тема для Terminal.app
```

## Про скрипт

- Можно запускать сколько угодно раз - проверяет что уже стоит
- Создаёт бэкапы перед заменой файлов
- Работает только на macOS
- Поддерживает Intel и Apple Silicon
- Все интерактивные вопросы можно скипнуть через флаги
