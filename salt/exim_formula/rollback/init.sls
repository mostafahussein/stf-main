{% from 'exim_formula/exim.jinja' import formula_name, backup_file with context %}
{% from 'includes/lib.sls' import rollback with context %}

# by default this rollback line will restore the latest backup
# available unless you changed the value of backup_file inside the
# jinja file
{{ rollback(formula_name,backup_file) }}

{% include 'exim_formula/rollback/custom.sls' %}
