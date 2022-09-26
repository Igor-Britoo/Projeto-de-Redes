#Terminal do Roteador 1
	int f0/0				
	ip address 10.0.4.193 255.255.255.252
	ip nat inside
	no sh					

#Terminal do Roteador 2
	int f1/1				
	ip address 10.0.12.1 255.255.254.0
	ip nat inside
	no sh
	
	int f1/0				
	ip address 10.0.4.194 255.255.255.252
	ip nat outside
	no sh

#Terminal do Roteador 1
	router rip
	version 2
	network 10.0.4.192
	network 10.0.4.128
	network 10.0.4.0
	
#Terminal do Roteador 2
	ip route 0.0.0.0 0.0.0.0 10.0.4.193	
	router rip
	version 2
	network 10.0.4.192
	network 10.0.12.0


