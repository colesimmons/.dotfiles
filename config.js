module.exports = {
  brew: [
    // Abstract PDF Export
    'svn',
    'autojump',
    'cairo',
    'pango',

    // Navigation/search/misc
    'ag', // http://conqueringthecommandline.com/book/ack_ag
    'coreutils', // Install GNU core utilities (those that come with macOS are outdated)
    'findutils', // Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
    'readline', // ensure gawk gets good readline
    'gawk',

    // Languages/frameworks/etc
    'elasticsearch',
    'elixir',
    'erlang',
    'postgresql',
    'python@3.7',
    'yarn',

    // Editing
    'tmux',
    'vim --with-client-server --with-override-system-vi',

    // Casks
    'anki',
    'docker',
    'figma',
    'firefox',
    'flux',
    'google-chrome',
    'google-cloud-sdk',
    'iterm2',
    'mullvadvpn',
    "notion",
    'slack',
    'spotify',
    'tableplus',
    'the-unarchiver',
    'vlc',
    'zoom',

    // Fonts (must tap homebrew/cask-fonts first)
    "font-inconsolata-dz-for-powerline",
    "font-inconsolata-g-for-powerline",
    "font-inconsolata-for-powerline",
    "font-roboto-mono",
    "font-roboto-mono-for-powerline",
    "font-source-code-pro",
  ],
  npm: [
    'eslint',
    'elm',
    'elm-test',
    'elm-oracle',
    'elm-format',
    'firebase-tools',
    'npm-check',
    'trash',
    'vtop'
  ],
  mas: [
    //com.apple.dt.Xcode (10.2.1)
    '497799835',
  ],
};
