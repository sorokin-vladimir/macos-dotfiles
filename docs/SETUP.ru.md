# Настройка macOS окружения

[English](SETUP.md) | **Русский**

Скрипт для автоматической настройки всего, что нужно для работы на новом маке.

## Быстрый старт

```bash
# Перейди в папку с репозиторием
cd ~/Documents/macos-dotfiles

# Запусти скрипт
./scripts/setup.sh
```

Скрипт задаст несколько вопросов и сам всё поставит. Вопросы отвечаются одной
клавишей, список GUI-приложений выбирается стрелками.

> SSH-ключ нужен **до** запуска: репозиторий клонируется по SSH. Скрипт ключ не
> создаёт, только проверяет. См. [README.ru.md](../README.ru.md#шаг-0-ssh-ключ).

## Что делает скрипт автоматически

### 1. Установка Xcode Command Line Tools и Homebrew

- Ставит Xcode Command Line Tools, если `xcode-select -p` их не находит, и ждёт, пока закончится системный диалог
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
- `ec` - TUI-мерджтул для разрешения конфликтов в git (3-way)
- `gitlogue` - проигрывает историю коммитов как анимацию в терминале
- `yazi` - файловый менеджер в терминале
- `ast-grep` - поиск и рефакторинг кода по AST
- `bat` - cat с подсветкой синтаксиса
- `lla` - замена `ls` с несколькими режимами вывода (дерево, таймлайн, git) и системой плагинов
- `btop` - монитор ресурсов системы
- `ncdu` - интерактивный анализ занятого места
- `tokei` - подсчёт строк кода по языкам
- `curl` - в Homebrew он keg-only, потому что свой curl есть в macOS. `.zshrc` добавляет `/opt/homebrew/opt/curl/bin` в начало PATH, иначе brew-версия не используется. Отличия от системной: OpenSSL вместо LibreSSL, HTTP/3, brotli, zstd
- `pnpm` - пакетный менеджер Node (`.zshrc` настраивает `PNPM_HOME`)
- `gh` - GitHub CLI
- `glow` - рендеринг Markdown в терминале
- `golangci-lint` - линтер для Go
- `goreleaser` - сборка и публикация релизов Go
- `unar` - распаковка архивов
- `tele` - TUI-клиент Telegram (homebrew-core)
- `tele-beta` (tap `sorokin-vladimir/tap`) - бета-канал `tele`, ставится как бинарь `tele-beta` (можно держать вместе со стабильным)
- `weathr` (tap `veirt/veirt`) - погода в терминале с ASCII-анимациями; в homebrew-core его нет, поэтому скрипт сначала доверяет тапу `veirt/veirt`, потом подключает его
- `lsoff` (tap `yutat23/tap`) - CLI/TUI, показывает, какие процессы слушают TCP/UDP-порты, и умеет прибить тот, что занял порт; в homebrew-core его нет, поэтому скрипт сначала доверяет тапу `yutat23/tap`, потом подключает его

Сторонним тапам скрипт доверяет до `brew tap`, а не после. С Homebrew 6
`brew tap` загружает все формулы тапа для проверки, отказывается грузить
недоверенные и падает с `invalid syntax in tap!`.

**Не ставится скриптом (поставить руками, когда понадобится):**

- `gittype` - тренажёр слепой печати, делает упражнения из исходников текущего репозитория: `brew install gittype`

**Claude Code CLI (спросит перед установкой):**

- `claude` - терминальный AI coding assistant от Anthropic
- Native install: автоматические обновления, устанавливается в `~/.local/bin/claude`
- После установки запустить: `claude auth login`

**GUI приложения (выбор стрелками, space - отметить, a - все, enter - подтвердить, q - пропустить):**

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

- Если нет `~/.config/nvim/init.lua`, сначала ставит [LazyVim starter](https://github.com/LazyVim/starter). В репе лежат только доработки, а `init.lua` и `lua/config/lazy.lua`, которые загружают LazyVim, берутся из starter
- `nvim/config/*.lua` → `~/.config/nvim/lua/config/`
- `nvim/plugins/*.lua` → `~/.config/nvim/lua/plugins/`
- `nvim/lazyvim.json` → `~/.config/nvim/lazyvim.json`

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
- Предлагает поставить глобальные npm-пакеты (`leaf`)
  - Команда: `mise exec node@24 -- npm install -g @rivolink/leaf`. mise активируется только в `.zshrc`, поэтому в bash-процессе скрипта `npm` в PATH нет
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

### 9. Раскладки и хоткеи (спросит перед настройкой)

- Источники ввода: ABC и Russian - PC. В PC-раскладке запятая и точка на клавише у правого Shift, а не на Shift+6 / Shift+7
- `Cmd+Space` переключает на предыдущий источник ввода, `Ctrl+Opt+Space` - на следующий
- Хоткеи Spotlight выключаются, `Ctrl+Space` освобождается для Raycast
- Хоткеи применяются сразу, раскладки - полностью после перелогина

## Опции командной строки

```bash
# Показать справку
./scripts/setup.sh --help

# Пропустить установку Homebrew (если уже установлен)
./scripts/setup.sh --skip-homebrew

# Пропустить установку приложений
./scripts/setup.sh --skip-apps

# Пропустить настройку shell (Oh My Zsh)
./scripts/setup.sh --skip-shell

# Пропустить установку Git completion
./scripts/setup.sh --skip-git-completion

# Пропустить настройку раскладок и хоткеев
./scripts/setup.sh --skip-macos

# Неинтерактивный режим: берёт дефолт каждого вопроса
./scripts/setup.sh --non-interactive

# Комбинация опций
./scripts/setup.sh --skip-homebrew --skip-apps --non-interactive
```

`--non-interactive` берёт именно дефолт вопроса, а не «да» на всё: приложения
с отметкой по умолчанию поставятся, редко используемые - нет. Тот же режим
включается сам, если stdin не терминал (`curl | bash`, CI) - иначе скрипт
завис бы на `read`.

## Что нужно доделать руками

### 1. Шрифты ⚠️ ОБЯЗАТЕЛЬНО

Скрипт ставит шрифт сам - спросит «Install Nerd Fonts?» и поставит
`font-monaspice-nerd-font`. Вручную то же самое:

```bash
brew install --cask font-monaspice-nerd-font
```

Важно про написание: нужен именно `font-monaspice-nerd-font`, через `i`.
Причина лицензионная: `Monaspace` - это Reserved Font Name по SIL OFL, поэтому
Nerd Fonts не имеет права выпустить патченую версию под тем же именем. Обычный
`font-monaspace` с [github.com/githubnext/monaspace](https://github.com/githubnext/monaspace) -
это другой каск, без иконок, и zsh-тема с ним поедет. Ghostty настроен на
`font-family = "MonaspiceNe Nerd Font Mono"` с `font-style = Light`. Толщина
задаётся именно отдельным `font-style`: `MonaspiceNe Nerd Font Mono Light` - не
имя семейства, и Ghostty молча откатится на встроенный JetBrains Mono.

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

### 9. Terminal.app тема (если используешь стандартный терминал)

Если не используешь Ghostty, а стандартный Terminal.app:

1. Открой Terminal → Preferences → Profiles
2. Кнопка с шестеренкой → Import...
3. Выбери `terminal/sorokin.terminal-theme.terminal`
4. Поставь как Default

### 10. Клавиатура (если есть kbd67mkiirgbv3)

Если у тебя kbd67mkiirgbv3:

- Файл `misc/kbd67mkiirgbv3.layout.json` - это layout
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
n                      # Открыть neovim в текущей директории
y                      # Открыть yazi, на выходе перейти в текущую папку

# Обслуживание
bupd                   # brew update && upgrade && cleanup
lg                     # lazygit

# mise
mise use node@20       # Установить Node.js 20 в текущем проекте
mise use -g python@3.11 # Установить Python 3.11 глобально
mise ls                # Показать установленные инструменты

# thefuck
fuck                   # Исправить последнюю команду (после ESC)
```

## Дополнительные инструменты (не в скрипте)

Эти инструменты не устанавливаются через `setup.sh`, но полезны знать.

### grandperspective

GUI для анализа занятого места - treemap-визуализация. В скрипте есть только
CLI-вариант (`ncdu`).

- Установка: `brew install --cask grandperspective`

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
./scripts/setup.sh --skip-homebrew --skip-apps --skip-shell --non-interactive

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

### curl остался системным

```bash
# Должно показать /opt/homebrew/opt/curl/bin/curl
command -v curl

# Если /usr/bin/curl - .zshrc не подхватился
source ~/.zshrc
```

### Развелись процессы ssh-agent

Симптом: `pgrep -x ssh-agent | wc -l` показывает десятки или сотни.

Причина - `eval "$(ssh-agent -s)"` в `.zshrc`, который поднимал новый агент на
каждый запуск шелла. В текущем конфиге этого нет, но старые процессы остаются:

```bash
pkill -x ssh-agent   # launchd-агент это переживёт
source ~/.zshrc
```

## Обновление конфигов

Если обновил файлы в репе и хочешь применить изменения:

```bash
# Только конфиги (без установки пакетов)
./scripts/setup.sh --skip-homebrew --skip-apps --skip-shell --non-interactive

# Или руками
cp .zshrc ~/.zshrc
cp shell/sorokin.zsh-theme ~/.oh-my-zsh/custom/themes/
cp terminal/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
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
├── .zshrc                            # Конфиг zsh
├── README.md                         # Обзор (English)
├── README.ru.md                      # Обзор (на русском)
├── LICENSE                           # MIT
├── docs/
│   ├── SETUP.md                      # Эта документация (English)
│   ├── SETUP.ru.md                   # Этот файл
│   └── HOMEBREW_AUTOUPDATE.md
├── scripts/
│   ├── setup.sh                      # Скрипт установки
│   ├── brew_upgrade_logged.sh
│   ├── brew_upgrade_cron.sh
│   ├── install_homebrew_autoupdate.sh
│   ├── raycast_backup.sh
│   ├── raycast_restore.sh
│   └── com.user.homebrew-autoupdate.plist
├── shell/
│   ├── sorokin.zsh-theme             # Кастомная тема Oh My Zsh
│   └── check-nerd-fonts.sh
├── terminal/
│   ├── config                        # Конфиг Ghostty
│   └── sorokin.terminal-theme.terminal
├── nvim/
│   ├── config/                       # Кейбинды и опции
│   └── plugins/                      # Плагины
├── raycast/
└── misc/
    └── kbd67mkiirgbv3.layout.json    # Layout клавиатуры
```

## Про скрипт

- Можно запускать сколько угодно раз - проверяет что уже стоит
- Создаёт бэкапы перед заменой файлов
- Работает только на macOS
- Поддерживает Intel и Apple Silicon
- Все интерактивные вопросы можно скипнуть через флаги
- Рассчитан на `/bin/bash` из macOS - это bash 3.2, поэтому без ассоциативных
  массивов и прочего из bash 4+
