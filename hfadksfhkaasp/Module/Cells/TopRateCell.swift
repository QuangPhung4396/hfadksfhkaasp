import UIKit

class TopRateCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    static let height: CGFloat = 232

    var btnSeeAll = UIButton()
    var lbTitle = UILabel()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    var seeAllBlock: (() -> Void)?
    var selectItemBlock: ((_ item: Movie) -> Void)?
    
    var seeAllTVBlock: (() -> Void)?
    var selectItemTVBlock: ((_ item: Television) -> Void)?
    
    var source: [Movie] = [] {
        didSet {
            lbTitle.text = UtilService.getText("top_rated")
            collectionView.reloadData()
        }
    }
    
    var sourceTV: [Television] = [] {
        didSet {
            lbTitle.text = UtilService.getText("top_rated")
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        self.lbTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lbTitle.textColor = UIColor.white
        self.lbTitle.text = UtilService.getText("top_rated")
        self.collectionView.backgroundColor = UIColor.clear
        self.btnSeeAll.setTitle(UtilService.getText("see_more"), for: .normal)
        self.btnSeeAll.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.btnSeeAll.setTitleColor(UIColor(rgb: 0x12CDD9), for: .normal)
        self.btnSeeAll.addTarget(self, action: #selector(seeAll), for: .touchUpInside)
        
        self.addSubview(lbTitle)
        
        self.lbTitle.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(0)
            make.height.equalTo(32)
        }
        
        self.addSubview(btnSeeAll)
        
        self.btnSeeAll.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(32)
            make.width.equalTo(70)
        }
        self.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.lbTitle.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        collectionView.register(UINib(nibName: DataRateCell.cellId, bundle: nil), forCellWithReuseIdentifier: DataRateCell.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func seeAll(_ sender: Any) {
        if self.source.count > 0 {
            seeAllBlock?()
        } else if self.sourceTV.count > 0 {
            seeAllTVBlock?()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.source.count > 0 {
            return self.source.count
        } else if self.sourceTV.count > 0 {
            return self.sourceTV.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.source.count > 0 {
            selectItemBlock?(source[indexPath.row])
        } else if self.sourceTV.count > 0 {
            selectItemTVBlock?(sourceTV[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataRateCell.cellId, for: indexPath) as! DataRateCell
        if self.source.count > 0 {
            cell.setData(movie: self.source[indexPath.row])
        } else if self.sourceTV.count > 0 {
            cell.setData(television: self.sourceTV[indexPath.row])
        }
        return cell
    }

}
