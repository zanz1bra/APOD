//
//  SceneDelegate.swift
//  APOD
//
//  Created by erika.talberga on 27/11/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let apodViewController = APODViewController()
        apodViewController.view.backgroundColor = UIColor(red: 62/255.0, green: 96/255.0, blue: 111/255.0, alpha: 1.0)
        let apodNavigationController = UINavigationController(rootViewController: apodViewController)
        apodNavigationController.title = "Astronomy Picture of The Day"

        let randomDateVC = RandomDateViewController()
        randomDateVC.view.backgroundColor = UIColor(red: 62/255.0, green: 96/255.0, blue: 111/255.0, alpha: 1.0)
        let randomDateNavigationController = UINavigationController(rootViewController: randomDateVC)
        randomDateNavigationController.title = "Random Date"
        
        let favoritesVC = FavoritesTableViewController()
        favoritesVC.view.backgroundColor = UIColor(red: 62/255.0, green: 96/255.0, blue: 111/255.0, alpha: 1.0)
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesVC)
        favoritesNavigationController.title = "Favorites"
        
        let specificDateVC = UINavigationController(rootViewController: DatePickerViewController())
        specificDateVC.view.backgroundColor = UIColor(red: 62/255.0, green: 96/255.0, blue: 111/255.0, alpha: 1.0)
        specificDateVC.topViewController?.title = "Specific Date"

        apodViewController.setupTabBarItem()
        
        let randomDateImage = UIImage(systemName: "shuffle.circle.fill")?.withRenderingMode(.alwaysTemplate)
        let favoritesImage = UIImage(systemName: "heart.circle.fill")?.withRenderingMode(.alwaysTemplate)
        let specificDateImage = UIImage(systemName: "calendar.circle.fill")?.withRenderingMode(.alwaysTemplate)
        
        randomDateVC.tabBarItem = UITabBarItem(title: "Random Date", image: randomDateImage, selectedImage: nil)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: favoritesImage, selectedImage: nil)
        specificDateVC.tabBarItem = UITabBarItem(title: "Specific Date", image: specificDateImage, selectedImage: nil)
        
        UITabBar.appearance().tintColor = UIColor(red: 242/255.0, green: 235/255.0, blue: 199/255.0, alpha: 1.0)
        UITabBar.appearance().barTintColor = UIColor(red: 41/255.0, green: 50/255.0, blue: 65/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.yellow], for: .selected)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [apodNavigationController, randomDateNavigationController, favoritesNavigationController, specificDateVC]
        tabBarController.delegate = self
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        performTabSwitchAnimation(from: tabBarController.selectedViewController, to: viewController)
        return true
    }
    
    // MARK: - Tab Switch Animation
    
    private func performTabSwitchAnimation(from fromVC: UIViewController?, to toVC: UIViewController) {
        guard let fromViewController = fromVC, let window = self.window, let currentTabBarController = window.rootViewController as? UITabBarController else {
            window?.rootViewController = toVC
            return
        }
        
        UIView.transition(from: fromViewController.view,
                          to: toVC.view,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          completion: { _ in
            self.switchToTabBarController(toVC, in: currentTabBarController)
        })
    }
    
    private func switchToTabBarController(_ viewController: UIViewController, in tabBarController: UITabBarController) {
        if let navigationController = viewController as? UINavigationController {
            navigationController.popToRootViewController(animated: false)
        }
        tabBarController.selectedViewController = viewController
    }
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




