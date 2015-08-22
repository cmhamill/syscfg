apt:
  default_release: testing
  sources:
    unstable: |
      # Debian unstable APT repositories.
      deb http://ftp.us.debian.org/debian/ unstable main contrib non-free
      deb-src http://ftp.us.debian.org/debian/ unstable main contrib non-free
    experimental: |
      # Debian experimental APT repositories.
      deb http://ftp.us.debian.org/debian/ experimental main contrib non-free
      deb-src http://ftp.us.debian.org/debian/ experimental main contrib non-free
