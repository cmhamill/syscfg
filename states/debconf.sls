{% set debconf = salt['pillar.get']('debconf') %}

debconf-priority:
  debconf.set:
    - name: debconf
    - data:
        debconf/priority: { type: select, value: {{ debconf.priority }} }
        debconf/frontend: { type: select, value: {{ debconf.frontend }} }
