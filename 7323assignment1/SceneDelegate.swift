import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Optionally configure and attach the UIWindow to the UIWindowScene provided.
        // If a storyboard is used, the window property is automatically initialized and linked to the scene.
        // This does not necessarily imply that the scene or session are newly created (refer to application:configurationForConnectingSceneSession).

        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            
            // Load dark mode preference from UserDefaults
            let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkMode")
            window?.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
            
            // Load the initial view controller from Main storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()
            window?.rootViewController = initialViewController // Set the root view controller
            
            // Make the window visible
            window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Triggered when the system releases the scene.
        // This can occur when the scene enters the background or its session is discarded.
        // Clean up any resources related to this scene that can be reloaded when the scene reconnects.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene transitions from an inactive to an active state.
        // Restart any tasks paused or not started when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called as the scene transitions from active to inactive.
        // This can happen due to temporary interruptions (e.g., an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from background to foreground.
        // Undo any changes made when entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from foreground to background.
        // Save data, release shared resources, and store state information to restore the scene.
    }
}

