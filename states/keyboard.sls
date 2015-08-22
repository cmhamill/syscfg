{% set keyboard = salt['pillar.get']('keyboard') %}
{% set compose_key = salt['pillar.get']('keyboard:compose_key', 'menu') %}

/etc/default/keyboard:
  file.managed:
    - contents: |
        # KEYBOARD CONFIGURATION FILE
        # Consult the keyboard(5) manual page.

        XKBMODEL="{{ keyboard.model }}"
        XKBLAYOUT="{{ keyboard.layout }}"
        XKBVARIANT="{{ keyboard.variant|default('') }}"
        XKBOPTIONS="lv3:ralt_alt,ctrl:nocaps,compose:{{ compose_key }}"

        BACKSPACE="{{ keyboard.backspace|default('guess') }}"

/etc/console-setup/remap.inc:
  file.managed:
    - contents: |
        # The content of this file will be appended to the keyboard layout.
        # The following is an example how to make Alt+j switch to to the next
        # console and Alt+k switch to the previous console.

        # Uncomment the following lines for Linux.  Notice that everything is
        # replicated for all possible values of the modifiers shiftl, shiftr
        # and ctrll (shiftl and shiftr are used for groups 1..4 of XKB and
        # ctrll is used to fix the broken CapsLock when Linux console is in
        # Unicode mode).

        # alt keycode 36 = Incr_Console
        # shiftl alt keycode 36 = Incr_Console
        # shiftr alt keycode 36 = Incr_Console
        # shiftr shiftl alt keycode 36 = Incr_Console
        # ctrll alt keycode 36 = Incr_Console
        # ctrll shiftl alt keycode 36 = Incr_Console
        # ctrll shiftr alt keycode 36 = Incr_Console
        # ctrll shiftr shiftl alt keycode 36 = Incr_Console
        #
        # alt keycode 37 = Decr_Console
        # shiftl alt keycode 37 = Decr_Console
        # shiftr alt keycode 37 = Decr_Console
        # shiftr shiftl alt keycode 37 = Decr_Console
        # ctrll alt keycode 37 = Decr_Console
        # ctrll shiftl alt keycode 37 = Decr_Console
        # ctrll shiftr alt keycode 37 = Decr_Console
        # ctrll shiftr shiftl alt keycode 37 = Decr_Console

        {% if compose_key == 'prsc' -%}
        # Map Print Screen key to Compose on the console.
        keycode 99 = Compose
        shiftl alt keycode 99 = Compose
        shiftr alt keycode 99 = Compose
        shiftr shiftl alt keycode 99 = Compose
        ctrll alt keycode 99 = Compose
        ctrll shiftl alt keycode 99 = Compose
        ctrll shiftr alt keycode 99 = Compose
        ctrll shiftr shiftl alt keycode 99 = Compose
        {% endif -%}
