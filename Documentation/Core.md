# Core

Here we are going to explain all features of the **Orchextra Core** module.

## Authentication

You can retrieve the access token of Orchextra in order to use it as your own authentication method.

```swift
Orchextra.shared.accesstoken()
```

## Modules configuration

TBD

## Bind/Unbind user

**UserOrx** class is a local representation of a user persisted to the Orchextra Database to help to create a good user segmentation. This object is optional and could be set up at any time by calling:

```swift
Orchextra.shared.bindUser(...)
```
You can retrieve the latest user stored:

```swift
Orchextra.shared.currentUser()
```

Finally, if you want to delete the user information:

```swift
Orchextra.shared.unbindUser()
```

## Bind device

TBD

## Anonymize (GDPR)

As you may have heard, the General Data Protection Regulation (GDPR) went into effect on May 25th, 2018. Orchextra SDK provides a method for anonymizing devices into Orchextra dashboard in order to be comply with GDPR if user want to be opt-out.

```swift
Orchextra.shared.anonymize(enabled: true)
```

## Segmentation

Orchextra SDK allows to create segmentation using tags, business units or custom fields. Some of those allow the possibility of assinging it to **User** or **Device**. This means that, if you assign a *BU* (Business Unit) to *User*, if you bind the same user in other device, you will obtain the BUs assigned to that user. In the other hand, assinging it to device just add it to the current active device.

### Business units

#### Available

* User
* Device

#### Usage

**Businees Unit** is an entity that represents... (TBD)

```swift
let itBusinessUnit = BusinessUnit(name: "it")
Orchextra.shared.setUserBusinessUnits([itBusinessUnit]) // Set to user
Orchextra.shared.setDeviceBusinessUnits([itBusinessUnit]) // Set to device
``` 

### Tags

**Tag** is an entity that represents... (TBD)

#### Available

* User
* Device

#### Usage

```swift
let manTag = Tag(prefix: "MAN")
Orchextra.shared.setUserTags([manTag])
Orchextra.shared.setDeviceTags([manTag])
```

### Custom fields

**CustomField** is an entity that represents... (TBD)

#### Available

* Device

#### Usage

```swift
let areNotificationsEnabledCustomField = CustomField(
	key: "notificationsEnabled", 
	label: "Notifications enabled", 
	type: .boolean, 
	value: "false"
)
Orchextra.shared.setCustomFields([areNotificationsEnabledCustomField])
```

## SendORXRequest

You can prepare a custom **Request** and let Orchextra to handle it. This is a way of including authentication headers without doing yourself. If the token expired, Orchextra will manage it and will renew in order to prevent errors. An example of usage could be:

```swift
let request = Request(
	method: "GET",
	baseUrl: "https://yourhost.com",
	endpoint: "users"
)
Orchextra.shared.sendOrxRequest(request: request) { response in 
	// handle response
}
```