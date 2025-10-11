import UIKit
import GoogleMobileAds

class AdsSplash: BaseInterstitial {
    
    // MARK: - properties
    private var _interstitial: InterstitialAd?
    private var _closeHandler: ((Bool) -> Void)?
    
    // MARK: - initial
    override init() {
        super.init()
    }
    
    
    override func preloadAd(completion: @escaping (Bool) -> Void) {
        self._interstitial = nil
        
        let id = AdsId.shared.admob_inter_splash
        InterstitialAd.load(with: id, request: Request()) { ad, error in
            if ad != nil {
                self._interstitial = ad
                self._interstitial?.fullScreenContentDelegate = self
                completion(true)
            }
            else {
                self._interstitial = nil
                if error != nil {
                }
                completion(false)
            }
        }
    }
    
    func tryToPresent(with closeHandler: @escaping (Bool) -> Void) {
        self._closeHandler = nil
        guard let rootController = UIWindow.keyWindow?.topMost else {
            closeHandler(false)
            return
        }
        self.preloadAd { isSuccess in
            if isSuccess {
                self._closeHandler = closeHandler
                if let presented = rootController.presentedViewController {
                    self._interstitial?.present(from: presented)
                } else {
                    self._interstitial?.present(from: rootController)
                }
            } else {
                closeHandler(false)
            }
        }
    }
}

extension AdsSplash: FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        
    }
    
    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        if let handler = self._closeHandler {
            handler(true)
            self._closeHandler = nil
        }
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        if let handler = self._closeHandler {
            handler(true)
            self._closeHandler = nil
        }
    }
    
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        
    }
    
    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        
    }
}
