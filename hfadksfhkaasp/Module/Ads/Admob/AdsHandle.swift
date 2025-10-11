import UIKit
import GoogleMobileAds

public class AdsHandle: NSObject {
    
    // MARK: - properties
    private var _isReady = false
    
    var isReady: Bool {
        return _isReady
    }
    
    @objc public var idsTest: [String] = []
    
    // MARK: - initial
    @objc public static let shared = AdsHandle()
    
    // MARK: private
    
    // MARK: public
    @objc public func awake(completion: @escaping () -> Void) {
        var ids: [String] = idsTest
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = ids
        
        MobileAds.shared.start { _ in
            self._isReady = true
            completion()
        }
    }
}
