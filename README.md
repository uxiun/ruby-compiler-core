# compile/run cmm
```sh
ruby Parser.rb < target.cmm > target.j # compile cmm to jasmin
java -jar jasmin-2.4/jasmin.jar target.j # run
java cmm
```
