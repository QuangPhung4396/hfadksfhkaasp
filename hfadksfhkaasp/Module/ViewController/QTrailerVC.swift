import UIKit
import WebKit
import SnapKit

class QTrailerVC: BaseVC, WKNavigationDelegate{

    var key: String?
    var movie: Movie?
    var tele: Television?
    
    // MARK: - outlets
    var playYoutubeView: WKWebView = WKWebView()
    var btnBack = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(btnBack)
        self.btnBack.setImage(UIImage(named: "ic_back_movie"), for: .normal)
        self.btnBack.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        self.btnBack.snp.makeConstraints { make in
            make.top.leading.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.height.width.equalTo(56)
        }
        self.btnBack.addTarget(self, action: #selector(actionBack), for: .touchUpInside)
        self.view.addSubview(playYoutubeView)
        self.playYoutubeView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.top.equalTo(self.btnBack.snp.bottom).offset(0)
        }
        playYoutubeView.navigationDelegate = self
        loadYoutube(key: key)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.backAction()
    }
    func loadYoutube(key: String?) {
        
        guard let key = key else {
            return
        }
        guard let url = URL(string: "https://youtube.com/embed/\(key)") else { return  }
        
        let requestObj = URLRequest(url: url)
        playYoutubeView.load(requestObj)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in
            
            if html != nil {
                if "\(html!)".contains("UNPLAYABLE") {
                    let alert = UIAlertController(title: UtilService.getText("notification"), message: UtilService.getText("the_trailer_does_not_exists"), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: UtilService.getText("ok"), style: .default, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
}
