//
//  AppDelegate.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)

        switch PhotosService.shared.authorizationStatus {
        case .notDetermined, .restricted, .denied:

            let accessVC = AccessLibraryViewController()
            accessVC.onComplete = { _ in
                window.rootViewController = SelectPhotoViewController()
            }
            window.rootViewController = accessVC

        case .authorized, .limited:
            window.rootViewController = SelectPhotoViewController()
        @unknown default:
            break
        }

        window.makeKeyAndVisible()
        
        self.window = window

        return true
    }
}
