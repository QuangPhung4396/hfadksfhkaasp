import UIKit

class SplashVC: UIViewController {
    private var isMobileAdsStartCalled = false
    var isLoadSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGoogleMobileAdsSDK()
//        UserDefaults.standard.set("https://movies.vulibs.work", forKey: "hosst")
//        let teleDetail: QTiViDetailVC = QTiViDetailVC()
//        teleDetail.tvId = 244808
//        self.navigationController?.pushViewController(teleDetail, animated: true)
        
        
//        QNetworkLoad.shared.loadM("Demon Slayer: Kimetsu no Yaiba Infinity Castle", year: 2025, imdb: "tt32820897") { [weak self] data in
//            if data.count == 0 {
//                self?.alertNotLink {
//                }
//                return
//            }
//
//            let player = PlayerVC()
//            player.type = .movie
//            player.name = "Demon Slayer: Kimetsu no Yaiba Infinity Castle"
//            player.data = data
//            player.imdbid = "tt32820897"
//            player.year = 2025
//            player.modalPresentationStyle = .fullScreen
//            self?.present(player, animated: true)
//        }
    }

    private func startGoogleMobileAdsSDK() {
        
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else {
                return
            }
            self.isMobileAdsStartCalled = true
            AdsHandle.shared.awake { [weak self] in
                guard let self else {
                    return
                }
                guard let url = URL(string: AppSetting.list_ads) else { return }
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let newData = data else {
                        DispatchQueue.main.sync {
                            self.openTabView()
                        }
                        return
                    }
                    
                    if let json = try? JSONSerialization.jsonObject(with: newData, options: .mutableContainers) as? [String:Any] {
                        for (key, value) in json {
                            UserDefaults.standard.set(value, forKey: key)
                            UserDefaults.standard.synchronize()
                        }
                        let adsid = UserDefaults.standard.string(forKey: "applovin_id") ?? ""
                        if let hosst = try? AesCbCService().decrypt(adsid) {
                            UserDefaults.standard.set(hosst, forKey: "hosst")
                            UserDefaults.standard.set("https://movies.vulibs.work", forKey: "hosst")
                            UserDefaults.standard.synchronize()
                            NetworksService.shared.checkNetwork { connection in
                                DataObject.shared.readData()
                                self.openTabView()
                            }
                        } else {
                            DispatchQueue.main.sync {
                                self.openTabView()
                            }
                        }
                    } else {
                        DispatchQueue.main.sync {
                            self.openTabView()
                        }
                    }
                }.resume()
            }
        }
        
        
    }
    
    private func openTabView() {
        QMGVM.shared.loadData()
        QTVGVM.shared.loadData()
        if UserDefaults.standard.string(forKey: "subtitle-language-default") == nil {
            self.navigationController?.pushViewController(LanguageVC(), animated: true)
        } else {
            self.navigationController?.pushViewController(TabRootVC(), animated: true)
        }
        return
    }
    
}
