////
////  AppDelegate.swift
////  Duello
////
////  Created by Darius Dresp on 3/4/20.
////  Copyright © 2020 Darius Dresp. All rights reserved.
////

import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Navigation UI
        UISearchBar.appearance().barTintColor = BLACK
        UISearchBar.appearance().barStyle = .default
        
        UIToolbar.appearance().tintColor = LIGHT_GRAY
        UIToolbar.appearance().barTintColor = BLACK
        UIToolbar.appearance().backgroundColor = BLACK
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: LIGHT_GRAY]
        
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().tintColor = LIGHT_GRAY
        UINavigationBar.appearance().barTintColor = BLACK
        UINavigationBar.appearance().isTranslucent = false
        let attributes = [NSAttributedString.Key.font : UIFont.boldCustomFont(size: 16), NSAttributedString.Key.foregroundColor: LIGHT_GRAY]
        UINavigationBar.appearance().titleTextAttributes = attributes // Title fonts
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal) // Bar Button fonts
        
        UITabBar.appearance().tintColor = LIGHT_GRAY
        UITabBar.appearance().barTintColor = BLACK
        
        

        //Facebook Login
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions)

        //Google Login
        GIDSignIn.sharedInstance().clientID = "754429679739-i7adje732tpodilo4e7ok94dglhivk0o.apps.googleusercontent.com"

        //Configuring Firebase
        FirebaseApp.configure()
        
        window?.bounds = UIScreen.main.bounds
        window?.makeKeyAndVisible()

        if let window = window {
            appCoordinator = AppCoordinator(window: window)
            appCoordinator?.start()
        }

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        //Facebook Login
        let isFacebookOpenUrl = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])

        //Google Login
        let isGoogleOpenUrl = GIDSignIn.sharedInstance().handle(url)

        if isGoogleOpenUrl { return true }
        if isFacebookOpenUrl { return true }

        return false

    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}
