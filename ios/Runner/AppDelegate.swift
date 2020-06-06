import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyAXEo7ky_w4ZLCpNtj5FyXe_YtLfnjJpyI")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
