//
//  AppDelegate.swift
//  MovieRoot
//
//  Created by quang on 9/8/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var orientation: UIInterfaceOrientationMask = .portrait
    
    var naviVC: UINavigationController?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupRootVC()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientation
    }

    // MARK: UISceneSession Lifecycle

    func setupRootVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let root: SplashVC = SplashVC()
        naviVC = UINavigationController(rootViewController: root)
        naviVC?.isNavigationBarHidden = true
        window?.rootViewController = naviVC
        window?.makeKeyAndVisible()
    }

}

