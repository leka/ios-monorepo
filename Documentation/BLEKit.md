# BLEKit Overview

## BLESpecs

Struct classifying each of the services and their characteristics using `CBUUID` type.
The features and services can be invoked in all code importing the `BLEKit` module in the respective form of:

- `BLESpecs.<ServiceName>.Characteristic.<characteristicName>`
- `BLESpecs.<ServiceName>.service`

**For example:** the `level` feature of the `Battery` service.

```swift
public struct Battery {
     public static let service = CBUUID(string: "0x180F")

     public structCharacteristics {
         public static let level = CBUUID(string: "0x2A19")
     }
}
```

## AdvertisingData

Struct that initializes and formats the advertising data of the `peripheral` discovered by the `BLEManager`.
The advertising data supported by our `BLEKit`, and therefore displayable, are:

- `name`
- `battery` - `0 --> 100%`
- `isCharging` - `true` or `false`
- `osVersion` - `x.y.z`

The advertising data of a `peripheral` is obtained by instantiating an `AdvertisingData` with, as argument, the `advertisingData` of this peripheral: `AdvertisingData(peripheral.advertisementData)`.

## Functioning

### BLEManager

The BLEKit module was inspired by the **CombineCoreBluetooth** repo [[Link]](https://github.com/StarryInternet/CombineCoreBluetooth), using the **Combine** framework ([Documentation/Combine](https:// developer.apple.com/documentation/combine).

`BLEManager` is what is called the `central`.

`BLEManager` handles:

- **discovery** of `peripherals`: `searchForPeripheral()` to start the scan, `stopSearching()` to stop it. The `isScanning` member variable allows to know the current state of the `central` (`true` if scanning is activated)
- **connection** to one of them: `connect(peripheral:)` to connect to a particular `peripheral`. The `peripheral` in question can be found in the list of `peripherals` discovered by `BLEManager`
- **disconnection**: `disconnect()` disconnects the currently connected `peripheral`

### Combine

The **Combine** framework provides a Swift API for **processing values over time**. These values can represent many types of asynchronous events. **Combine** declares `Publishers` to publish values to change over time, and `Subscribers` to receive these values.
Many functions of **CombineCoreBluetooth** return publishers. To understand how to use them, let's detail an example of use made for the connection:

The `connect()` function, returning an `AnyPublisher<Peripheral, Error>`, which publishes a `Peripheral` to it on a successful connection and an error on a failed connection.

```swift
bleManager.connect(bleManager.peripherals[botVM.currentlySelectedBotIndex!])
     .receive(on: DispatchQueue.main)
     .sink(
         receiveCompletion: { _ in },
         receiveValue: { peripheral in
             let connectedRobotPeripheral = RobotPeripheral(peripheral: peripheral)
             robot.robotPeripheral = connectedRobotPeripheral
         })
     .store(in: &bleManager.cancellables)
```

`receive(on: DispatchQueue.main)` forces the publisher to publish to the `MainThread` (to be used by default when working on a publisher that will impact interfaces)

`sink( receiveCompletion: { _ in }, receiveValue: { _ in }` attaches a `Subscriber` to our `Publisher` created just above and will perform the action explained in the `receiveValue()` section when receipt of data from the `Publisher`.
Here, we instance a `RobotPeripheral` with the robot to which we have just connected, then we update the `robotPeripheral` of our `robot` object.

`store()` stores the output of `sink()` in a set of cancelables, destroyed when code execution stops.

### RobotPeripheral

`RobotPeripheral` is what is called the `peripheral`. Here, it is specific to a robot and is able to:

- the **discovery** `characteristics` and the **notification** of an update of their value: `discoverAndListenCharacteristics()` discovers the `characteristics` among the list of `notifyingCharacteristics` (details later) and notify when a value change on these `characteristics`.
- the **voluntary** reading** of `characteristics`: `readReadOnlyCharacteristics()` reads the value of the characteristic in question
- **sending command** on a `characteristics`: `sendCommand(data:)` writes the data on the **characteristic `DFB0` specifically**.

To go further: functions close to those of sendCommand could be created in order to ensure the writing on other `characteristics`.

### Robot class (upcoming evolution)

`Robot` is a class that allows communication between the `BLEKit` module and the **front**. This class has, as a member variable, the values associated with the characteristics of the robot, in a format that can be displayed by the UI. Robot does the following:

- **specify the formatting** for each value of the characteristics: `registerReadOnlyCharacteristicClosures()` and `registerNotifyingCharacteristicClosures()` gives the procedure for decoding the data read for each `characteristic`, respectively for those read voluntarily, and those notifying .
- **create a link with the RobotPeripheral**. Robot has as an optional member variable a RobotPeripheral, which when the latter is instantiated, we call the `updateDeviceInformation()` and `subscribeToDataUpdates()` functions which will respectively ensure the reading of the characteristics of the `DeviceInformation` service and the listening of ` characteristics that change over time such as battery level, charging status, or MagicCard information
- **run a reinforcer**: `runReinforcer(reinforcer:)`. More generally, for the sequel, any command found in the `Commands.swift*` file can be sent and played by adapting the new function to the specific command.
