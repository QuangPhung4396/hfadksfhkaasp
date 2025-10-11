import UIKit
import GoogleMobileAds

class AdsRewardIntertisal: NSObject {
    
    // MARK: - properties
  @objc public static let shared = AdsRewardIntertisal()
    private var _rewardedAd: RewardedInterstitialAd?
    private var _closeHandler: ((Bool) -> Void)?
  
    override init() {
        super.init()
    }

    var canShowAds: Bool {
        if AdsId.shared.admob_reward_interstitial.isEmpty {
            return false
        }
        return true
    }
    
    var isReady: Bool {
        return _rewardedAd != nil
    }
    
    func preloadAd(completion: @escaping (_ success: Bool) -> Void) {
        self._rewardedAd = nil
        
        guard canShowAds else {
            completion(false)
            return
        }
        
        let id = AdsId.shared.admob_reward_interstitial
        RewardedInterstitialAd.load(with: id, request: Request()) { ad, error in
            if ad != nil {
                self._rewardedAd = ad
                self._rewardedAd?.fullScreenContentDelegate = self
                completion(true)
            }
            else if error != nil {
                self._rewardedAd = nil
                completion(false)
            }
        }
    }
    
    func tryToPresentDidEarnReward(with handler: @escaping (Bool) -> Void) {
      let loadView = QLoading()
      loadView.setMessage("Loading ads...")
      loadView.show()
      self.preloadAd { success in
        loadView.dismiss()
        if success {
          guard let rootController = UIWindow.keyWindow?.topMost else {
              handler(false)
              return
          }
          
          if let presented = rootController.presentedViewController {
            self._closeHandler = handler
              self._rewardedAd?.present(from: presented, userDidEarnRewardHandler: {})
          } else {
            self._closeHandler = handler
              self._rewardedAd?.present(from: rootController, userDidEarnRewardHandler: {})
          }
        } else {
            handler(false)
        }
      }
    }
}

extension AdsRewardIntertisal: FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
      if let handler = self._closeHandler {
          handler(true)
          self._closeHandler = nil
      }
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      if let handler = self._closeHandler {
          handler(false)
          self._closeHandler = nil
      }
    }
    
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        
    }
    
    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        
    }
}
