//
//  FieroApp.swift
//  Fiero
//
//  Created by Marina De Pazzi on 14/06/22.
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
    var userViewModel: UserViewModel!
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("✅✅✅ sceneWillEnterForeground ✅✅✅")
    }
    
    //MARK: - WIP - Still relies on waiting 20 minutes
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("✅✅✅ sceneDidBecomeActive ✅✅✅")
        self.userViewModel?.refreshAuthToken()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("✅✅✅ sceneWillResignActive ✅✅✅")
    }
}

@main
struct FieroApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    init() {
        UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
