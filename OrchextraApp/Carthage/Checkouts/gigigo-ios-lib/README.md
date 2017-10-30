# GIGLibrary iOS

----

[![Build Status](https://travis-ci.org/gigigoapps/gigigo-ios-lib.svg?branch=master)](https://travis-ci.org/gigigoapps/gigigo-ios-lib)
![Language](https://img.shields.io/badge/Language-Objective--C-orange.svg)
![Language](https://img.shields.io/badge/Language-Swift-orange.svg)
![Version](https://img.shields.io/badge/version-3.0.2-blue.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


Main library for Gigigo iOS projects.


## How to add it to my project

Through Carthage

```
github "gigigoapps/gigigo-ios-lib" ~> 3.0
```


## What is included

- Core:
	- GIGNetwork: classes to manage network requests.
	- SwiftNetwork: Swift classes to manage gigigo's requestst. Standard Gigigo JSON is parsed by default.
	- GIGLayout: some functions to help with autolayout.
	- GIGUtils: a lot of extensions on foundation classes.
	- GIGScanner: QR scanner using native iOS API
	- GIGLocation: Wrapper on CLLocation API
	- SlideMenu: A basic lateral slide menu
	- ProgressPageControl: A page control with a progress bar in the selected page.
