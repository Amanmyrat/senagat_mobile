import Flutter
import UIKit
import Security

@main
@objc class AppDelegate: FlutterAppDelegate {

  private var secureView: UIView?

  private let secureStorageChannel = "senagat_secure_storage"
  private let secureStorageService = "com.aplinxy9plin.senagat.secure_storage"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenCaptureChanged),
      name: UIScreen.capturedDidChangeNotification,
      object: nil
    )

    setupSecureStorageChannel()

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setupSecureStorageChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let channel = FlutterMethodChannel(
      name: secureStorageChannel,
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else {
        result(FlutterError(
          code: "INTERNAL_ERROR",
          message: "AppDelegate released",
          details: nil
        ))
        return
      }

      switch call.method {
      case "write":
        guard
          let args = call.arguments as? [String: Any],
          let key = args["key"] as? String,
          let value = args["value"] as? String,
          !key.isEmpty
        else {
          result(FlutterError(
            code: "INVALID_ARGUMENT",
            message: "Key or value is missing",
            details: nil
          ))
          return
        }

        let success = self.saveSecureValue(key: key, value: value)
        if success {
          result(nil)
        } else {
          result(FlutterError(
            code: "WRITE_FAILED",
            message: "Failed to write secure value",
            details: nil
          ))
        }

      case "read":
        guard
          let args = call.arguments as? [String: Any],
          let key = args["key"] as? String,
          !key.isEmpty
        else {
          result(FlutterError(
            code: "INVALID_ARGUMENT",
            message: "Key is missing",
            details: nil
          ))
          return
        }

        result(self.readSecureValue(key: key))

      case "deleteAll":
        let success = self.deleteAllSecureValues()
        if success {
          result(nil)
        } else {
          result(FlutterError(
            code: "DELETE_FAILED",
            message: "Failed to clear secure values",
            details: nil
          ))
        }

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func saveSecureValue(key: String, value: String) -> Bool {
    guard let data = value.data(using: .utf8) else {
      return false
    }

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: secureStorageService,
      kSecAttrAccount as String: key
    ]

    let attributes: [String: Any] = [
      kSecValueData as String: data,
      kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
    ]

    let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

    if updateStatus == errSecSuccess {
      return true
    }

    if updateStatus != errSecItemNotFound {
      return false
    }

    var addQuery = query
    addQuery[kSecValueData as String] = data
    addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

    let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
    return addStatus == errSecSuccess
  }

  private func readSecureValue(key: String) -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: secureStorageService,
      kSecAttrAccount as String: key,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)

    guard
      status == errSecSuccess,
      let data = item as? Data,
      let value = String(data: data, encoding: .utf8)
    else {
      return nil
    }

    return value
  }

  private func deleteAllSecureValues() -> Bool {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: secureStorageService
    ]

    let status = SecItemDelete(query as CFDictionary)
    return status == errSecSuccess || status == errSecItemNotFound
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