import UIKit
import GoogleMobileAds

class AdsNativeAd: NativeAdView {
    
    @IBOutlet weak var lblAds: UILabel!
    @IBOutlet weak var viewLbAds: PView!
    @IBOutlet weak var viewCallToAction: PView!
    @IBOutlet weak var viewAds: UIView!
    @IBOutlet weak var viewBgads: UIView!
    @IBOutlet weak var lbBody: UILabel!
    
    public override var nativeAd: NativeAd? {
        didSet {
            guard nativeAd != nil else { return }
            self.viewAds.isHidden = false
            self.viewBgads.isHidden = false
            (self.headlineView as? UILabel)?.text = nativeAd!.headline
            self.lbBody.text = nativeAd!.body
            self.mediaView?.mediaContent = nativeAd!.mediaContent
            if let mediaView = self.mediaView, nativeAd!.mediaContent.aspectRatio > 0 {
                self.mediaView?.isHidden = false
                self.iconView?.isHidden = true
            } else {
                self.iconView?.isHidden = false
                self.mediaView?.isHidden = true
                (self.iconView as? UIImageView)?.image = nativeAd!.icon?.image
                self.iconView?.layer.cornerRadius = 5
                self.iconView?.layer.masksToBounds = true
            }
            
            (self.callToActionView as? UIButton)?.setTitle(nativeAd!.callToAction, for: .normal)
            self.callToActionView?.isHidden = nativeAd!.callToAction == nil
            self.viewCallToAction?.isHidden = nativeAd!.callToAction == nil
            self.callToActionView?.isUserInteractionEnabled = false
            
            self.viewLbAds?.isHidden = false
            self.lblAds?.layer.cornerRadius = 0;
            self.lblAds?.layer.masksToBounds = true
            self.backgroundColor = UIColor.clear
        }
    }
    
    public static var height: CGFloat {
        return 236
    }
}
