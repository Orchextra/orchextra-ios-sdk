# Orchextra SDK for iOS

![Language](https://img.shields.io/badge/Language-Swift-orange.svg)
![Version](https://img.shields.io/badge/version-4.0.2-blue.svg)
[![Build Status](https://travis-ci.org/Orchextra/orchextra-ios-sdk.svg?branch=master)](https://travis-ci.org/Orchextra/orchextra-ios-sdk)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![CocoaPods](https://img.shields.io/cocoapods/v/Orchextra.svg)
[![codecov.io](https://codecov.io/github/Orchextra/orchextra-ios-sdk/coverage.svg?branch=develop)](https://codecov.io/github/Orchextra/orchextra-ios-sdk?branch=master)

A library that gives you access to Orchextra platform from your iOS app.

## Getting started

Start by creating a project in [Orchextra Dashboard][dashboard], if you haven't done it yet. You'll need to get your project `APIKEY` and `APISECRET`  to configure and integrate OCM SDK, you can look them up in  [Orchextra dashboard][dashboard] by going to "Settings" -> "SDK Configuration".

### Requirements

* iOS 9.0+

### Swift & Xcode version support

| ORX Version | Swift Version | Xcode Version|
| :---: |:---:| :---:|
| **v3.x** | 3.x, 4.0, 4.1 | 9.x |
| **v4.x** | 4.2 | 10.x |
| **v5.x** | 5.0 | > 10.2.x |

## Installation

### Manually

To use *Orchextra Core*, head on over to the [releases](https://github.com/Orchextra/orchextra-ios-sdk/releases) page, and download the latest build "Orchextra.zip". Drag and drop **Orchextra.framework**. 

### Carthage

[Carthage](https://github.com/Carthage/Carthage/blob/master/README.md) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](https://brew.sh) using the following command:

```
$ brew update
$ brew install carthage
```

If you want you can add **Orchextra.framework** using Carthage, you have to add in your Cartfile file: 

 ```
github "Orchextra/orchextra-ios-sdk" ~> 3.0
 ``` 
 
Run `carthage update` to build the framework and drag the built Orchextra.framework into your Xcode project.
 
### Cocoapods (beta)

[Cocoapods](https://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects. It has over 51 thousand libraries and is used in over 3 million apps. CocoaPods can help you scale your projects elegantly.

Simply add to your `Podfile`the following line:

```
pod 'Orchextra', '~> 3.0'
```
 
## Set up

### Geolocation - Configure Info.plist
You have to provide (it is required) a description of "why the app wants to use location services" in the info.plist
by using the following keys and providing an string with the reason.

* NSLocationAlwaysUsageDescription
* NSLocationWhenInUseUsageDescription

## Overview

Orchextra SDK is composed by the sections of functionality.

#### **[Start / Stop](Documentation/Start_Stop.md)**
- Start
- Stop
  
#### **[Orchextra Core](Documentation/Core.md)**
- Authentication
- Bind/Unbind user
- Bind device
     * Anonimize (GDPR)
- Business units
- Tags
- Custom fields
- SendORXRequest

#### **[Triggering](Documentation/Triggering.md)**
- Scanner
  * Custom
  * ORXScanner
- Proximity
- Eddystone

#### **[Actions](Documentation/Actions.md)**
- Custom Schemes
- Triggers
- Push Notifications
	* Register / unregister
   * Handle notifications
       - Local
       - Remote


[dashboard]: https://dashboard.orchextra.io
