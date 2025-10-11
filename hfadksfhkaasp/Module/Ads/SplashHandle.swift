import UIKit

class SplashHandle: NSObject {
    private var _admobHandle = AdsSplash()
    var timeShowAds = 0
    // MARK: - initial
    static let shared = SplashHandle()
    
    func present(_ block: @escaping () -> Void) {
        var rewardSplash = false
        if DataObject.shared.extraFind("is_reward_splash") == nil {
            rewardSplash = false
        } else {
            rewardSplash = DataObject.shared.extraFind("is_reward_splash")!
        }
        
        var openSplash = false
        if DataObject.shared.extraFind("is_open_splash") == nil {
            openSplash = false
        } else {
            openSplash = DataObject.shared.extraFind("is_open_splash")!
        }

        if rewardSplash == true {
            AdsRewardIntertisal.shared.tryToPresentDidEarnReward { success in
                if (success) {
                    block()
                } else {
                    if openSplash {
                        AdsOpenHandle.shared.tryToPresent { isSuccess in
                            if (isSuccess) {
                                block()
                            } else {
                                self._admobHandle.tryToPresent { isSuccess in
                                    block()
                                }
                            }
                        }
                    } else {
                        self._admobHandle.tryToPresent { isSuccess in
                            block()
                        }
                    }
                    
                }
            }
        } else {
            if openSplash {
                AdsOpenHandle.shared.tryToPresent { isSuccess in
                    if (isSuccess) {
                        block()
                    } else {
                        self._admobHandle.tryToPresent { isSuccess in
                            block()
                        }
                    }
                }
            } else {
                self._admobHandle.tryToPresent { isSuccess in
                    block()
                }
            }
        }
    }
}
