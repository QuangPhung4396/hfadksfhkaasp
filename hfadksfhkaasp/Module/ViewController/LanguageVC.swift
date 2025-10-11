import UIKit
import GoogleMobileAds

class LanguageVC: BaseVC, UITableViewDelegate, UITableViewDataSource, SelectItem {

    var btnBack = UIButton()
    var tableView: UITableView = UITableView()
    var nativeView: UIView = UIView()
    var lbTitle = UILabel()
    var btnSelect: PButton = PButton()
    
    lazy private var data: [LanguageModel] = getLanguages()
    var language: LanguageModel? = nil
    var isSetting = false
    
    private var native: AdsNativeAd!
    
    public var nativeAd: Any? = nil {
        didSet { native.nativeAd = nativeAd as? NativeAd }
    }
    
    fileprivate var admobNative: AdmobNative?
    
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
        
        self.view.addSubview(lbTitle)
        self.lbTitle.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.lbTitle.textColor = UIColor.white
        self.lbTitle.text = UtilService.getText("subtitle_language")
        self.lbTitle.textAlignment = .center
        
        self.lbTitle.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.height.equalTo(56)
        }
        
        self.view.addSubview(nativeView)
        self.nativeView.backgroundColor = .clear
        
        self.nativeView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.height.equalTo(200)
        }
        
        self.view.addSubview(btnSelect)
        self.btnSelect.cornerRadius = 28
        self.btnSelect.backgroundColor = UIColor(rgb: 0x12CDD9)
        self.btnSelect.setTitleColor(UIColor.white, for: .normal)
        self.btnSelect.setTitle(UtilService.getText("watch_now"), for: .normal)
        self.btnSelect.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.btnSelect.addTarget(self, action: #selector(actionSelect), for: .touchUpInside)
        self.btnSelect.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(self.nativeView.snp.top).offset(-16)
            if isSetting {
                make.height.equalTo(0)
            } else {
                make.height.equalTo(56)
            }
        }
        
        self.view.addSubview(tableView)
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.bottom.equalTo(self.btnSelect.snp.top).offset(-16)
            make.top.equalTo(self.btnBack.snp.bottom).offset(0)
        }
        
        language = englishLanguage
        if let str = UserDefaults.standard.string(forKey: "subtitle-language-default") {
            language = instantiate(jsonString: str)
        }
        tableView.register(ChooseCell.self, forCellReuseIdentifier: "ChooseCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            let id = self.language?.id
            if let index = self.data.firstIndex(where: { $0.id == id }) {
                let indexPath = IndexPath(item: index, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
        }
        
        if isSetting {
            btnBack.isHidden = false
            btnSelect.isHidden = true
        } else {
            btnBack.isHidden = true
            btnSelect.isHidden = false
        }
        
        guard let nibObjects = Bundle.current.loadNibNamed("AdsNativeAd", owner: nil, options: nil),
              let adView = nibObjects.first as? AdsNativeAd else {
            return
        }
        
        adView.backgroundColor = .clear
        native = adView
        native.translatesAutoresizingMaskIntoConstraints = false
        self.nativeView.addSubview(native)
        native.leftAnchor.constraint(equalTo: self.nativeView.leftAnchor, constant: 0).isActive = true
        native.rightAnchor.constraint(equalTo: self.nativeView.rightAnchor, constant: 0).isActive = true
        native.topAnchor.constraint(equalTo: self.nativeView.topAnchor, constant: 0).isActive = true
        native.bottomAnchor.constraint(equalTo: self.nativeView.bottomAnchor, constant: 0).isActive = true
        
        admobNative = AdmobNative(numberOfAds: 1, nativeDidReceive: { [weak self] natives in
            if natives.first != nil {
                self?.nativeAd = natives.first
                self?.nativeView.isHidden = false
            }
        }, nativeDidFail: { error in
            self.nativeView.isHidden = true
        })
        admobNative?.preloadAd(controller: self)
        
    }

    @objc func actionBack(_ sender: Any) {
        self.backAction()
    }
    
    @objc func actionSelect(_ sender: Any) {
        let str = language!.toJSONString()
        UserDefaults.standard.set(str, forKey: "subtitle-language-default")
        UserDefaults.standard.synchronize()
        if isSetting {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.pushViewController(TabRootVC(), animated: true)
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCell") as! ChooseCell
        cell.setData(title: data[indexPath.row].name, index: indexPath.row, isSelected: data[indexPath.row].id == self.language?.id)
        cell.selectItem = self
        cell.selectionStyle = .none
        cell.contentView.isHidden = true
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func selectCell(indexSelect: Int, section: Int) {
        self.language = data[indexSelect]
        tableView.reloadData()
        if self.isSetting {
            let str = language.toJSONString()
            UserDefaults.standard.set(str, forKey: "subtitle-language-default")
            UserDefaults.standard.synchronize()
        }
    }
}
