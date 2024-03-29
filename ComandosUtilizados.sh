#Arquivo de comandos utilizados no GNS3

	#Terminal do EtherSwitch
		
		vlan database 		#acessa base de VLANs

		#adiciona VLANs a base de VLANs do EtherSwitch
			vlan 25 name VLAN25
			vlan 35 name VLAN35
		
		exit 		#sai da base de VLANs
		wr 		#salva configuracoes
		
		configure terminal 			#acessa terminal de configuracoes
		
		#Define interfaces para VLAN 25
		
			interface range FastEthernet 1/1 - 7 		#acessa o range de interfaces do 1/1 ao 1/7
			switchport mode access 				#define a porta como uma porta de acesso para apenas uma VLAN
			switchport access vlan 25 			#define a porta como uma porta de acesso para VLAN 25
			no shutdown 					#faz com que as interfaces nao desliguem
			exit
		
		#Define interfaces para VLAN 35
		
			interface range FastEthernet 1/8 - 15 		#acessa o range de interfaces do 1/1 ao 1/7
			switchport mode access 				#define a porta como uma porta de acesso para apenas uma VLAN
			switchport access vlan 35 			#define a porta como uma porta de acesso para VLAN 35
			no shutdown 					#faz com que as interfaces nao desliguem
			exit
			
		#Define a interface f1/0 para permitir o trafego de pacotes das VLANs 25 e 35 ao mesmo tempo
		
			interface f1/0 							#acessa a interface f1/0
			switchport mode trunk 						#define a porta como uma porta de acesso para multiplas VLANs
			
			switchport trunk allowed vlan 25,35,1-2,1002-1005 		#permite o trafego de pacotes das VLANs 25, 35
											#e VLANs padroes da CISCO
			
			no shutdown							#faz com que a interface nao desligue
			exit

		exit 		#sai das configuracoes
		wr 		#salva configuracoes
	
	
	#Terminal do Roteador 1
		configure terminal 		#acessa terminal de configuracoes
		
		#Aloca os IPs da VLAN 25
		
			ip dhcp pool 25					#define uma pool de IPs para VLAN 25
			network 10.0.14.128 255.255.255.192 		#define o IP e a mascara de subrede
			default-router 10.0.14.129 			#define o gateway
			exit
			
		#Aloca os IPs da VLAN 35
		
			ip dhcp pool 35						#define uma pool de IPs para VLAN 25
			network 10.0.14.0 255.255.255.128 	 		#define o IP e a mascara de subrede
			default-router 10.0.14.1				#define o gateway
			exit
			
		#Define sub-interface para VLAN 25
		
			interface f1/1.25 					#acessa sub-interface referente a VLAN 25
			encapsulation dot1Q 25              			#define o protocolo 802.1Q para a sub-interface para diferenciar as vlans
			ip address 10.0.14.129 255.255.255.192  		#define o ip(gateway definido anteriormente) e mascara da sub-interface
			no shutdown						#faz com que a interface nao desligue
			exit
		
		#Define sub-interface para VLAN 35
		
			interface f1/1.35 					#acessa sub-interface referente a VLAN 25
			encapsulation dot1Q 35              			#define o protocolo 802.1Q para a sub-interface
			ip address 10.0.14.1 255.255.255.128  			#define o ip(gateway definido anteriormente) e mascara da sub-interface
			no shutdown						#faz com que a interface nao desligue
			exit
		
		#Configura a interface que engloba as sub-interfaces para não desligar
			interface f1/1			#acessa a interface f1/1
			no shutdown			#faz com que a interface nao desligue
			exit
		
		#Configuracao do NAT na interface f1/0
			int f1/0			#acessa a interface f1/0
			ip address dhcp			#configura o DHCP
			ip nat outside			#traduz endereços globais(outside) para endereços locais(inside)
			no shutdown			#faz com que a interface nao desligue
			exit
			
		#Configuracao do NAT na interface f1/1 e em suas sub interfaces
			int f1/1			#acessa a interface f1/1
			ip nat inside			#traduz endereços locais(inside) para endereços globais(outside)
			no sh				#faz com que a interface nao desligue
			exit

			int f1/1.25			#acessa a sub-interface f1/1.25
			ip nat inside			#traduz endereços locais(inside) para endereços globais(outside)
			no sh				#faz com que a sub-interface nao desligue
			exit

			int f1/1.35			#acessa a sub-interface f1/1.35
			ip nat inside			#traduz endereços locais(inside) para endereços globais(outside)
			no sh				#faz com que a sub-interface nao desligue
			exit

		#Configuracao da lista de acesso
			access-list 1 permit any					#configura uma lista de acesso com permissão de tráfego de pacotes de qualquer host
			ip nat inside source list 1 interface f1/0 overload		 

		exit
		wr
		
		
	#Terminal da VLAN 25
		ping 10.0.14.129			#ping para o gateway(mesma rede)
		ping 10.0.14.2				#ping para a VLAN 35 (rede diferente)
		ping 8.8.8.8				#ping para o google (acesso a internet)

		traceroute 10.0.14.129			#traceroute para o gateway(mesma rede)
		traceroute 10.0.14.2			#traceroute para a VLAN 35(rede diferente)
		traceroute 8.8.8.8			#traceroute para o google (acesso a internet)

	#Terminal da VLAN 35
		ping 10.0.14.1				#ping para o gateway(mesma rede)
		ping 10.0.14.130			#ping para a VLAN 25 (rede diferente)
		ping 8.8.8.8				#ping para o google (acesso a internet)

		traceroute 10.0.14.1			#traceroute para o gateway(mesma rede)
		traceroute 10.0.14.130			#traceroute para a VLAN 25(rede diferente)
		traceroute 8.8.8.8			#traceroute para o google (acesso a internet)

	#Terminal do Roteador 1
		show arp 				#mostra a tabela arp construída

