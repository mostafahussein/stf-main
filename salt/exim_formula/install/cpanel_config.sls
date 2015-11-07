#Configure and tweak exim cpanel config server.
Exim_System_Filter_File:
  file.managed:
    - name: /etc/cpanel_exim_system_filter
    - source: salt://exim_formula/resources/cpanel_configs/cpanel_exim_system_filter
    - watch_in:
      - cmd: rebuild_exim_conf

#Send main config file for cpanel.
main_conf_file_cpanel:
  file.managed:
    - name: {{ exim.configfile }}
    - source: salt://exim_formula/install/resources/cpanel_configs/exim.conf

rebuild_exim_conf:
  cmd.run:
    - name: /scripts/buildeximconf

restart_exim_cpanel:
  cmd.run:
    - name: /scripts/restartsrv_exim
    - watch:
      - cmd: rebuild_exim_conf

#Cpanel set max mails per hour.
cpanel_maxmails:
  file.replace:
    - name: /var/cpanel/cpanel.config
    - pattern: '^maxemailsperhour.*'
    - repl: 'maxemailsperhour=200'

#Cpanel activate spamassassin.
activate_spamassassin:
  file.replace:
    - name: /var/cpanel/cpanel.config
    - pattern: '^skipspamassassin.*'
    - repl: 'skipspamassassin=0'

#Cpanel update tweaked settings.
update_tweaks:
  cmd.run:
    - name: /usr/local/cpanel/whostmgr/bin/whostmgr2 --updatetweaksettings

#Enable SMTP restrictions.
smtp_restrict:
  cmd.run:
    - name: /scripts/smtpmailgidonly on
