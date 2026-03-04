import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {

  private var secureView: UIView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_KEY")

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenCaptureChanged),
      name: UIScreen.capturedDidChangeNotification,
      object: nil
    )

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @objc func screenCaptureChanged() {
    if UIScreen.main.isCaptured {
      enableSecureOverlay()
    } else {
      disableSecureOverlay()
    }
  }

  private func enableSecureOverlay() {
    guard let window = UIApplication.shared.windows.first else { return }

    if secureView == nil {
      let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
      blur.frame = window.bounds
      blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      secureView = blur
      window.addSubview(blur)
    }
  }

  private func disableSecureOverlay() {
    secureView?.removeFromSuperview()
    secureView = nil
  }

  override func applicationWillResignActive(_ application: UIApplication) {
    enableSecureOverlay()
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    disableSecureOverlay()
  }
}