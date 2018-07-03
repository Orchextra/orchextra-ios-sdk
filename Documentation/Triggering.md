# Triggering

Orchextra provides three categories of triggers that will be detailed below: 

- Scanner
- Proximity
- Eddystone

## Scanner

Orchextra provides a mechanism to scan QR and barcode whose result could have an associated action.

There are two posibilities to open a Scanner. Open the Orchextra own scanner o create one and set it up.

### Custom Scanner

To set a custom Scanner is required to call this method passing the view controller that is going to be used as scanner.

```swift
/**
     Method to set up a custom scanner with ModuleInput interface
     - vc: the scanner has to be a viewcontroller
     
     - Since: 3.0
     */
    public func setScanner<T: UIViewController>(vc: T) where T: ModuleInput {
        OrchextraController.shared.setScanner(vc: vc)
    }
```

That view controller must implement **Module Input** protocol.

```swift
public protocol ModuleInput {
    
    var outputModule: ModuleOutput? { get set }
    
    /// Start module
    func start()
    
    /// Finish module
    ///
    /// - Parameters:
    ///   - action: send action if ORX found it
    ///   - completionHandler: wait until module finish
    func finish(action: Action?, completionHandler: (() -> Void)?)
    
    /// Set Configuration for an specific module
    ///
    /// - Parameters:
    ///     - params: params 
    func setConfig(params: [String: Any])
}
```

Once the module is set up, to open that scanner you need to call this method

```swift
Orchextra.shared.openScanner()
```

### ORX Scanner
if there is no custom scanner set up, when **openScanner()** is called Orchextra will open the default scanner defined inside the framework.

```swift
Orchextra.shared.openScanner()
```

Orchextra provides a method to launch the scanner and return the value scanned in a completion block wihout validating it.

```swift
/**
     Open scanner from outside ORX and return scan result on completion handler.
     
     - parameter completion: Completion handler for scan result, will return a `ScannerResult` with the code ans it's
     type in case of success, or an `Error` otherwise.
     
     - Since: 3.0
     */
    public func scan(completion: @escaping (Result<ScannerResult, ScannerError>) -> Void)
```

## Proximity

To integrate the proximity module to use iBeacons and geofence as triggers is required to activate it by calling:  

```swift
Orchextra.shared.enableProximity(enable: true)
```
If this method is not called by dafault will be **false** and the module would be deactivated.


## Eddystone

To integrate the eddystone module to use Eddystone beacons as triggers is required to activate it by calling: 

```swift
self.orchextra.enableEddystones(enable: true)
```
If this method is not called by dafault will be **false** and the module would be deactivated.

This module has an extra feature to detect Eddystone beacos when the application is in background. To detect this kind of devices is necessary to use **CoreBluetooth**. This framework consumes many resources and could be experimented battery leaks if Orchextra is looking continously for bluetooth devices.

To improve that it has been added a mechanism to perform start and stop scanner periodically and not having the scanner always active. When the application is in background the operating system could kill the task to liberate resources. To launch again the scanner Orchextra provides a method to start again the scanner:

```swift
  // MARK: Public fetch new eddystone information
    public func openEddystone(with completionHandler: (UIBackgroundFetchResult) -> Void) 
```
This method must be called from **AppDelegate**: 

```swift
 func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Orchextra.shared.openEddystone(with: completionHandler)
    }
```
This **AppDelegate** method is called by the Operative System.

