import UIKit
import Flutter
import GoogleMaps
import PushKit
import CallKit
//import flutter_voip_push_notification

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate{
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    //FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyDAHdeQbSuLtDdpfhueU392zOUW6KAjGlA")
    application.registerForRemoteNotifications()

     if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "dexterx.dev/wemoove",
                                            binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if ("getTimeZoneName" == call.method) {
                result(TimeZone.current.identifier)
            }
        })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    /* Add PushKit delegate method

        // Handle updated push credentials
        func pushRegistry(_ registry: PKPushRegistry,
                          didReceiveIncomingPushWith payload: PKPushPayload,
                          for type: PKPushType,
                          completion: @escaping () -> Void){
            // Register VoIP push token (a property of PKPushCredentials) with server
            FlutterVoipPushNotificationPlugin.didReceiveIncomingPush(with: payload, forType: type.rawValue)
        }

        // Handle incoming pushes
        func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
            // Process the received push
            FlutterVoipPushNotificationPlugin.didUpdate(pushCredentials, forType: type.rawValue);
        }*/
}
