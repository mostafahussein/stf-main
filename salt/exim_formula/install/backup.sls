{% from 'includes/lib.sls' import backup with context %}
{% from 'exim_formula/exim.jinja' import other_files, default_files, formula_name with context %}

# this line will pass a three parameters to backup macro in oder to
# create a backup of all files and directories that could be modified
# during the installation process
{{ backup(formula_name,default_files,other_files) }}
