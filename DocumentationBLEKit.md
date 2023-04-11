# Overview BLEKit
## BLESpecs


Struct classifiant chacun des services et leurs caractéristiques sous le type **CBUUID**. 
Les caractéristiques et services sont invocables dans tous code important le module **BLEKit** sous la forme respective de : 

- `BLESpecs.<ServiceName>.Characteristic.<characteristicName>` 
- `BLESpecs.<ServiceName>.service` 

**Ex :** la caractéristique `level` du service `Battery`. 

    public struct Battery {
		public static let service = CBUUID(string: "0x180F")

		public struct Characteristics {
			public static let level = CBUUID(string: "0x2A19")
		}
	}
	
## AdvertisingData

Struct qui initialise et formate les advertising data des ***peripheral*** découverts par le **BLEManager**.
Les advertising data pris en charge par notre **BLEKit** et donc affichables sont: 

- `name `
- `battery` (pourcentage)
- `isCharging` (yes/no)
- `osVersion`

Les advertising data d’un ***peripheral*** s’obtiennent en instanciant un `AdvertisingData` avec, comme argument, l’advertisementData de ce peripheral : `AdvertisingData(peripheral.advertisementData)`.

## Fonctionnement
### BLEManager
Le module BLEKit a été inspiré par le repo **CombineCoreBluetooth** [[Lien]](https://github.com/StarryInternet/CombineCoreBluetooth), utilisant le framework **Combine**  [[Lien](https://developer.apple.com/documentation/combine)].
BLEManager est ce qu’on appelle le **central**.

Il s’occupe : 

- de la **découverte des** ***peripheral*** : **searchForPeripheral()** pour démarrer le scan, **stopSearching()** pour le stopper. La variable membre **isScanning** permet de connaître l’état actuel du ***central*** (true si le scan est activé)
- de la **connexion** à l’un d’eux : **connect(<peripheral>)** pour se connecter à ***peripheral*** en particulier. Le ***peripheral*** en question peut être trouvé dans la liste peripherals des ***peripheral***  découverts par le **bleManager**.
- de la **déconnexion** : **disconnect()** déconnecte le ***peripheral*** actuellement connecté.

### Zoom sur Combine
Le framework **Combine** fournit une API Swift pour le **traitement des valeurs dans le temps**. Ces valeurs peuvent représenter de nombreux types d'événements asynchrones. **Combine** déclare des **Publishers** pour publier des valeurs amener à changer dans le temps, et des **Subscribers** pour recevoir ces valeurs.
Nombreuses sont les fonctions de **CombineCoreBluetooth** retournant des publishers. Pour comprendre comment les utiliser, détaillons un exemple d’utilisation réalisé pour la connexion :

La fonction **connect**, retournant un **publisher** `AnyPublisher<Peripheral, Error>`, qui lui publie un Peripheral lors d’une connexion réussie et une erreur lors d'un échec de connexion.


    bleManager.connect(bleManager.peripherals[botVM.currentlySelectedBotIndex!])
						.receive(on: DispatchQueue.main)
						.sink(
							receiveCompletion: { _ in },
							receiveValue: { peripheral in
								let connectedRobotPeripheral = RobotPeripheral(peripheral: peripheral)
								robot.robotPeripheral = connectedRobotPeripheral
							}
						)
						.store(in: &bleManager.cancellables)

`.receive(on: DispatchQueue.main)` impose au publisher de publier sur le Main Thread (à utiliser par défaut lors d’un travail sur un publisher) 

`.sink( receiveCompletion: { _ in }, receiveValue: { _ in }` attache un **Subscriber** à notre **Publisher** créé juste au-dessus et performera l’action explicitée dans la section `receiveValue()` lors de la réception de la donnée du **Publisher**.
Ici, on instance un **RobotPeripheral** avec le robot auquel on vient de se connecter, puis on update le **robotPeripheral** de notre objet **robot**.

`.store()` stocke la sortie de` sink()` dans un ensemble de cancellables, détruit à l’arrêt de l'exécution du code.


### RobotPeripheral

**RobotPeripheral** est ce qu’on appelle le ***peripheral***. Ici, il est propre à un robot et est capable de  : 

- **la découverte des** ***characteristics***  **et la notification d'une mise à jour de leur valeur**: **discoverAndListenCharacteristics()** découvre les ***characteristics*** parmi la liste des **notifyingCharacteristics** (détails plus loin) et notifie lors d'un changement de valeur sur ces ***characteristics***.
- la **lecture spontanée** de ***characteristics*** : **readReadOnlyCharacteristics()** lit  la valeur de la caractéristique en question
- **l’envoi de commande** sur une ***characteristics*** : **sendCommand(<data>)** écrit la data sur la **caractéristique DFB0 spécifiquement**.
- Pour aller plus loin : des fonctions proches de celles de sendCommand pourraient être créées afin d’assurer l’écriture sur d’autres ***characteristics***.

### Classe Robot (évolution à venir)

**Robot** est une classe qui permet la communication entre le module **BLEKit** et le **front**. Cette classe possède, en variable membre, les valeurs associées aux caractéristiques du robot, sous un format affichable par l’UI. Robot s’occupe de : 

- de **spécifier le formatage** pour chaque valeur des characteristics: **registerReadOnlyCharacteristicClosures() & registerNotifyingCharacteristicClosures()** donne la démarche de décodage de la data lu pour chaque ***characteristic***, pour respectivement celles lues spontanément, et celle notifiantes.
- de la **liaison avec le RobotPeripheral**. Robot a comme variable membre optionnelle un RobotPeripheral, qui lorsque ce dernier est instancié, on appelle les fonctions **updateDeviceInformation() et subscribeToDataUpdates()** qui assureront respectivement la lecture des characteristics du service `DeviceInformation` et la mise en écoute des ***characteristics*** amenées à évoluer dans le temps telles que le niveau de batterie, le statut de charge, ou bien les informations de MagicCard
- de **lancer un renforçateur** : **runReinforcer(<reinforcer>)**. Plus généralement, pour la suite, n’importe quelle commande trouvable dans le fichier **Commands.swift** peut être envoyée et jouée en adaptant la nouvelle fonction à la commande spécifique.

