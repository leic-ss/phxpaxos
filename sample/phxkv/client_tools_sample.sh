./sample/phxkv_client 127.0.0.1:21112 put key_hello value_paxos1 0
./sample/phxkv_client 127.0.0.1:21112 getlocal key_hello
./sample/phxkv_client 127.0.0.1:21112 getglobal key_hello
./sample/phxkv_client 127.0.0.1:21112 delete key_hello 0

./sample/phxkv_client 127.0.0.1:21111 put key_hello value_paxos2 0
./sample/phxkv_client 127.0.0.1:21111 getlocal key_hello
./sample/phxkv_client 127.0.0.1:21111 getglobal key_hello
./sample/phxkv_client 127.0.0.1:21111 delete key_hello 0

./sample/phxkv_client 127.0.0.1:21113 put key_hello value_paxos3 0
./sample/phxkv_client 127.0.0.1:21113 getlocal key_hello
./sample/phxkv_client 127.0.0.1:21113 getglobal key_hello
./sample/phxkv_client 127.0.0.1:21113 delete key_hello 0
