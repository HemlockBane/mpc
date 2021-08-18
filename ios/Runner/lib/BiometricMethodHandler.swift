//
//  BiometricMethodHandler.swift
//  Moniepoint
//
//  Created by Paul Okeke on 07/07/2021.
//

import Foundation
import Flutter
import UIKit
import LocalAuthentication
import RNCryptor

// @author Paul Okeke
//
struct BiometricMethodHandler {
    let BIOMETRICS_CHANNEL: String = "moniepoint.flutter.dev/biometric"

    let controller:FlutterViewController
    let server = "www.teamapt.com"
    let accessControl: SecAccessControl?
    
    init(controller: FlutterViewController) {
        self.controller = controller
        
        self.accessControl = SecAccessControlCreateWithFlags(
            nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .biometryAny, nil
        )
    }
    
    func registerBiometricsMethodHandler() {
        let biometricsChannel = FlutterMethodChannel(name: BIOMETRICS_CHANNEL, binaryMessenger: controller.binaryMessenger)
        let mContext = LAContext()
        
        biometricsChannel.setMethodCallHandler { (call: FlutterMethodCall, reply : @escaping FlutterResult) in
            var mapResult : [String: Any?] = [:]
            do {
                switch call.method {
                case "authenticate":
                    guard let args = call.arguments else { return }
                    guard let mainArgs = args as? [String: Any] else { return }
                    
                    let authType = mainArgs["authType"] as? String
                    
                    if(authType == "SetUp") {
                        try self.setupBiometrics(context: mContext, arguments: mainArgs, reply: reply)
                    }else if(authType == "Login") {
                        try self.authenticate(context: mContext, arguments: mainArgs, reply:reply)
                    }
                    return
                case "get_biometric_type":
                    mapResult = getBiometricType(context: mContext)
                    reply(mapResult)
                    return
                default:
                    return
                }
            }
            catch {
                reply(FlutterError(code: "01", message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func getBiometricType(context: LAContext) -> [String: String] {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            var biometricTypeValue = "NONE"
            if(context.biometryType == .faceID) {
               biometricTypeValue = "FACE_ID"
            }else if(context.biometryType == .touchID) {
                biometricTypeValue = "FINGER_PRINT"
            }
            return ["biometric_type": biometricTypeValue]
        } else {
            return ["biometric_type": "NONE"]
        }
    }
    
    private func setupBiometrics(context: LAContext, arguments: [String: Any], reply : @escaping FlutterResult) throws {
        guard let username = arguments["username"] as? String else {
            reply([:])
            return
        }
        guard let generatedPassword = arguments["generated_password"] as? String else {
            reply([:])
            return
        }
        
        guard let encryptionKey = arguments["encryptionKey"] as? String else  {
            reply([:])
            return
        }

        var encryptedPassword: String
        
        let newPassword =  "\(generatedPassword)_\(generateRandomBytes())"
        encryptedPassword = try encryptMessage(message: newPassword, encryptionKey: encryptionKey)
        
        let isKeyDeleted = deleteExistingKeys()
        
        let query : [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String : username,
            kSecAttrServer as String: server,
            kSecAttrAccessControl as String: self.accessControl as Any,
            kSecUseAuthenticationContext as String: context,
            kSecValueData as String: encryptedPassword.data(using: String.Encoding.utf8)!
        ];
        
        //if we are doing a setup we need to clear existing configuration for the application
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess || status == errSecDuplicateItem else {
            print("Unable to initialize biometrics \(status.description)")
            throw BiometricError("Unable to setup biometrics")
        }
        
        if(status == errSecDuplicateItem) {
            SecItemUpdate(query as CFDictionary, [kSecValueData as String : encryptedPassword.data(using: String.Encoding.utf8)] as CFDictionary)
        }
        print("We are done updating the item successfully")
        //we need to quickly read out the item to confirm or rather authenticate the user
        return try self.authenticate(context: context, arguments:arguments, reply: reply)
    }
    
    private func authenticate(context: LAContext, arguments: [String: Any], reply : @escaping FlutterResult)  throws {
        let query : [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server,
            kSecReturnAttributes as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true,
            kSecUseOperationPrompt as String: "Authorize Moniepoint",
        ];
        
        DispatchQueue.main.async {
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            guard status == errSecSuccess else {
                reply(["passwordKey": nil, "extraMessage":"Not initialized"])
                return
            }
            
            guard let encryptionKey = arguments["encryptionKey"] as? String else  {
                reply([:])
                return
            }

            guard let existingItem = item as? [String: Any],
                let passwordData = existingItem[kSecValueData as String] as? Data,
                let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
                reply(["passwordKey": nil, "extraMessage":"Not initialized"])
                return
            }
            print("Attempting to decryptKey \(existingItem)")
            do {
                let passwordKey = try self.decryptMessage(encryptedMessage: password, encryptionKey: encryptionKey)
                reply(["passwordKey": passwordKey])
            } catch {
                reply(FlutterError(code: "BIOMETRIC", message: "Unable to decrypt key", details: nil))
                return
            }
        }
        return
    }
    
    private func deleteExistingKeys() -> Bool {
        let query : [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server,
            kSecReturnAttributes as String: true,
        ];
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            print("Failed to delete Key")
            return false
        }
        return true
    }
    
    func encryptMessage(message: String, encryptionKey: String) throws -> String {
         let messageData = message.data(using: .utf8)!
         let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
         return cipherData.base64EncodedString()
     }

     func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {

         let encryptedData = Data.init(base64Encoded: encryptedMessage)!
         let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
         let decryptedString = String(data: decryptedData, encoding: .utf8)!

         return decryptedString
     }
    
    func generateRandomBytes() -> String {
        var keyData = Data(count: 32)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, 32, $0)
        }
        if result == errSecSuccess {
            return keyData.base64EncodedString()
        } else {
            print("Problem generating random bytes")
            return "$12ydssd44mmd5^s232" //TODO find another way to provide random
        }
    }
}

struct  BiometricError: Error {
    let message: String
    init(_ message: String) {
        self.message = message
    }
    public var localizedDescription: String {
         return message
    }
}
