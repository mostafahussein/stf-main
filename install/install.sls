{% from "exim_formula/exim.jinja" import exim with context %}

#Ensure removing old pkgs + old configs.
pkgs_removal:
  pkg.purged:
    - name: old_packages_removal
    - pkgs:
      - {{ exim.server }}
      - postfix
      - sendmail
      - exim4-config
      - exim4-base
      - exim4-daemon-heavy

#Install pkg.
exim_installation:
  pkg.installed:
    - name: {{ exim.server }}
    - watch_in:
      - service: exim_service
