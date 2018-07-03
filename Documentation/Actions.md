# Actions

Once you have an action created in the [Orchextra dashboard](https://dashboard.orchextra.io) you have to handle it (in some cases) in the integrating app. 

## Custom schemes

You have to conform the **ORXDelegate** in order to can manage the custom schemes in your integrating app. All actions triggered by a custom scheme action will call the following method:

```
/// Use this method to execute a custom action associated to a scheme. 
/// - parameter scheme: The scheme to be executed.
func customScheme(_ scheme: String) {
	// Handle here the `scheme`
}
```

## Triggers

If any action did perform a trigger action, there is an **ORXDelegate** method to inform the integrating app that this happend.

```
/// Use this method to inform the integrative app about all trigger that have been fired.
/// - parameter trigger: Trigger fired by the system.
func triggerFired(_ trigger: Trigger) {
}
```

## Notifications

Orchextra provides a mechanism for sending notifications and handling its. First of all, we have to register for remote notifications in our **AppDelegate** by calling: 

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
	if #available(iOS 10.0, *) {
		// For iOS 10 display notification (sent via APNS)
		UNUserNotificationCenter.current().delegate = self
		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(
	   		options: authOptions,
	   		completionHandler: { _, _ in }
		)
	} else {
		let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
		application.registerUserNotificationSettings(settings)
	}
	application.registerForRemoteNotifications()
	return true
}

func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
	Orchextra.shared.registerForRemoteNotifications(with: deviceToken)
}
```

Secondly, we have to handle the notifications sent by Orchextra dashboard (or triggered by other action like a *beacon*):

```swift
extension AppDelegate {

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        Orchextra.shared.handleRemoteNotification(userInfo)
    }
    
	func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
		if let userInfo = notification.userInfo {
	    	Orchextra.shared.handleRemoteNotification(userInfo)
	   }
	}
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        Orchextra.shared.handleRemoteNotification(userInfo: userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        Orchextra.shared.handleLocalNotification(userInfo: userInfo)
        completionHandler()
    }
}
```