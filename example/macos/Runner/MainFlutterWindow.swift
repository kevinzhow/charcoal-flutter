import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private var windowChannel: FlutterMethodChannel?
  private var metricObservers: [NSObjectProtocol] = []
  private var backgroundLaunch: Bool {
    ProcessInfo.processInfo.environment["CHARCOAL_BACKGROUND"] == "1"
  }

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = NSRect(
      origin: self.frame.origin,
      size: NSSize(width: 1180, height: 820)
    )
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    self.minSize = NSSize(width: 900, height: 650)
    self.center()
    self.styleMask.insert(.fullSizeContentView)
    self.titlebarAppearsTransparent = true
    self.titleVisibility = .hidden
    // Keep the native titlebar and traffic lights. Only the background extends
    // beneath them; Dart reserves contentLayoutRect's caption inset.
    self.isMovableByWindowBackground = false

    RegisterGeneratedPlugins(registry: flutterViewController)
    let channel = FlutterMethodChannel(
      name: "dev.charcoal.showcase/window",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    windowChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { result(nil); return }
      switch call.method {
      case "getMetrics":
        result(self.metrics())
      case "setBrightness":
        self.appearance = NSAppearance(named: (call.arguments as? String) == "dark" ? .darkAqua : .aqua)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    for name in [NSWindow.didResizeNotification, NSWindow.didEnterFullScreenNotification,
                 NSWindow.didExitFullScreenNotification, NSWindow.didChangeScreenNotification] {
      metricObservers.append(NotificationCenter.default.addObserver(
        forName: name, object: self, queue: .main
      ) { [weak self] _ in
        guard let self = self else { return }
        self.windowChannel?.invokeMethod("metrics", arguments: self.metrics())
      })
    }
    super.awakeFromNib()
  }

  private func metrics() -> [String: Double] {
    let contentHeight = contentView?.bounds.height ?? 0
    return ["captionHeight": Double(max(0, contentHeight - contentLayoutRect.height))]
  }

  // A background development launch must stay behind the user's work, even
  // when Flutter's delayed first frame asks to present the window.
  override func orderFront(_ sender: Any?) {
    if backgroundLaunch && !NSApp.isActive {
      super.orderBack(sender)
    } else {
      super.orderFront(sender)
    }
  }

  override func makeKeyAndOrderFront(_ sender: Any?) {
    if backgroundLaunch && !NSApp.isActive {
      super.orderBack(sender)
    } else {
      super.makeKeyAndOrderFront(sender)
    }
  }

  deinit {
    for observer in metricObservers { NotificationCenter.default.removeObserver(observer) }
  }
}
