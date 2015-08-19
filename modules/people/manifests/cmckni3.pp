class people::cmckni3 {
  include homebrew
  include zsh

  # required PHP taps
  homebrew::tap { 'homebrew/dupes': }
  homebrew::tap { 'homebrew/php': }

  # science tools such as R
  homebrew::tap { 'homebrew/science': }

  homebrew::tap { 'caskroom/versions': }

  $home = "/Users/${::boxen_user}"
  $my = "${home}/my"
  $dotfiles = "${my}/dotfiles"

  file { $my:
    ensure  => directory
  }

  # Code directories
  $code_dirs = [ "${home}/Code",
                 "${home}/Code/ruby",
                 "${home}/Code/ruby/rails",
                 "${home}/Code/ruby/ruby-motion",
                 "${home}/Code/js",
                 "${home}/Code/js/node",
                 "${home}/Code/swift",
                 "${home}/Code/objective-c",
                 "${home}/Code/go",
                 "${home}/Code/go/src",
                 "${home}/Code/go/pkg",
                 "${home}/Code/go/bin",
               ]

  file { $code_dirs:
    ensure  => directory
  }

  repository { $dotfiles:
    source => 'cmckni3/dotfiles',
    require => File[$my]
  }

  file { "${dotfiles}/zshrc":
    ensure => link,
    target => "${home}/.zshrc"
  }

  # Global ignore for git and mercurial
  file { "${dotfiles}/gitignore_global":
    ensure => link,
    target => "${home}/.gitignore_global"
  }
  file { "${dotfiles}/hgignore_global":
    ensure => link,
    target => "${home}/.hgignore_global"
  }

  # Ruby
  file { "${dotfiles}/gemrc":
    ensure => link,
    target => "${home}/.gemrc"
  }
  file { "${dotfiles}/irbrc":
    ensure => link,
    target => "${home}/.irbrc"
  }
  file { "${dotfiles}/rubocop.yml":
    ensure => link,
    target => "${home}/.rubocop.yml"
  }

  # JavaScript
  file { "${dotfiles}/jshintrc":
    ensure => link,
    target => "${home}/.jshintrc"
  }

  # tmux
  file { "${dotfiles}/tmux.conf":
    ensure => link,
    target => "${home}/.tmux.conf"
  }

  # vim
  file { "${dotfiles}/vimrc":
    ensure => link,
    target => "${home}/.vimrc"
  }

  repository { "${home}/.antigen":
    source => 'zsh-users/antigen'
  }

  # Set the global default ruby (auto-installs it if it can)
  #class { 'ruby::global':
  #  version => '2.2.2'
  #}

  # ensure a gem is installed for all ruby versions
  ruby_gem { 'bundler for all rubies':
    gem          => 'bundler',
    version      => '~> 1.0',
    ruby_version => '*',
  }

  # Set the global default node (auto-installs it if it can)
  #class { 'nodejs::global':
  #  version => '0.12'
  #}

  npm_module { 'coffeescript for all nodes':
    module       => 'coffee-script',
    node_version => '*',
  }

  npm_module { 'grunt for all nodes':
    module       => 'grunt-cli',
    node_version => '*',
  }

  npm_module { 'gulp for all nodes':
    module       => 'gulp',
    node_version => '*',
  }

  npm_module { 'bower for all nodes':
    module       => 'bower',
    node_version => '*',
  }

  include projects::all
}
