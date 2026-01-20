import UIKit
import PushKit
import Flutter
import flutter_callkit_incoming_timer
import flutter_webrtc

@main
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        //Setup VOIP
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]

        RTCAudioSession.sharedInstance().useManualAudio = true
        RTCAudioSession.sharedInstance().isAudioEnabled = false
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let audioChannel = FlutterMethodChannel(name: "com.pitel.flutter_pitel_voip/audio",
                                              binaryMessenger: controller.binaryMessenger)
        audioChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "enableAudio" {
                self.didActivateAudioSession(AVAudioSession.sharedInstance())
                result("Audio Enabled")
            } else if call.method == "disableAudio" {
                self.didDeactivateAudioSession(AVAudioSession.sharedInstance())
                result("Audio Disabled")
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Call back from Recent history
    override func application(_ application: UIApplication,
                              continue userActivity: NSUserActivity,
                              restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard let handleObj = userActivity.handle else {
            return false
        }
        
        guard let isVideo = userActivity.isVideo else {
            return false
        }
        let nameCaller = handleObj.getDecryptHandle()["nameCaller"] as? String ?? ""
        let handle = handleObj.getDecryptHandle()["handle"] as? String ?? ""
        let data = flutter_callkit_incoming_timer.Data(id: UUID().uuidString, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
        //set more data...
        data.nameCaller = "Johnny"
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.startCall(data, fromPushKit: true)
        
        return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
    
    // Handle updated push credentials
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
//        print(deviceToken)
        //Save deviceToken to your server
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("didInvalidatePushTokenFor")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }
    
    // Handle incoming pushes
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("didReceiveIncomingPushWith")
        guard type == .voIP else { return }
        
        // let id = payload.dictionaryPayload["uuid"] as? String ?? NSUUID().uuidString
        let nameCaller = payload.dictionaryPayload["nameCaller"] as? String ?? ""
        let handle = payload.dictionaryPayload["handle"] as? String ?? ""
        let isVideo = payload.dictionaryPayload["isVideo"] as? Bool ?? false
        
        let data = flutter_callkit_incoming_timer.Data(id: UUID().uuidString, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
        //set more data
        data.extra = ["user": "abc@123", "platform": "ios"]
//        data.iconName = ...
        //data.....
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)
    }
    
    // 1. Khi iOS kích hoạt Audio (Người dùng bấm nghe)
    func didActivateAudioSession(_ audioSession: AVAudioSession) {
        print("📢 [Native] iOS đã kích hoạt Audio Session")
        
        RTCAudioSession.sharedInstance().lockForConfiguration()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [.allowBluetooth, .allowBluetoothA2DP])
            try audioSession.setActive(true)
            
            // Report to WebRTC
            RTCAudioSession.sharedInstance().audioSessionDidActivate(audioSession)
            RTCAudioSession.sharedInstance().isAudioEnabled = true
            
            print("✅ [Native] Micro và Loa đã được cấu hình và bật thành công!")
        } catch {
            print("❌ [Native] Lỗi cấu hình Audio: \(error)")
        }
        RTCAudioSession.sharedInstance().unlockForConfiguration()
    }

    // 2. Khi cuộc gọi kết thúc
    func didDeactivateAudioSession(_ audioSession: AVAudioSession) {
        print("📢 [Native] iOS đã tắt Audio Session")
        
        RTCAudioSession.sharedInstance().lockForConfiguration()
        RTCAudioSession.sharedInstance().isAudioEnabled = false
        RTCAudioSession.sharedInstance().audioSessionDidDeactivate(audioSession)
        
        do {
            // Giải phóng hoàn toàn để các app khác dùng được mic/loa
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("❌ [Native] Lỗi khi giải phóng Audio: \(error)")
        }
        RTCAudioSession.sharedInstance().unlockForConfiguration()
    }
}
