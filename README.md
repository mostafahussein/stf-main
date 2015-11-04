### SaltStack Formula's Template

This is a custom template for saltstack formulas which could be use in order to write your formula with the correct directory structure

---

#### Formula Hierarchy
```
formula_name
  |
  |
  ---- install
  |       |
  |       ----- backup.sls
  |       |
  |       ----- init.sls
  |       |
  |       ----- resources
  |       |
  |       ----- other sls files
  |
  |
  ---- formula_name.jinja
  |
  |
  ---- rollback
  |        |
  |        ----- init.sls
  |        |
  |        ----- custom.sls
  |
  ---- README.md
```
---
#### Contents of formula-template

- install (a folder contains all the necessary files that will be used to install the formula )
- rollback (a folder contains all the necessary files that will be used to revert back to a disered state)
- formula_name.jinja (Jinja file acts as a map for the formula)
- README.md (this read me file)

---
#### Technical Details
Lets start by explaining the contents which inside "formula_name" folder

#### 1- The "install" folder:
This folder will contain all the necessary files that will be used to install the formula. and we are going to explain the need of each file that you will find it when you browse/clone the formula_name template

  - **`backup.sls`**:

    ```Jinja
    {% from 'includes/lib.sls' import backup with context %}
    {% from 'myforumla_formula/formula_name.jinja' import other_files, default_files, formula_name with context %}

    {{ backup(formula_name,default_files,other_files) }}
    ```
    - The first line in `backup.sls` will be used to import a macro called `backup` from [`lib.sls`](http://git.serversadmins.com/devops/salt-formulas/blob/master/includes/lib.sls) which is under includes folder at salt base directory `e.g. /srv/salt`
    - The second line will import variables from `formula_name.jinja` which is under formula_name directory at salt base.
    - The third line the usage of the macro itself.
      - The `backup` macro takes three variables:
        - `formula_name`: this should be the name of the formula you are going to write
        - `other_files`: this parameter should contains the path of all files/dirs that you are not sure it will be exist on the targeted system or not
        - `default_files`: this parameter should contains the path of all files/dirs that you already know that they are will be exist in every distribution, by default you will find the value of `default_files` is an empty list

  - **`init.sls`**:

    ```Jinja
    {% from 'myformula_formula/formula_name.jinja' import formula_name with context %}

    {% if salt.exception.status(formula_name) != 'disabled' %}

    {% include 'myformula_formula/install/backup.sls' %}

    # states goes here...

    {% endif %}
    ```
    - The first line will import variables from the jinja file
    - The second line is an `if statement` that must be added to every formula. this `if statement` will handle the exception case where you want to run a formula on a your minion just one time
    - The third line will include the `backup.sls` so that we can backup the files that will be modified before the actual modification happens.
    - after the include backup line you can add the rest of your init steps but make sure that all the steps still inside the exception if statement.

  - **resources**:
    This folder should contains all the files that will be used in the formula `e.g. foo.conf, bar.ini`

  - Any other SLS file that will be used in the installation process should be add under install folder then include it inside the init.sls file inside the exception if statement

---

#### 2- The "rollback" folder:
This folder will contain all the necessary files that will be used to revert back after installing the formula.

  - **`init.sls`**:
    ```Jinja
    {% from 'myformula_formula/formula_name.jinja' import formula_name, backup_file with context %}
    {% from 'includes/lib.sls' import rollback with context %}

    {{ rollback(formula_name,backup_file) }}

    {% include 'path/to/formula_name/rollback/custom.sls' %}
    ```
    - The first line will import variables from the jinja file
    - The second line in `init.sls` will be used to import a macro called `rollback` from [`lib.sls`](http://git.serversadmins.com/devops/salt-formulas/blob/master/includes/lib.sls) which is under includes folder at salt base directory `e.g. /srv/salt`
    - The third line the usage of the macro itself.
      - The `rollback` macro takes two variables:
        - `formula_name`: this should be the name of the formula you are going to write
        - `backup_file`: this parameter represents which file you want to revert back to it. by default its value is empty string and in this case it will look for the latest backup available and restore it. in case you want to revert back to a specific backup then you can alter the value of `backup_file` inside the jinja file
    - The fourth line is including an SLS file called **`custom.sls`**, you will need this file for adding custom states. for example you have restored nginx to the previous state then you need to restart the nginx service after restoring the backup. so you will need to `service.running` inside custom.sls and make it restart the nginx service

---

#### 3- The "formula_name.jinja" file:
  This is a common file between install and rollback processes. you can set all the needed variables inside that file then import the variable to your SLS file. It comes with basic variables that needs to be exist in every salt formula.

  ```Jinja
  {% set formula_name = 'formula_name' %}
  {% set default_files = [] %}
  {% set other_files = [] %}
  {% set backup_file = '' %}
  ```
  - The first variable is `formula_name`: you will need to modify its value according to the formula that you are writing
  - The second variable is `default_files`: its value should be the path of all files/dirs that you already know that they are will be exist in every distribution as a list, by default you will find the value of default_files is an empty list. this variable will be used in [here](http://git.serversadmins.com/devops/salt-formulas/tree/master/myformula_formula#1-the-install-folder)
  - The third variable is `other_files`: its value should be the path of all files/dirs that you are not sure it will be exist on the targeted system or not as a list. this variable will be used in [here](http://git.serversadmins.com/devops/salt-formulas/tree/master/myformula_formula#1-the-install-folder)
  - The fourth variable is `backup_file`: its value represents which file you want to revert back to it. by default its value is empty string and in this case it will look for the latest backup available and restore it. in case you want to revert back to a specific backup then you can alter the value of backup_file inside the jinja file, this variable will be used in [here](http://git.serversadmins.com/devops/salt-formulas/tree/master/myformula_formula#2-the-rollback-folder)

---

#### 4- The "README.md" file:
  Where you should write a documentation for the formula, you can find the documentation template inside this skeleton formula named as `docs.md` modify it with suits your formula then type `mv docs.md README.md` to overwrite the default README.md file. it consists of three main parts:
  1- First part is for adding an overview of the formula
  2- Second part is for adding a list of all the available states and then a description for each one so we can know what each state will do
  3- Thrid part is for adding a list of formula dependencies if available.
