#Arquivo de comandos utilizados no GNS3

#Terminal do EtherSwitch
	
	vlan database #acessa base de VLANs

	#adiciona VLANs a base de VLANs do EtherSwitch
		vlan 25 name VLAN25
		vlan 35 name VLAN35
	
	exit #sai da base de VLANs
	wr #salva configuracoes
	
	configure terminal #acessa terminal de configuracoes
	
	#Define interfaces para VLAN 25
		interface range FastEthernet 1/1 - 7 #acessa o range de interfaces do 1/1 ao 1/7
		switchport mode access #define a porta como uma porta de acesso para as VLANs
		switchport access vlan 25 #define a porta como uma porta de acesso para VLAN 25
		no shutdown #faz com que as interfaces nao desliguem
	
	
	#Define interfaces para VLAN 35
		interface range FastEthernet 1/8 - 15 #acessa o range de interfaces do 1/1 ao 1/15
		switchport mode access #define a porta como uma porta de acesso para as VLANs
		switchport access vlan 35 #define a porta como uma porta de acesso para VLAN 35
		no shutdown #faz com que as interfaces nao desliguem
		
	exit #sai das configuracoes
	wr #salva configuracoes
