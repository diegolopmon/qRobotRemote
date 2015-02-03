# qRobotRemote
Qt Quick application for controlling a remote robot via Bluetooth via on screen joystick.

## Protocol

The communication over RFCOMM with a paired device:

```
[Direction] + [Power]
```

### Direction values

 * **U** Up
 * **D** Down
 * **L** Left
 * **R** Right
 * **S** Stop

### Power

Range [1-100]

0 to stop

## Build

### Linux

**Requires:**

* git
* Qt 5.4
* build-essential

```
git clone https://github.com/diegolopmon/qRobotRemote.git
cd qRobotRemote
qmake qRobotRemote.pro
make
```

## Run

### Linux

**Requires:**

 * BlueZ

```
./qRobotRemote
```

*Copyright (C) 2015 Diego López*
