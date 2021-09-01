//
//  DeviceManagerHandler.swift
//  Moniepoint
//
//  Created by Paul Okeke on 31/08/2021.
//

import Foundation
import Flutter
import LocalAuthentication


struct DeviceManagerHandler {
    
    let DEVICE_CHANNEL: String = "moniepoint.flutter.dev/device_manager"
    let TAG_NAME: String = "com.moniepoint.teamapt.customers.device_id"
    
    let controller: FlutterViewController
    
    init(controller: FlutterViewController) {
        self.controller = controller
    }
    
    func registerDeviceManagerHandler() {
        let deviceMethodChannel = FlutterMethodChannel(name: DEVICE_CHANNEL, binaryMessenger: controller.binaryMessenger)
        deviceMethodChannel.setMethodCallHandler { (call: FlutterMethodCall, reply : @escaping FlutterResult) in
            switch call.method {
            case "get_device_id":
                print("Call to get Device ID")
                reply(self.getDeviceId())
                return
            case "set_device_id":
                guard let args = call.arguments else { return }
                guard let mainArgs = args as? [String: Any] else { return }
                
                let deviceId = mainArgs["deviceId"] as? String
                
                if(deviceId == nil || deviceId?.isEmpty == true) { return }
                
                let success = self.setDeviceId(vendorId: deviceId!)
                
                reply(success)
                return
            default:
                return
            }
        }
    }
    
    private func setDeviceId(vendorId: String) -> Bool {
        let query : [String: Any] = [
            kSecValueData as String: vendorId.data(using: String.Encoding.utf8)!,
            kSecAttrAccount as String: TAG_NAME,
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            kSecAttrSynchronizable as String: false // dont backup in iCloud
        ];
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess || status == errSecDuplicateItem  else {
            return false
        }
        print("Device ID Set Successfully in keychain")
        return true;
    }
    
    private func getDeviceId() -> String? {
        let query : [String: Any] = [
            kSecAttrAccount as String: TAG_NAME,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecClass as String : kSecClassGenericPassword,
            kSecReturnAttributes as String: true,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            kSecReturnData as String: true,
        ];
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            print("No Device ID Found!!")
            return nil
        }
                        
        guard let existingItem = item as? [String: Any],
            let valueData = existingItem[kSecValueData as String] as? Data,
            let deviceId = String(data: valueData, encoding: String.Encoding.utf8)
        else {
            return nil
        }
        
        print("Found Device ID")

        return deviceId
    }
}
