{% from "exim_formula/exim.jinja" import exim with context %}

#Send main config file.
main_conf_file:
  file.managed:
    - name: {{ exim.configfile }}
    - source: salt://exim_formula/install/resources/exim.conf
    - show_diff: False
    - watch_in:
      - service: exim_service

#Send Exim config templates.
config_templates:
  file.managed:
    - name: {{ exim.templates }}
    - source: {{ exim.template_source }}
    - watch_in:
      - service: exim_service
