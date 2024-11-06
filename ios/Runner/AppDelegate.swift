import UIKit
import Flutter
import flutter_local_notifications
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)
      
      guard let audioURL = Bundle.main.url(forResource: "110", withExtension: "mp3") else {
          print("Audio file not found")
          return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }

      do {
          let audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
          audioPlayer.prepareToPlay()
          audioPlayer.play()
      } catch {
          print("Failed to play audio:", error.localizedDescription)
      }
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
