//
//  SceneDelegate.swift
//  Liteapp
//
//  Created by Navroz Huda on 02/06/22.
//

import UIKit
import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let universalLink = userActivity.webpageURL else {
            return
        }
       
        Defaults.shared.referralCode = nil
        if universalLink.lastPathComponent.count == 4 && universalLink.lastPathComponent != "referral" {
            Defaults.shared.referralCode =  universalLink.lastPathComponent
        }
      
    }
    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
        
       
    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        
        
        guard let scene = (scene as? UIWindowScene) else { return }
         self.window = UIWindow(windowScene: scene)
        self.window?.backgroundColor = .white
        let rootVC =  Defaults.shared.currentUser != nil ?  DashBoardVC.instantiate() :  LoginViewController.instantiate()

        let rootNC = UINavigationController(rootViewController: rootVC)
        rootNC.navigationBar.tintColor = .black
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
        setUpIQKeyboardManager()
        
        Defaults.shared.referralCode = nil
        
        for userActivity in connectionOptions.userActivities {
             if let universalLink = userActivity.webpageURL {
                 if universalLink.lastPathComponent.count == 4 && universalLink.lastPathComponent != "referral" {
                     Defaults.shared.referralCode =  universalLink.lastPathComponent
                     break
                 }
             }
            
        }

    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>){
        guard let universalLink = URLContexts.first?.url else { return }
        print(universalLink)
        Defaults.shared.referralCode = nil
        if universalLink.lastPathComponent.count == 4 && universalLink.lastPathComponent != "referral" {
            Defaults.shared.referralCode =  universalLink.lastPathComponent
        }
    }
    private func setUpIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.Color.blue
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
        
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

