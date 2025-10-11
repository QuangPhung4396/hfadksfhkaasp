import UIKit

protocol SettingVideoDelegate {
    func selectTransleteLanguage()
    func lockScreen()
    func selectSpeed()
    func selectSwitch(isOn: Bool)
}
class SettingVideoPopupVC: UIViewController {
    
    var btnOut = UIButton()
    var btnClose = UIButton()
    var viewContent = PView()
    var lbTitle = UILabel()
    var viewSetting = UIView()
    
    var viewSpeed = UIView()
    var imageSpeed = UIImageView()
    var lbSpeed = UILabel()
    var lbSpeedValue: UILabel = UILabel()
    
    var viewCaption = UIView()
    var imageCaption = UIImageView()
    var lbCaption = UILabel()
    
    var viewLock = UIView()
    var imageLock = UIImageView()
    var lbLock = UILabel()
    var switchView: UISwitch = UISwitch()
    
    var viewLanguage = UIView()
    var imageLanguage = UIImageView()
    var lbLanguage = UILabel()
    var lbLanguageValue: UILabel = UILabel()
    
    
    var language: LanguageModel? = nil
    var delegate: SettingVideoDelegate?
    var speed: Double = 1
    var isShowCap = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lbTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lbTitle.textColor = UIColor.white
        self.lbTitle.text = "Setting"
        
        self.viewContent.backgroundColor = UIColor(rgb: 0x1F1D2B)
        self.viewContent.cornerRadius = 24
        
        self.viewSetting.backgroundColor = UIColor.clear
        self.viewSpeed.backgroundColor = UIColor.clear
        self.viewCaption.backgroundColor = UIColor.clear
        self.viewLock.backgroundColor = UIColor.clear
        self.viewLanguage.backgroundColor = UIColor.clear
        
        self.btnClose.setImage(UIImage(named: "ic_qback_player"), for: .normal)
        
        imageLanguage.image = UIImage(named: "ic_language_sub")
        self.lbLanguage.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lbLanguage.textColor = UIColor.white
        self.lbLanguage.text = "Subtitle language"
        self.lbLanguageValue.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lbLanguageValue.textColor = UIColor.white
        
        imageLock.image = UIImage(named: "ic-lock")
        self.lbLock.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lbLock.textColor = UIColor.white
        self.lbLock.text = "Lock screen"
        
        imageCaption.image = UIImage(named: "ic-subtitle")
        self.lbCaption.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lbCaption.textColor = UIColor.white
        self.lbCaption.text = "Caption"
        
        imageSpeed.image = UIImage(named: "ic_speed")
        self.lbSpeed.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lbSpeed.textColor = UIColor.white
        self.lbSpeed.text = "Playback speed"
        self.lbSpeedValue.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lbSpeedValue.textColor = UIColor.white
        
        self.view.addSubview(btnOut)
        self.view.addSubview(viewContent)
        self.viewContent.addSubview(lbTitle)
        self.viewContent.addSubview(btnClose)
        self.viewContent.addSubview(viewSetting)
        
        self.viewSetting.addSubview(viewSpeed)
        self.viewSpeed.addSubview(imageSpeed)
        self.viewSpeed.addSubview(lbSpeed)
        self.viewSpeed.addSubview(lbSpeedValue)
        
        self.viewSetting.addSubview(viewCaption)
        self.viewCaption.addSubview(imageCaption)
        self.viewCaption.addSubview(lbCaption)
        self.viewCaption.addSubview(switchView)
        
        self.viewSetting.addSubview(viewLock)
        self.viewLock.addSubview(lbLock)
        self.viewLock.addSubview(imageLock)
        
        self.viewSetting.addSubview(viewLanguage)
        self.viewLanguage.addSubview(imageLanguage)
        self.viewLanguage.addSubview(lbLanguage)
        self.viewLanguage.addSubview(lbLanguageValue)
        
        
        self.btnOut.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview().offset(0)
        }
        
        self.viewContent.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(120)
            make.height.equalTo(230)
            make.centerY.centerX.equalToSuperview()
        }
        
        self.lbTitle.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(0)
            make.height.equalTo(40)
        }
        
        self.btnClose.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.lbTitle.snp.centerY).offset(0)
            make.height.width.equalTo(24)
        }
        
        self.viewSetting.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.bottom.equalToSuperview().offset(-16)
            make.top.equalTo(self.lbTitle.snp.bottom).offset(0)
        }
        
        self.viewSpeed.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().offset(0)
            make.height.equalTo(40)
        }
        
        self.imageSpeed.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview().offset(0)
            make.height.width.equalTo(24)
        }
        
        self.lbSpeedValue.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().offset(0)
        }
        
        self.lbSpeed.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().offset(0)
            make.leading.equalTo(self.imageSpeed.snp.trailing).offset(16)
        }

        self.viewCaption.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(0)
            make.height.equalTo(40)
            make.top.equalTo(self.viewSpeed.snp.bottom).offset(0)
        }
        
        self.imageCaption.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview().offset(0)
            make.height.width.equalTo(24)
        }
        
        self.lbCaption.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().offset(0)
            make.leading.equalTo(self.imageCaption.snp.trailing).offset(16)
        }
        
        self.viewLock.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(0)
            make.height.equalTo(40)
            make.top.equalTo(self.viewCaption.snp.bottom).offset(0)
        }
        
        self.imageLock.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview().offset(0)
            make.height.width.equalTo(24)
        }
        
        self.switchView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().offset(0)
        }
        
        self.lbLock.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().offset(0)
            make.leading.equalTo(self.imageLock.snp.trailing).offset(16)
            make.trailing.equalTo(self.switchView.snp.leading).offset(0)
        }
        
        self.viewLanguage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(0)
            make.height.equalTo(40)
            make.top.equalTo(self.viewLock.snp.bottom).offset(0)
        }
        
        self.imageLanguage.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview().offset(0)
            make.height.width.equalTo(24)
        }
        
        self.lbLanguageValue.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().offset(0)
        }
        
        self.lbLanguage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().offset(0)
            make.leading.equalTo(self.imageLanguage.snp.trailing).offset(16)
            make.trailing.equalTo(self.lbLanguageValue.snp.leading).offset(0)
        }
        
        self.btnOut.addTarget(self, action: #selector(actionDismiss), for: .touchUpInside)
        self.btnClose.addTarget(self, action: #selector(actionDismiss), for: .touchUpInside)
        
        self.viewLanguage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionLanguage)))
        self.viewSpeed.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionSpeed)))
        self.viewLock.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionLockScreen)))
        
        lbLanguageValue.text = language?.name
        lbSpeedValue.text = "\(speed)x"
        switchView.isOn = isShowCap
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)

    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        let isOn = sender.isOn
        if(delegate != nil) {
            delegate?.selectSwitch(isOn: isOn)
        }
    }
    
    @objc func actionLanguage(_ sender: Any) {
        self.dismiss(animated: true)
        
        if(delegate != nil) {
            delegate?.selectTransleteLanguage()
        }
    }
    
    @objc func actionLockScreen(_ sender: Any) {
        self.dismiss(animated: true)
        
        if(delegate != nil) {
            delegate?.lockScreen()
        }
    }
    
    @objc func actionSpeed(_ sender: Any) {
        self.dismiss(animated: true)
        
        if(delegate != nil) {
            delegate?.selectSpeed()
        }
    }
    
    @objc func actionDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
