import Cocoa
import FlutterMacOS

private final class ReaderFlutterViewController: FlutterViewController {
  var desktopNavigationChannel: FlutterMethodChannel?

  override func swipe(with event: NSEvent) {
    // AppKit sends this for the page-navigation gesture configured by the user.
    guard event.deltaX > 0 else {
      super.swipe(with: event)
      return
    }

    desktopNavigationChannel?.invokeMethod("backGesture", arguments: nil)
  }
}

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = ReaderFlutterViewController()
    let navigationChannel = FlutterMethodChannel(
      name: "flood/desktop_navigation",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    flutterViewController.desktopNavigationChannel = navigationChannel

    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
