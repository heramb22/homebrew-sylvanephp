require File.expand_path("../../Abstract/abstract-php", __FILE__)

class Php70 < AbstractPhp
  init
  desc "PHP Version 7.0"
  bottle do
  end

  include AbstractPhpVersion::Php70Defs

  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]
  version PHP_VERSION

  head PHP_GITHUB_URL, :branch => PHP_BRANCH

  option "with-imap"
  option "with-fpm"
  option "with-apcu"
  option "without-apache"
  option "with-imagick"
  option "with-mcrypt"
  option "enable-opcache"
  option "with-tidy"

  depends_on "php70-mcrypt" => :recommended
  depends_on "php70-opcache" => :recommended
  depends_on "php70-tidy" -> :recommended

  def install_args
    args = super

    # Sylvane Specific build arguments
    #args << "--enable-apcu"
    #args << "--enable-imagick"
    #args << "--with-imap=#{Formula['imap-uw'].opt_prefix}"
    #args << "--with-imap-ssl=" + Formula['openssl'].opt_prefix.to_s
    args << "--with-intl"
    #args << "--with-mcrypt"
    args << "--with-mongodb"
    #args << "--with-tidy"
    #args << "--with-opcache"


    # dtrace is not compatible with phpdbg: https://github.com/krakjoe/phpdbg/issues/38
    if build.without? "phpdbg"
      args << "--enable-dtrace"
      args << "--disable-phpdbg"
    else
      args << "--enable-phpdbg"

      if build.with? "debug"
        args << "--enable-phpdbg-debug"
      end
    end

    args << "--enable-zend-signals"
  end

  def _install
    super

    # Add new version of php to PATH before currently installed version
    system "export PATH=\"$(brew --prefix heramb22/sylvanephp/php#{php_version.gsub('.','')})/bin:$PATH\""

    # Launch FPM on startup
    system "mkdir -p ~/Library/LaunchAgents; cp #{opt_prefix}/#{plist_name}.plist ~/Library/LaunchAgents/; launchctl load -w ~Library/LaunchAgents/#{plist_name}.plist"

    #system "brew install php#{php_version_path}-mcrypt"
    #system "brew install php#{php_version_path}-opcache"
    #system "brew install php#{php_version_path}-tidy"
  end

  def php_version
    "7.0"
  end

  def php_version_path
    "70"
  end


end


