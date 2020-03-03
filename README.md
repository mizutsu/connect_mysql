# connect_mysql
This is shell script to connect MySQL.

# requirement
python3

# how to use
```console
bash connect_mysql ${section_name}
```
Please set section name as argument.
If database config file is like this, and you want to connect "slave" plese set "slave" as argument.
```text
[master]
host = xxxx
database = xxxx
user = xxxx
password = xxxx
port = xxxx

[slave]
host = xxxx
database = xxxx
user = xxxx
password = xxxx
port = xxxx
```
sample
```console
bash connect_mysql slave
```