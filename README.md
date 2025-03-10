# piix_mobile

>A full demo of a sign in and sign up process containing Firebase Functions and Flutter code.

Flutter 3.19.2
Node 21.6.2
Npm 10.4.0
Firebase 13.5.1

## Installation 
OSX, Linux, Windows
```
Flutter pub get
```

## How to run demo

Run build runner for flutter to check that everything is working as expected. If you have FVM installed and are using VSCode you can instead run the VSCode task.

### Run Dart
___
#### CMD Line ####
```
dart run build_runner watch --delete-conflicting-outputs
```
#### VSCode Task #### 
Flutter fvm build:watch

### Run Firebase Functions Local api calls
___
#### CMD Line ####
```
cd functions && npm run build:watch
```
#### VSCode Task #### 
FUnctions tsc build:watch

#### Run Firebase Emulator
___
#### CMD Line ####
```
cd functions && firebase emualators:start --import=../seed_export --export-on-exit=../seed_export
```
#### VSCode Task #### 
Firebase import and export emulator
## Release history

* 1.4.2
    * CHANGE: Updated functions configurations so it can be uploaded to the Firebase cloud servers

## Meta
Raul Alonzo - [@linkedin](https://linkedin.com/in/raull-alonzo-mendoza) - ram2489@gmail.com

## Troubleshooting ##
When trying to deploy functions to Firebase cloud environment consider the eslint rules that can be found in ```functions/.eslintrc.js``` if errors occur.

If you cannot run the Flutter App check that you are running at least Flutter 3.19.2 and run
 ```
Flutter Doctor
```
to see that everything is correct, you may need to update cocoa pods or or android version when running on mobile.

If you cannot call any requests from web consider CORS issues even when running locally.

## &copy; Copyrights
***Piix and all its logos are the property of Piix LLC.***

