# Didomi Consent

### About
`DidomiConsent` is a SDK written in Swift, to show the user consent.

## Requirements

Swift `4.0`, `4.2` & `5.0`. Ready for use on iOS 9.0+

## Installation

### Manually

Build DidomiConsent proj and copy DidomiConsent.framework into your project and add it as a dependency.
For network preposes enable `NSAppTransportSecurity`
 1. Open your Project target's info.plist file
 2. Add a Key called `NSAppTransportSecurity` as a Dictionary.
 3. Add a Subkey called `NSAllowsArbitraryLoads` as Boolean and set its value to `YES`.

## Usage

Once the framework intergrated in the app, import `DidomiConsent` and call `DidomiConsentManager`.

### Swift
`import DidomiConsent`
### Objc
`#import <DidomiConsent/DidomiConsent.h>`

### Consent
Consent content will be taken from .strings file (Localize or Default).
To add a consent content add the following keys:
`Didomi-consent-title-key` for consent title.
`Didomi-consent-message-key` for consent message.

### Important
If one of the keys could not be found consent would not be shown to the user.

### Consent status
Consent status are `DidomiConsentStatus` enums can be one of the following:
`Undefined`
`Accept`
`Deny`

### Workflow
Call `checkConsentStatus` method to check persistent consent status. In case its `Undefined` `showConsent()` will be called and load a consent dialog.

### Consent Dialog
The SDK default consent dialot is an `UIAlertController`. It will show a title and a consent message. Once the user selected status, it will be persisted and will be sent to the server.

### Subclassing
The SDK can be extended. It is possible to override the following methods:
1. `getConsentStatus() -> DidomiConsentStatus`
2. `setConsentStatus(status: DidomiConsentStatus)`
3. `showConsent()`

For a custom consent UI override `showConsent()` and do all necessary UI. This method called from `checkConsentStatus`

