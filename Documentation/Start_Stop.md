# Start / Stop

## Integration
Once the project has been created in [Orchextra dashboard][dashboard],
it is required to **start** the SDK using the project credentials (**Api Key** and **Api Secret**)

### Start

To do this is necessary to add start code to your application AppDelegate

```swift
Orchextra.shared.start(with: Constants.apiKey, secret: Constants.apiSecret, completion: { result in
                switch result {
                case .success:
                // Implement Success case
                case .error:
                // Implement Error case
                }
            })
```
In the start method is included a completion block to manage success and error cases after the action is finished.

### Stop
The SDK provides a method to stop de Orchextra services. Performing this action, the triggering would be deactivated and it would be necessary to perform start to receive them again. 

```swift
Orchextra.shared.stop()
```

[dashboard]: https://dashboard.orchextra.io
 