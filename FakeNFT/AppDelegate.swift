import UIKit
import Kingfisher

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ImageCache.default.memoryStorage.config.totalCostLimit = 1024 * 1024 * 50 // 50 Мб в оперативной памяти
        ImageCache.default.diskStorage.config.sizeLimit = 1024 * 1024 * 200 // 200 МБ на диске
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
