import UIKit
import GoogleMobileAds

class AdsInterstitial: BaseInterstitial {
    
    // MARK: - properties
    private var _interstitial: InterstitialAd?
    private var _closeHandler: ((Bool) -> Void)?
    
    // MARK: - initial
    override init() {
        super.init()
    }
    
    // MARK: - override from supper
    override var canShowAds: Bool {
        if AdsId.shared.admob_inter.isEmpty {
            return false
        }
        
        return true
    }
    
    override func preloadAd(completion: @escaping (Bool) -> Void) {
        self._interstitial = nil
        
        guard canShowAds else {
            completion(false)
            return
        }
        
        let id = AdsId.shared.admob_inter
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
        
        let loadView = QLoading()
        loadView.setMessage("Loading ads...")
        loadView.show()
        
        self.preloadAd { isSuccess in
            loadView.dismiss()
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

extension AdsInterstitial: FullScreenContentDelegate {
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
