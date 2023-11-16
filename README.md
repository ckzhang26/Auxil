# Workspace Installation
### 1: Required Installations

- [Flutter Installation guide](https://docs.flutter.dev/get-started/install)
- [Android Studio Installation guide](https://docs.flutter.dev/get-started/install/windows#android-setup)
- [Visual Studio Code (VS Code)](https://code.visualstudio.com/)

Once these requirements are met, run Flutter's "Doctor Tool" in a terminal to guarantee a successful install:
> C:\ShelterNet\src\net> flutter doctor 

If done correctly, the only necessary green check marks should be **Flutter, Windows Version, Android Toolchain, Android Studio**, and **VS Code**
![](https://i.gyazo.com/7646e375daec7aa65856b434b62ba76b.png)

### 2: Visual Studio Code Extensions
To install the extensions either follow the links bellow, or search for the names in Visual Studio Code's extension tab.
- [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)

### 3: Opening the project
_Assuming that this repository has already been cloned..._

Use Visual Studio Code to open the main project folder,, defaulted to "net". After that open a terminal for that folder, either by VS Code or command prompt, and running the command below to resolve issues regarding extra dependencies.
> C:\ShelterNet\src\net> flutter pub get

From there most of the coding with be done in the "net\lib" directory.

### 4: Running / Testing
Within the [Android Studio Installation guide](https://docs.flutter.dev/get-started/install/windows#android-setup), a device should have been created during the [Andrioid Emulator](https://docs.flutter.dev/get-started/install/windows#set-up-the-android-emulator) section. This device must be running in order for Flutter to properly compile the app. Finally, testing and running the app is achieved with either the F5 key or option "Run -> Start Debugging" in VS Code.
