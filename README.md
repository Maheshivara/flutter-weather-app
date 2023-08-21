# Flutter Weather Preview App
A simple app to view weather preview using flutter and [wheather](weatherapi.com) API;

## How to Use
  - Configure the SDKs of [Flutter](https://docs.flutter.dev/get-started/install) and [Dart](https://dart.dev/get-dart);
  - Clone this repo in your desired folder;
  - Create a file named **secrets.dart** in the folder **projectFolder/lib/weather_api/**;
      - Inside of this file paste this code, editing the apiKey to your generated apiKey:
        ```dart
        class Secrets {
          final String apiKey = '${YOUR_API_KEY}';
        }
        ```
  - Run the command:
      ```fish
      flutter pub get
      ```
      to install the dependencies;
      - [Diacritic](https://pub.dev/packages/diacritic) to normalize the input string;
      - [HTTP](https://pub.dev/packages/http) to work with the requests;
- Run the App with a android emulator/phone or via linux, other target platforms require recreate the project
    - Ex: To add windows, in the main folder of the project run:
      ```fish
      flutter create --platforms=windows .
      ```
    - To run the app you can use the command:
      ```fish
      flutter run -d linux
      ```
      - Change the linux for the target platform
