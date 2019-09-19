#!/bin/bash
echo "1. 导入密钥root"
expect -c "
set timeout 1
spawn ~/qoscli keys import root
send \"WbHRr4KFcvjSyCDvwj37D0Qgr6BhDgG1loWpjFhY2qBiqdH3pxKQNHgfFv8OTgqklUDl9BGmvMU1F34QSxqM+A==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "2. 导入密钥qcp"
expect -c "
set timeout 1
spawn ~/qoscli keys import qcp
send \"eRwYKN/jB1AtVAXmFJxGQcnQ1UqMWH5kcQSsPf/IgW0htIzJreJHbMfXBbnC0duZam7FEsgHvCcU0AMLgf8+zA==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "3. 导入密钥qsc"
expect -c "
set timeout 1
spawn ~/qoscli keys import qsc
send \"4w+iAp5ioyXQwd+P927sEmmSwM4FytLQOJPYo9JpdD+X54y3w+fDZihi9BceFHXazRZD8GtQFvFkqv8inVterw==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
echo "4. 导入密钥banker"
expect -c "
set timeout 1
spawn ~/qoscli keys import banker
send \"ZO0OMPF4OSy0N5AWQ3rFqftmAT3IM7d7OLgef+VatLbxrieUCO7SOOQfCIisBOItTql6iTmeeF3voMhq5PJsHw==\r\"
expect \"*key:\" {send \"12345678\r\"}
expect \"*passphrase:\" {send \"12345678\r\"}
interact
"
