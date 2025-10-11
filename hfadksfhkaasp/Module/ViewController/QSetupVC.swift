import UIKit

class QSetupVC: BaseVC{
   
    @IBOutlet weak var lbSub: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var language: LanguageModel? = englishLanguage
        if let str = UserDefaults.standard.string(forKey: "subtitle-language-default") {
            language = instantiate(jsonString: str)
        }
        lbSub.text = language!.name
    }
    
    @IBAction func subtitleLanguage(_ sender: Any) {
        let vc = LanguageVC()
        vc.isSetting = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func rateApp(_ sender: Any) {
        UtilService.openRateApp()
    }
    
    @IBAction func policyApp(_ sender: Any) {
        UtilService.openURL(URL(string: AppSetting.privacy)!, controller: self)
    }
    
    @IBAction func sendFeedback(_ sender: Any) {
        UtilService().writeEmail(controller: self)
    }
    
    @IBAction func shareApp(_ sender: Any) {
        guard let url = URL(string: "https://apps.apple.com/us/app/id\(AppSetting.id)") else { return }
        let objectsToShare: [Any] = ["", url]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
}
