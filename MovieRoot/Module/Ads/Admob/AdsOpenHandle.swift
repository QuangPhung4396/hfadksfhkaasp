import UIKit
import GoogleMobileAds

public class AdsOpenHandle: NSObject {
    
    // MARK: - properties
    private var _openAd: AppOpenAd?
    
    // MARK: - initial
    @objc public static let shared = AdsOpenHandle()
    
    override init() {
        super.init()
    }
    
    // MARK: - public
    public func preloadAd(completion: ((_ success: Bool) -> Void)?) {
        if self._openAd != nil {
            completion?(true)
        } else {
            let id = AdsId.shared.admob_appopen
            
            AppOpenAd.load(with: id, request: Request()) { ad, error in
                if ad != nil {
                    self._openAd = ad
                    self._openAd?.fullScreenContentDelegate = self
                    completion?(true)
                }
                else if error != nil {
                    self._openAd = nil
                    completion?(false)
                }
            }
        }
        
    }
    
    @objc public func tryToPresent(completion: ((_ success: Bool) -> Void)?) {
        let loadView = QLoading()
        loadView.setMessage("Loading ads...")
        loadView.show()
        self.preloadAd { success in
            loadView.dismiss()
            if success {
                self._openAd?.present(from: nil)
                completion?(true)
            } else {
                completion?(false)
            }
        }
    }
}

extension AdsOpenHandle: FullScreenContentDelegate {
    public func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        
    }
    
    public func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        self._openAd = nil
    }
    
    public func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self._openAd = nil
    }
    
    public func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        
    }
    
    public func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        
    }
}
