import UIKit
import Flutter
import AppMetricaPush

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        AppMetricaPush.setExtensionAppGroup("group.com.yandex.appmetricapushplugin.appmetricaPushPluginExample")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
