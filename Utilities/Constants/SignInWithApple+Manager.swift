import Foundation
import UIKit
import AuthenticationServices

class SIAManager: NSObject {


    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let user = "apple_user"
        static let uniqueID = "apple_user_uniqueID"
        static let title = "title"
        static let submenu = "submenu"
    }

    static let shared: SIAManager = SIAManager()

    typealias completion = ([String: String?]?, Error?) -> Swift.Void

    public var completionHandler: completion?

    private override init() {

        super.init()

        // call the function appleIDStateRevoked if user revoke the sign in in Settings app
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(appleIDStateRevoked),
                                                   name: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
                                                   object: nil)
        } else {
            // Fallback on earlier versions
        }

    }

    deinit {
        // Remove all the observer from this class.
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func appleIDStateRevoked() {
        // user has revoked the access - log out user, change UI etc
        // TODO: Take required actions here.
        print("oneone")
    }

    @available(iOS 13.0, *)
    private func handleLogInWithAppleID(compliton: @escaping completion) {
        completionHandler = compliton

        let provider = ASAuthorizationAppleIDProvider()

        let request = provider.createRequest()

        // request full name and email from the user's Apple ID
        request.requestedScopes = [.fullName, .email]

        // pass the request to the initializer of the controller
        let authController = ASAuthorizationController(authorizationRequests: [request])

        // similar to delegate, this will ask the view controller
        // which window to present the ASAuthorizationController
        //        authController.presentationContextProvider = APP_DELEGATE.window?.rootViewController

        // delegate functions will be called when user data is
        // successfully retrieved or error occured
        authController.delegate = self

        // show the Sign-in with Apple dialog
        authController.performRequests()

    }

    @available(iOS 13.0, *)
    public func performSignIn(compliton: @escaping completion) {
        // Check if user has previously logged in using Apple or not.
        if let userID = try? keychain.getString(SerializationKeys.uniqueID) {

            print(userID)

            // get the login status of Apple sign in for the app
            // asynchronous
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID,
                                                                completion: {
                                                                    credentialState, error in

                                                                    switch(credentialState) {
                                                                    case .authorized:
                                                                        print("user remain logged in, proceed to another view")
                                                                        self.handleLogInWithAppleID(compliton: compliton)
                                                                    case .revoked:
                                                                        print("user logged in before but revoked")
                                                                        self.handleLogInWithAppleID(compliton: compliton)
                                                                    case .notFound:
                                                                        print("user haven't log in before")
                                                                        self.handleLogInWithAppleID(compliton: compliton)
                                                                    default:
                                                                        print("unknown state")
                                                                    }

            })

        }  else {
            // Initiate new login.
            self.handleLogInWithAppleID(compliton: compliton)
        }

    }

}

// MARK: - ASAuthorizationControllerDelegate Methods-
@available(iOS 13.0, *)
extension SIAManager: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:

            // unique ID for each user, this uniqueID will always be returned
            let userID = appleIDCredential.user

            // Check if you have already data available for the same user or not?
            if let aDict = self.getDetailsFromKeychain(forId: userID) {
                completionHandler?(aDict, nil)
                return
            }

            // save it to Keychain to retrieve the inforamtion later.
            guard ((try? keychain.set(userID, key: SerializationKeys.uniqueID)) != nil) else {
                completionHandler?(nil, nil)
                return
            }

            let email = appleIDCredential.email

            let givenName = appleIDCredential.fullName?.givenName

            let middleName = appleIDCredential.fullName?.middleName

            let familyName = appleIDCredential.fullName?.familyName

            let nickName = appleIDCredential.fullName?.nickname

            /*
             useful for server side, the app can send identityToken and authorizationCode
             to the server for verification purpose
             */
            var identityToken : String?
            if let token = appleIDCredential.identityToken {
                identityToken = String(bytes: token, encoding: .utf8)
            }

            var authorizationCode : String?
            if let code = appleIDCredential.authorizationCode {
                authorizationCode = String(bytes: code, encoding: .utf8)
            }


            // Check if you get all the three details and store them in the keychain for future reference.
            // as you will get this details only once.
            if email != nil && givenName != nil {
                let aUserDict: [String: String?] = ["userID": userID,
                                                "email": email,
                                                "givenName": givenName,
                                                "middleName": middleName,
                                                "familyName": familyName,
                                                "nickName": nickName,
                                                "identityToken": identityToken,
                                                "authorizationCode": authorizationCode]

                // Store the detail in the keychain.
                storeUserDict(aUserDict, forId: userID)

                // Return success with the user dictionary.
                completionHandler?(aUserDict, nil)

            } else {
                // Try and get the details from the already stored data from the keychain.
                if let aDict = getDetailsFromKeychain(forId: userID) {
                    completionHandler?(aDict, nil)
                } else {
                    // unable to get details from the keychain as well.
                    completionHandler?(nil, nil)
                }
            }


            break

        case let appleIDCredential as ASPasswordCredential:

            // The user name of this credential.
            let appleUsername = appleIDCredential.user

            // The password of this credential.
            let applePassword = appleIDCredential.password

            print(appleUsername)
            print(applePassword)

            completionHandler?(nil, nil)

        default:
            completionHandler?(nil, nil)
            break
        }

    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        print("Apple Sign-In authorization error: ", error)
        guard let error = error as? ASAuthorizationError else {
            return
        }

        switch error.code {
        case .canceled:
            // user press "cancel" during the login prompt
            print("Canceled")
        case .unknown:
            // user didn't login their Apple ID on the device
            print("Unknown")
        case .invalidResponse:
            // invalid response received from the login
            print("Invalid Respone")
        case .notHandled:
            // authorization request not handled, maybe internet failure during login
            print("Not handled")
        case .failed:
            // authorization failed
            print("Failed")
        @unknown default:
            print("Default")
        }

        // Completed with an Error.
        completionHandler?(nil, error)

    }

}


extension SIAManager {

    private func getDetailsFromKeychain(forId: String) -> [String: String?]? {

        do {
            guard let data = try keychain.getData(forId) else { return nil }
            guard let aDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String?] else { return nil }
            return aDict
        } catch {
            return nil
        }

    }

    /// This function will used to store the User's Email Address and Password in the Keychain access.
    ///
    ///     UserManager.storeUserDict(<OBJECT OF THE USER>)
    ///
    /// - Parameter user: Object of the User which you wanted to store in keychain
    /// - Returns: true if data is stored successfully in the keychain otherwise false.
    @discardableResult
    private func storeUserDict(_ user: [String: Any], forId: String) -> Bool {

        do {

            guard let theJSONData = try? JSONSerialization.data(withJSONObject: user, options: []) else { return false }
            try keychain.set(theJSONData, key: forId)
            return true

        } catch let error {
            print(error)
            return false
        }

    }

}
