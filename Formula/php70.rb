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

  def install_args
    args = super

    # Sylvane Specific build arguments
    args << "--enable-apcu"
    args << "--enable-imagick"
    args << "--with-imap=#{Formula['imap-uw'].opt_prefix}"
    args << "--with-imap-ssl=" + Formula['openssl'].opt_prefix.to_s
    args << "--with-intl"
    args << "--with-mcrypt"
    args << "--with-mongodb"
    args << "--with-tidy"
    args << "--with-opcache"


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

  def php_version
    "7.0"
  end

  def php_version_path
    "70"
  end
end


