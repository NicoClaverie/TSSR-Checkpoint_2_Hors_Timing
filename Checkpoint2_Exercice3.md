## Q.3.1 

C'est un switch, il permet de faire communiquer les ordinateurs dans le sous-réseaux `10.10.0.0/16`.  
Donc les PC1, PC3, PC4 et PC 5. Le PC2 n'est pas dans le même sous-réseau

## Q.3.2 

C'est un routeur il sert a faire communiquer le réseau `10.10.0.0/16` avec le réseau `10.12.2.0/24`

## Q.3.3

`f0/0` est le port FastEthernet sur le slot 0 port 0 et `g1/0` est le port GigaEthernet sur le slot 1 et le port 0

## Q.3.4 

Le `/16` du PC2 est le `CIDR` c'est a dire qu'il defini combien de bit sont masqué pour l'adressage IP. En l'occurence pour un `/16` c'est les 16 premiers bit qui sont cachés donc les deux premiers octets, exemple por une adresse `10.10.0.0/16` on peux aller de `10.10.0.0` a `10.10.255.255` les deux premiers octet restent les même, seul les deux derniers changent  

## Q.3.5

L'adresse `10.10.255.254` represente la derniere IP adressable sur le sous-réseau `10.10.0.0/16`, c'est également l'IP de passerelle pour joindre le routeur qui permet de sortir du réseau.

## Q.3.6

| Ordinateur | Adresse de réseau | Première adresse disponible | Dernière adresse disponible | Adresse de diffusion |
| :-: | :-: | :-: | :-: | :-: |
| PC1 | 10.10.0.0 | 10.10.0.1 | 10.10.255.254 | 10.10.255.255 |
| PC2 | 10.11.0.0 | 10.11.0.1 | 10.11.255.254 | 10.11.255.255 |
| PC5 | 10.10.0.0 | 10.10.0.1 | 10.11.255.254 | 10.11.255.255 |
 
## Q.3.7

Les ordinateurs `PC1`, `PC3` et `PC4` cont pouvoir comminuquer entre eux sans problemes, l'ordinateurs `PC5` va pouvoir communiquer avec les trois premiers car son CIDR en `/15` permet de les voir et son adresse en `10.10.4.7` permet de communiquer avec.  
Pour le `PC2` c'est plus compliqué, son CIDR en `/16` le place dans un autre sous-réseau que les `PC 1 3 4` donc il ne pourra pas communiquer avec eux, le CIDR du `PC5` permet de voir le `PC2` mais le `PC2` ne peux pas communiquer avec les `PC5` car de son point de vue il n'est pas sur le même sous-réseau.

## Q.3.8

Les PC qui peuvent atteindre le réseau `172.16.5.0/24` sont ceux qui peuvent joindre la passerelle `10.10.255.254/16` donc les `PC1`, `PC3`, `PC4` et `PC5`
 
## Q.3.9

A priori aucune incidence, la switch ajustera ses informations de redirection d'adresse IP en mettant a jour sa table MAC/IP

## Q.3.10

Pour une configuration IP des ordinateurs en dynamique, il faut mettre tout les PC en ip dynamique et parametrer le `DHCP` comme suis, 

| Ip réseau | Première adresse disponible | Dernière adresse disponible | Masque | Passerelle |
| :-: | :-: | :-: | :-: | :-: |
| 10.10.0.0 | 10.10.0.1 | 10.10.255.250 | 255.255.0.0 | 10.10.255.254 |






