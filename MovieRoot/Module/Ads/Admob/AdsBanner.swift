import UIKit
import GoogleMobileAds

public enum AdsBannerPosition {
    case top
    case bottom
}

public class AdsBanner: NSObject {
    private var _bannerView: BannerView!
    private var _loadHandler: ((_ size: CGSize, _ isSuccess: Bool) -> Void)?
    
    public init(loadHandler: ((_ size: CGSize, _ isSuccess: Bool) -> Void)?) {
        super.init()
        self._loadHandler = loadHandler
    }
    
    private func getFullWidthAdaptiveAdSize(_ view: UIView) -> AdSize {
        let frame = { () -> CGRect in
            if #available(iOS 11.0, *) {
                return view.frame.inset(by: view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        return currentOrientationAnchoredAdaptiveBanner(width: frame.size.width)
    }
    
    public func addToViewIfNeed(parent: UIView,
                                controller: UIViewController,
                                backgroundColor: UIColor = .white,
                                position: AdsBannerPosition = .bottom,
                                collapsible: Bool = false,
                                padding: CGFloat = 0)
    {
        if _bannerView != nil {
            _loadHandler?(.zero, false)
            return
        }
        
        _bannerView = BannerView(adSize: portraitInlineAdaptiveBanner(width: UIScreen.main.bounds.size.width))
        _bannerView.translatesAutoresizingMaskIntoConstraints = false
        _bannerView.backgroundColor = backgroundColor
        _bannerView.adUnitID = AdsId.shared.admob_banner
        _bannerView.adSize = currentOrientationAnchoredAdaptiveBanner(width: UIScreen.main.bounds.size.width)
        _bannerView.rootViewController = controller
        _bannerView.delegate = self
        if collapsible {
            let request = Request()
            let extras = Extras()
            if position == .bottom {
                extras.additionalParameters = ["collapsible" : "bottom"]
            } else {
                extras.additionalParameters = ["collapsible" : "top"]
            }
            request.register(extras)
            _bannerView.load(request)
        } else {
            _bannerView.load(Request())
        }
        parent.addSubview(_bannerView)
        _bannerView.leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
        _bannerView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        _bannerView.rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
        _bannerView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
    }
    
    public func removeFromSuperView() {
        if _bannerView != nil {
            _bannerView.removeFromSuperview()
        }
    }
}

extension AdsBanner: BannerViewDelegate {
    public func bannerViewDidReceiveAd(_ _bannerView: BannerView) {
        if let handler = _loadHandler {
            handler(_bannerView.frame.size, true)
            _bannerView.layoutIfNeeded()
        }
    }
    
    public func bannerView(_ _bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        removeFromSuperView()
        
        if let handler = _loadHandler {
            handler(.zero, false)
            _bannerView.layoutIfNeeded()
        }
    }
    
}
