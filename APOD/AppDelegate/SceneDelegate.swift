//
//  SceneDelegate.swift
//  APOD
//
//  Created by erika.talberga on 27/11/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let apodViewController = APODViewController()
        
        let randomDateVC = UIViewController()
        randomDateVC.view.backgroundColor = .systemRed
        
        let favoritesVC = FavoritesTableViewController()
        favoritesVC.view.backgroundColor = .systemGray
        
        let specificDateVC = UIViewController()
        specificDateVC.view.backgroundColor = .systemMint
        
        apodViewController.setupTabBarItem()
        randomDateVC.tabBarItem = UITabBarItem(title: "Random Date", image: UIImage(systemName: "shuffle.circle.fill"), selectedImage: nil)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.circle.fill"), selectedImage: nil)
        specificDateVC.tabBarItem = UITabBarItem(title: "Specific Date", image: UIImage(systemName: "calendar.circle.fill"), selectedImage: nil)
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [apodViewController, randomDateVC, favoritesVC, specificDateVC]

        window?.rootViewController = tabBarController
        
        window?.makeKeyAndVisible()
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
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

