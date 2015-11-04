{% from 'exim_formula/exim.jinja' import formula_name with context %}

{% if salt.exception.status(formula_name) != 'disabled' and grains. cpanel != 'plesk' %}

{% include 'exim_formula/install/backup.sls' %}

{% from "exim_formula/exim.jinja" import exim with context %}

#Package Installation state.
{% include 'exim_formula/install/install.sls' if grains.cpanel == None else '' ignore missing %}
#Configuration Tweaks state.
{% include 'exim_dev_formula/install/config.sls' if grains.osfinger != 'CentOS-5' else '' ignore missing %}
#Configuration Tweaks for cpanel only.
{% include 'exim_formula/install/cpanel_config.sls' if grains.cpanel == 'whm' else '' ignore missing %}
#Check service status and Ensure service is running on startup.
exim_service:
  service.running:
    - name: {{ exim.service }}
    - enable: True
{% endif %}
