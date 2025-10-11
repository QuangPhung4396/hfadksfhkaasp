import UIKit
import SnapKit

class ServerPopupVC: UIViewController {
    
    var btnOut = UIButton()
    var btnClose = UIButton()
    var viewContent = PView()
    var lbTitle = UILabel()
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var list: [ContentDetail] = []
    var serverPopupBlock: ((_ data: LinkVideo, _ tracks: [Subtitle]) -> Void)? = nil
    var urlSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lbTitle.textColor = UIColor.white
        self.lbTitle.text = "Select servers"
        
        self.viewContent.backgroundColor = UIColor(rgb: 0x1F1D2B)
        self.viewContent.cornerRadius = 24
        
        self.collectionView.backgroundColor = UIColor.clear
        
        self.btnClose.setImage(UIImage(named: "ic_qback_player"), for: .normal)
        
        self.view.addSubview(btnOut)
        self.view.addSubview(viewContent)
        self.viewContent.addSubview(lbTitle)
        self.viewContent.addSubview(btnClose)
        self.viewContent.addSubview(collectionView)
        
        self.btnOut.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview().offset(0)
        }
        
        self.viewContent.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(120)
            make.height.equalTo(250)
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
        
        self.collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.bottom.equalToSuperview().offset(-16)
            make.top.equalTo(self.lbTitle.snp.bottom).offset(0)
        }
        
        self.btnOut.addTarget(self, action: #selector(actionDismiss), for: .touchUpInside)
        self.btnClose.addTarget(self, action: #selector(actionDismiss), for: .touchUpInside)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TransleteCell.self, forCellWithReuseIdentifier: "TransleteCell")
        collectionView.reloadData()
    }

    @objc func actionDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension ServerPopupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return list.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list[section].sources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransleteCell", for: indexPath) as! TransleteCell
        let  fileServerModel = list[indexPath.section].sources[indexPath.row]
        let isSelected = fileServerModel.file == urlSelected
        cell.lb.text = fileServerModel.title
        cell.iv.isHidden = !isSelected
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let  fileServerModel = list[indexPath.section].sources[indexPath.row]
        if(serverPopupBlock != nil) {
            serverPopupBlock!(fileServerModel, self.list[indexPath.section].tracks)
        }
        
        self.dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}
