import UIKit
import GoogleMobileAds

enum ListType: String {
    case mPopular = "movie/popular"
    case mNowPlaying = "movie/now_playing"
    case mTopRated = "movie/top_rated"
    case tvAiringToday = "tv/airing_today"
    case tvPopular = "tv/popular"
    case tvTopRated = "tv/top_rated"
}

enum GenreType {
    case movie
    case television
}

class BaseVC: UIViewController {
    
    var admodBanner: AdsBanner?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    let loadView = QLoading()
    
    // MARK: - life cycle viewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadView.setMessage(UtilService.getText("loading_ads"))
        self.view.backgroundColor = UIColor(rgb: 0x1F1D2B)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func loadBannerAds(banner: String, bannerMode: String, bannerView: UIView, heightContrains: NSLayoutConstraint? = nil){
        var banner: Bool? = DataObject.shared.extraFind(banner)
        banner = true
        if banner != nil {
            if banner == true {
                var bannerMode: Bool? = DataObject.shared.extraFind(bannerMode)
                bannerMode = true
                admodBanner = AdsBanner { size, isSuccess in
                    if isSuccess {
                        if heightContrains != nil {
                            heightContrains!.constant = size.height
                        } else {
                            bannerView.snp.updateConstraints { make in
                                make.height.equalTo(size.height)
                            }
                        }
                        bannerView.layoutIfNeeded()
                    } else {
                        if heightContrains != nil {
                            heightContrains!.constant = 0
                        } else {
                            bannerView.snp.updateConstraints { make in
                                make.height.equalTo(0)
                            }
                        }
                        bannerView.layoutIfNeeded()
                    }
                }
                if bannerMode != nil {
                    if bannerMode == true {
                        admodBanner!.addToViewIfNeed(parent: bannerView, controller: self, position: .bottom, collapsible: bannerMode!)
                    } else {
                        admodBanner!.addToViewIfNeed(parent: bannerView, controller: self, position: .bottom)
                    }
                } else {
                    admodBanner!.addToViewIfNeed(parent: bannerView, controller: self, position: .bottom)
                }
            } else {
                if heightContrains != nil {
                    heightContrains!.constant = 0
                } else {
                    bannerView.snp.updateConstraints { make in
                        make.height.equalTo(0)
                    }
                }
                bannerView.layoutIfNeeded()
            }
        } else {
            if heightContrains != nil {
                heightContrains!.constant = 0
            } else {
                bannerView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            }
            bannerView.layoutIfNeeded()
        }
    }
}

// MARK: - public
extension BaseVC {
    
    func backAction(){
        if DataObject.shared.extraFind("back_inter") == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            InterstitialHandle.shared.tryToPresent() {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func openDetail(_ movie: Movie) {
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }

            let movieDetail = QMovieDetailVC()
            movieDetail.movieId = movie.id
            movieDetail.movieName = movie.title
            movieDetail.movieModel = movie
            navi.pushViewController(movieDetail, animated: true)
        }
    }

    func openDetail(_ tele: Television) {
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let teleDetail = QTiViDetailVC()
            teleDetail.tvId = tele.id
            navi.pushViewController(teleDetail, animated: true)
        }
    }

    func openListActor() {
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let actorDetail = QActorVC()
            navi.pushViewController(actorDetail, animated: true)
        }
    }

    func openActorDetail(_ personID: Int) {
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let actorDetail = QActorDetailVC()
            actorDetail.actorId = personID
            navi.pushViewController(actorDetail, animated: true)
        }
    }

    func openListMore(type: ListType){
        InterstitialHandle.shared.tryToPresent() {
            guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            
            let moreListDetail = QListVC()
            moreListDetail.typeSelected = type
            navi.pushViewController(moreListDetail, animated: true)
        }
    }

    func openTrailer(_ movie: Movie, key: String) {
        guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
            return
        }

        let playYoutube: QTrailerVC = QTrailerVC()
        playYoutube.key = key
        playYoutube.movie = movie
        navi.pushViewController(playYoutube, animated: true)
    }

    func openTrailer(_ tele: Television, key: String) {
        guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
            return
        }
        
        let playYoutube: QTrailerVC = QTrailerVC()
        playYoutube.key = key
        playYoutube.tele = tele
        navi.pushViewController(playYoutube, animated: true)
    }
    
}
