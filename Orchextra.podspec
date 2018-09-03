#
# Be sure to run `pod lib lint Orchextra.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Orchextra'
  s.version          = '3.0.5'
  s.summary          = 'A library that gives you access to Orchextra platform from your iOS app.'
  s.swift_version    = '4.1.0'

  s.description      = <<-DESC
Orchextra SDK is composed by the sections of functionality.

# Start / Stop

* Start
* Stop
* Orchextra Core

# Authentication

* Bind/Unbind user
* Bind device
* 	Anonimize (GDPR)
* Business units
* Tags
* Custom fields
* SendORXRequest

# Triggering

* Scanner
* 	Custom
* 	ORXScanner
* Proximity
* Eddystone

# Actions

* Custom Schemes
* Triggers
* Push Notifications
* Register / unregister
* Handle notifications
* Local
* Remote
                       DESC

  s.homepage         = 'https://github.com/Orchextra/orchextra-ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jcarlosestela' => 'jose.estela@gigigo.com' }
  s.source           = { :git => 'https://github.com/Orchextra/orchextra-ios-sdk.git', :tag => 'v' + s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Orchextra/**/*.swift'
  
  s.resource_bundles = {
    'Orchextra' => ['Orchextra/**/*.xcassets']
  }

  s.dependency 'GIGLibrary', '~> 3.0'
  s.dependency 'CryptoSwift', '~> 0.9'
end
