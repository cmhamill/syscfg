{% set console = salt['pillar.get']('console') %}

/etc/default/console-setup:
  file.managed:
    - contents: |
        # CONFIGURATION FILE FOR SETUPCON
        # Consult the console-setup(5) manual page.

        ACTIVE_CONSOLES="{{ console.active_consoles }}"

        CHARMAP="{{ console.charmap }}"

        CODESET="{{ console.codeset }}"
        FONTFACE="{{ console.fontface }}"
        FONTSIZE="{{ console.fontsize }}"

        VIDEOMODE=

        # The following is an example how to use a braille font
        # FONT='lat9w-08.psf.gz brl-8x8.psf'
