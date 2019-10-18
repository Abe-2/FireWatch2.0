//
//  AppDelegate.swift
//  FireWatch2.0
//
//  Created by Abdalwahab on 10/18/19.
//  Copyright © 2019 team. All rights reserved.
//

import UIKit
import NMAKit

let credentials = (
    appId: "K2Zbam3NQrqrCVmmVJLl",
    appCode: "2fX5LG2pIDpvSHk8nh1B_A",
    licenseKey: "PqUAr2euM++JRPV+/DwcfXmS5pbEcUHSxM0hY35HYNgaxD9T5Dy+OaWaKfhvNLS6iYIwu4g119sWWMJ0Dh1gifC/8WXtHp/hxJGJSkDRlv3Wbps2He491pjojrdrifbUT6rckiDqW7Mi774GEKrOqffdH/0DNpXtlyT9onDqg476Sz0exqV1GB7l57RGnH08DFUWkTgQsqVQm+SZyujusoju7Spmd+VPhNH8w9xXE3nNC5JhKRZmRUcUkycNVpIdo+Z5KKpm/n0BiXsoNVEh7X8Z3qMyktT9bd6vhrKBgLMHpqdILE/ZFb4mUvPyRwqYMRxG08ixM7KdDoI/7XViKV6yZ5llsA8PMkERd3t+GgaJbAewnM0hkgkFpc/TLBtMDn6iOs8/r/U76BHX0IT6nJCcf6c2iHMmLAM8fIj7n57dc94o/9kivuu66kjfKzkXzvU1T3/wBY3NxFaRL7wU6XzeEUw1rjL7MRWyu3+kmFSmC+VeeKJCKLzfYOKY8Mkmi6dvgFuc29nJgX8MtuaK1YONXThYtzcTNyXKTJG9F+2L9zm6UwSGkea7amRnJoItQP7sbIIamTCwAbrO5mFgA4TSI6NmUc4e8jUej2c/rAeCF6Zaw9nxZ27Reefk+9zSj8hWDAD5KHs8I6jqpOzzrYm4rBsZjpzEKa20fobPg3o="
)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NMAApplicationContext.setAppId(credentials.appId, appCode: credentials.appCode, licenseKey: credentials.licenseKey)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

