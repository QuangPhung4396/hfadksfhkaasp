import UIKit
import GoogleMobileAds

class AdmobNative: NSObject {
    
    // MARK: - properties
    private var _numberOfAds: Int = 0
    private (set) var _nativeAds: [NativeAd] = []
    private var _adLoader: AdLoader?
    
    fileprivate var _nativeDidReceive: ((_ natives: [NativeAd]) -> Void)!
    fileprivate var _nativeDidFail: ((_ error: Error?) -> Void)!
    
    // MARK: - initial
    init(numberOfAds: Int,
         nativeDidReceive: @escaping ((_ natives: [NativeAd]) -> Void),
         nativeDidFail: @escaping ((_ error: Error?) -> Void))
    {
        self._numberOfAds = numberOfAds
        self._nativeDidReceive = nativeDidReceive
        self._nativeDidFail = nativeDidFail
        self._nativeAds.removeAll()
    }
    
    // MARK: -
    var canShowAds: Bool {
        if AdsId.shared.admob_manual_native.isEmpty {
            return false
        }
        
        if _adLoader != nil {
            return false
        }
        
        if _numberOfAds <= 0 {
            return false
        }
        
        return true
    }
    
    // MARK: public
    func preloadAd(controller: UIViewController) {
        guard canShowAds else {
            _nativeDidFail(nil)
            return
        }
        
        let muiltiOption = MultipleAdsAdLoaderOptions()
        muiltiOption.numberOfAds = _numberOfAds
        
        let id = AdsId.shared.admob_manual_native
        _adLoader = AdLoader(adUnitID: id, rootViewController: controller, adTypes: [.native], options: [muiltiOption])
        _adLoader?.delegate = self
        _adLoader?.load(Request())
    }
}

extension AdmobNative: NativeAdLoaderDelegate {
    func adLoaderDidFinishLoading(_ adLoader: AdLoader) {
        _nativeDidReceive(_nativeAds)
    }
    
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        _nativeAds.append(nativeAd)
    }
    
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        _nativeDidFail(error)
    }
}
