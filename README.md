# Trifork Health Platform iOS SDK

Trifork Health Platform iOS SDK is a Swift library wrapping [Trifork's Identity Manager iOS SDK](https://github.com/trifork/TIM-iOS) for its usages in THP projects.

## Requirements

| Version | Requirements            |
|:--------|:------------------------|
| 1.0.0   | Swift 6.2+<br>iOS 15.0+ |

## Installation

### Swift Package Manager

To install using Swift Package Manager, add this to the `dependencies` section in your `Package.swift` file:

```swift
.package(url: "https://github.com/trifork/thp-ios-sdk", .upToNextMajor(from: "1.0.0")),
```

Alternatively, use Xcode's Package Dependency UI to add this library with the following URL: `https://github.com/trifork/thp-ios-sdk`

## Usage

### Main entry point

The library has two main entry points, depending on how the client app is setup. The first, and easiest, is using the singleton instance as such:

```swift
import TriforkHealthPlatformSDK

let thp = THP.shared
```
Bear in mind that this instance **is not configured from the start**. As such, you'll need to call the `configure(_:)` function, as explained below.

If your app uses a Dependency Injection system that retains specific instances for a given type, you can otherwise use the default _asynchronous_ initializer to obtain an instance:

```swift
import TriforkHealthPlatformSDK

let config = THPConfiguration(
    scopes: [ "<scope 1>", "<scope 2>", ... ],
    realm: "<realm>",
    clientId: "<clientId>",
    redirectUrl: URL(string:"<urlScheme>:/")!,
    baseAuthURL: URL(string: "<Base Auth URL>")!,
    loginFlowKey: "<Client Login Flow Key>"
)

let thp = await THP(configuration: config)
```
Contrary to the singleton instance, this will return a fully configured THP instance.

In either case, whether the library is fully configured can be checked using the `isConfigured` variable.

For the purposes of this documentation, we will provide code examples using the **singleton** approach.

### Setup configuration

Before using any function or property from `THP` you have to configure the framework by calling the `configure(_:)` function (typically you want to do this on app startup):

```swift
import TriforkHealthPlatformSDK

let config = THPConfiguration(
    scopes: [ "<scope 1>", "<scope 2>", ... ],
    realm: "<realm>",
    clientId: "<clientId>",
    redirectUrl: URL(string:"<urlScheme>:/")!,
    baseAuthURL: URL(string: "<Base Auth URL>")!,
    loginFlowKey: "<Client Login Flow Key>"
)

await THP.shared.configure(config)
```

In case the client app can be setup for different environments (for instance, having different `baseAuthURL`), and the current environment can be selected at runtime, this function can be called multiple times with different configurations. Only the latest configuration provided will be stored, and all internal properties will be reinitilized. This **will not** clear user stored data or logout the current user automatically, so bear in mind that you might need to do so manually depending on your workflow.

Accessing either `auth` or `userStorage` from the main entry point when the library is not fully configured will trigger a `fatalError`. As such, in case you are not sure if the instance if fully configured, check the `isConfigured` property as follows:

```swift
if THP.shared.isConfigured {
    // Do stuff requiring access to auth or userStorage
} else {
    // Fallback code
}
```
Take into account that the `THP` instance **is not observable**, and as a consequence neither is the `isConfigured` variable. Therefore, you'll need to manually check the property value.

### URL scheme

Setup your URL scheme or Universal Links to receive login redirects, following the [Apple official documentation](https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app).

Depending on your life cycle handling, you should handle URL requests in one of the following callbacks:

* SwiftUI: `.onOpenURL(perform:)`
* SceneDelegate: `scene(_:, openURLContexts:)`
* AppDelegate: `application(_:, open:, options:) -> Bool`

Example for `SceneDelegate`:
```swift
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    for url: URL in URLContexts.map({ $0.url }) {
        THP.shared.auth.handleRedirect(url: url)
    }
}
```

### FaceID permission in `Info.plist`

As per [Apple's documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/nsfaceidusagedescription), remember to set the value for the `NSFaceIDUsageDescription` key in your `Info.plist`  if you intend on using the biometric feature of `THP`, either in the file directly or in the section in the project Build Settings.

## Common use cases

### Register / OIDC Login

All users will have to register through an OpenID Connect login. This is achieved as follows:

```swift
let flow: THPAuthenticationFlow = .signup // .signin for login 

do {
    let userId = try await THP.shared.auth.performOpenIDConnectFlow(flow: flow)
    print("Successfully logged in, with userId \(userId)")
} catch {
    print("Failed to perform OpenID Connect login: \(error.localizedDescription)")
}
```

### Setting password

To avoid the OpenID Connect login everytime the user needs a valid session, you can provide a password, which will allow you to save an encrypted version of the refresh token, such that the user only needs to provide the password to get a valid access token. 

The user must have performed a successful OpenID Connect login before setting a password, since the refresh token has to be available.

```swift
guard let refreshToken = await THP.shared.auth.refreshToken else {
    return
}

do {
    try await THP.shared.userStorage.storeRefreshToken(refreshToken, withNewPassword: password)
    print("Saved refresh token")
} catch {
    print("Failed to store refresh token: \(error.localizedDescription)")
}
```

### Enable biometric login

After the user has created a password, you can enable biometric access for the login. You will need the user's password to do this.

```swift
do {
    try await THP.shared.userStorage.enableBiometricAccessForRefreshToken(password: password)
    print("Successfully enabled biometric login for user.")
} catch {
    print("Whoops, something went wrong: \(error.localizedDescription)")
}
```

### Login with password/biometrics

The user can use biometrics if it was enabled previously, otherwise you will have to provide the password.

You can set the value of `storeNewRefreshToken` in `loginWithPassword(password:storeNewRefreshToken)` to control whether the system should update the refresh token on successful login. It is **highly recommended** to store the new refresh token, since it will keep renewing the user's session everytime they login. Although, you can set this to `false` for use cases where you don't want to update it. 

```swift
// Login with password
do {
    let newToken = try await THP.shared.auth.loginWithPassword(password: password, storeNewRefreshToken: true)
    print("Successfully logged in with password.")
} catch {
    print("Failed to log in with password.")
    handleError(error)
}

// Login with biometrics
do {
    let newToken = try await THP.shared.auth.loginWithBiometricId(storeNewRefreshToken: true)
    print("Successfully logged in with biometrics.")
} catch {
    print("Failed to log in with biometrics.")
    handleError(error)
}

// Error handling
func handleError(_ error: THPError) {
    switch error {
    case .storage(let storageError):
        switch storageError {
        case .incompleteUserDataSet:
            // Reset user! We cannot recover from this state!
            break
        case .encryptedStorageFailed:
            // Note that this is a simplified error handling, which uses the Bool extensions to avoid huge switch statements.
            // If you want to handle errors the right way, you should look into all error cases and decide which you need specific
            // error handling for. The ones you see here are the most common ones, which are very likely to happen.
            if storageError.isWrongPassword() {
                // Handle wrong password
            } else if storageError.isKeyLocked() {
                // Handle key locked (three wrong password logins)
            } else if storageError.isBiometricFailedError() {
                // Bio failed or was cancelled, do nothing.
            } else if storageError.isKeyServiceError() {
                // Something went wrong while communicating with the key service (possible network failure)
            } else {
                // Something failed - please try again.
            }
        }
    case .auth(let authError):
        if case THPAuthError.refreshTokenExpired = authError {
            // Refresh Token has expired.
        }
    }
}
```

### Make use of the data and the session

#### THPJWT data

The tokens are of the type `THPJWT`, a `Sendable` struct storing the original `String` instance returned by the auth service and some its decoded values in convenient stored properties. Already implemented decoded properties are the following:

* **UserId:** `token.userId` (`String`)
* **Expiration date:** `token.expireDate` (`Date?`)
* **Issuer:** `token.issuer` (`String?`)
* **Login provider**: `token.loginProvider` (`String`)

Note that all of the above except the `userId` return an `Optional` value. Indeed, the token cannot initialize without a valid `userId`, which corresponds to the key `sub`.

In addition, `THPJWT` includes a public `subscript` function:
```swift
subscript<Value>(_ key: String) -> Value?
```
This function allows a client app to access further information stored in the raw `String` token which might not me accessible through the already implemented properties. As an example:
```swift
let loginProvider = token["login_provider"]
```
will return the same value stored in `loginProvider`. Bear in mind that every invocation to this function does trigger decoding the raw `String` token.

#### Users

Contrary to TIM, this framework keeps track of a single user that has created passwords and stored encrypted refresh tokens. As such, multiple users cannot use the same device: they need to logout the current user and login or register a new user after that.

#### Refresh token

In most cases you won't have to worry about your refresh token, since `THP` handles this for you. If you should be in a situation where you need it, it can be accessed from the `userStorage`:

```swift
do {
    let refreshToken = try await THP.shared.userStorage.getStoredRefreshToken(for: userId, with: password)
} catch {
    print("Error retrieving refresh token")
}
```

#### Access token

`THP` makes sure that your access token is always valid and refreshed automatically. This is the main reason behind the function `getAccessToken(forceRefresh:)` defined in `THPAuth` being asynchronous.

Most of the time `THP` will complete the call immediately when the token is available, and a bit slower when the token needs to be updated.

You should avoid assigning the value of the access token to a property, and instead always use this function when you need it to make sure the token is valid.

```swift
do {
    let accessToken = try await THP.shared.auth.getAccessToken(forceRefresh: false)
    // Do stuff with the access token here
} catch {
    print("Error retrieving access token")
}
```

`THP` will refresh the token automatically if it's expired when calling the above function. Nevertheless, you might need an access token that is not just valid, but also has a fresh expiration date. If that is the case, you can force the token to refresh by passing `true` to the function `forceRefresh` parameter as follows:

```swift
do {
    let accessToken = try await THP.shared.auth.getAccessToken(forceRefresh: true)
    // Do stuff with the refreshed access token here
} catch {
    print("Error retrieving access token")
}
```

### Log out and optionally delete user

You can log out a user by calling the following function:
```swift
await THP.shared.auth.logout(clearUser: false)
```

Optionally you can clear all stored data for that user. When this last option is enabled, `THP` will throw away the current access token and refresh token, such that you will have to load it again by logging in:
```swift
await THP.shared.auth.logout(clearUser: true)
```

### Understanding the errors

`THP` can throw a large set of errors, because of the different dependencies. All errors are wrapped within the `THPError` `enum`, with specific cases `auth` and `storage`, depending on the area that throws the error. The errors will contain other errors coming from the heart of the framework and there are a couple of levels in this:

```swift
enum THPError: Error {
    case auth(THPAuthError)
    case storage(THPStorageError)
}
```

Most errors are present to help the debugging process, to make it easy to spot a wrong configuration. Once everything is configured correctly there is a small set of errors to present to the user, most of them coming from `TIM`:

```swift
// Refresh token has expired
THPError.auth(THPAuthError.refreshTokenExpired)

// The user pressed cancel in the safari view controller during the OpenID Connect login
THPError.auth(THPAuthError.safariViewControllerCancelled)

THPError.storage(
    THPStorageError.encryptedStorageFailed(
        TIMEncryptedStorageError.keyServiceFailed(TIMKeyServiceError.badPassword)
    )
) 

THPError.storage(
    THPStorageError.encryptedStorageFailed(
        TIMEncryptedStorageError.keyServiceFailed(TIMKeyServiceError.keyLocked)
    )
) 
```

Since the `TIMKeyServiceError`s are so deeply into the error structure, there are short hands for this on the `THPStorageError` type:

```swift
if storageError.isKeyLocked() {
    // Handle key locked (happens on wrong password three times in a row)
}
if storageError.isWrongPassword() {
    // Handle wrong password
}
if storageError.isKeyServiceError() {
    // The communication with the KeyService failed. E.g. no internet connection.
}
if storageError.isBiometricFailedError() {
    // Handle biometric failed/was cancelled scenario.
}
```

Other errors should of course still be handled, but they can be handled in a more generic way since they might be caused by network issues, server updates, or other unpredictable cases.

## Architecture

`THP` depends on `TIM`, which in turn depends on `AppAuth` and `TIMEncryptedStorage`. In essence, `THP` wraps `TIM` usage for common use cases (see sections above), such that signing in/up and encrypted storage are easy to manage.

## Breaking changes from `0.x`

There have been significant breaking changes in version `1.x`, mainly due to the adoption of Swift 6.2 and compliance with strict concurrency. Specifically:

* iOS minimum version has been increased to 15 or higher to enable usage of `async/await` syntax.
* Swift minimum version has been increased to 6.2 to take full advantage of new features and strict concurrency. Note that this might restrict the Xcode version used when integrating this library into a project.
* All functions returning `AnyPublisher<Value, Error>` have been converted to `async throws` functions returning `Value` and throwing the same `Error` type as the one wrapped in the `Publisher`, although the error is not safely typed within the `throws` signature due to language restrictions and `THPError` being a wrapper of `TIMError`.
* `THPAuth`, `THPUserStorage` and `TIMManager` (and their implementations) have been converted from `class` to `actor`, and all properties and functions are isolated and marked as `async`.
* `THPAuthenticationFlow`, `THPConfiguration` and `THPJWT` are now conforming to `Sendable`.
* Implementation of `THPJWT` has been expanded to include new properties, and a new subscript function to access custom key-value pairs in the token.
* `THP` function `configure(configuration:customOIDExternalUserAgent:)` has been changed to `configure(_ configuration:)` for simplicity.

In addition, [Apollo iOS](https://github.com/apollographql/apollo-ios) has been removed as a dependency from this library, as it was not used anywhere. Furthermore, it should be the client app's responsibility, and not this library's, to integrate with whichever networking SDK they need to. This library **should not** enforce any pattern beyond what is strictly required to authenticate with `TIM`. Otherwise, it becomes part of a specific client app and not a reusable framework.
