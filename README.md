# Orchextra SDK for iOS
![Language](https://img.shields.io/badge/Language-Swift-orange.svg)
![Version](https://img.shields.io/badge/version-3.0.1-blue.svg)
[![Build Status](https://travis-ci.org/Orchextra/orchextra-ios-sdk.svg?branch=master)](https://travis-ci.org/Orchextra/orchextra-ios-sdk)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov.io](https://codecov.io/github/Orchextra/orchextra-ios-sdk/coverage.svg?branch=develop)](https://codecov.io/github/Orchextra/orchextra-ios-sdk?branch=master)

A library that gives you access to Orchextra platform from your iOS app.

## Getting started
Start by creating a project in [Orchextra dashboard][dashboard], if you haven't done it yet. Go to "Setting" > "SDK Configuration" to get the **api key** and **api secret**, you will need these values to start Orchextra SDK.

## Overview
Orchextra SDK is composed by the sections of functionality.
#### **[Start / Stop](Documentation/Start_Stop.md)**
- Start
- Stop
  
#### **[Orchextra Core](Documentation/Core.md)**
- Authentication
- Modules configuration
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
