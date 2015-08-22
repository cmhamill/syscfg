{% set apt = salt['pillar.get']('apt') %}

/etc/apt/apt.conf.d/02default-release:
  file.managed:
    - contents:
        APT::Default-Release "{{ apt.default_release }}";
    - watch_in: aptpkg.refresh_db

/etc/apt/apt.conf.d/05no-recommends:
  file.managed:
    - contents: |
        APT::Install-Recommends "false";
    - watch_in: aptpkg.refresh_db

/etc/apt/apt.conf.d/05no-suggests:
  file.managed:
    - contents: |
        APT::Install-Suggests "false";
    - watch_in: aptpkg.refresh_db

/etc/apt/sources.list:
  file.managed:
    - contents: |
        # Debian {{ apt.default_release }} APT repositories.
        deb http://ftp.us.debian.org/debian/ testing main contrib non-free
        deb-src http://ftp.us.debian.org/debian/ testing main contrib non-free

        # Debian Security Team APT repositories for {{ apt.default_release }}.
        deb http://security.debian.org/ testing/updates main contrib non-free
        deb-src http://security.debian.org/ testing/updates main contrib non-free
    - watch_in: aptpkg.refresh_db

{% for name in apt.sources %}
/etc/apt/sources.list.d/{{ name }}.list:
  file.managed:
    - contents_pillar: apt:sources:{{ name }}
    - watch_in: aptpkg.refresh_db
{% endfor %}

aptpkg.refresh_db:
  module.wait
