import UIKit

class HomeActorCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    //MARK: -properties
    static let heigt: CGFloat = 178

    
    var btnSeeAll = UIButton()
    var lbTitle = UILabel()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    var seeAllActor: ((_ source: [People]) -> Void)?
    var onSelected: ((_ item: People) -> Void)?
    
    var source: [People] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.lbTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lbTitle.textColor = UIColor.white
        self.lbTitle.text = UtilService.getText("noteable_actors")
        self.collectionView.backgroundColor = UIColor.clear
        self.btnSeeAll.setTitle(UtilService.getText("see_more"), for: .normal)
        self.btnSeeAll.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.btnSeeAll.setTitleColor(UIColor(rgb: 0x12CDD9), for: .normal)
        self.btnSeeAll.addTarget(self, action: #selector(seeAllHandle), for: .touchUpInside)
        
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
            make.top.equalTo(self.lbTitle.snp.bottom).offset(0)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        collectionView.register(UINib(nibName: ActorItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: ActorItemCell.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func seeAllHandle() {
        seeAllActor?(source)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorItemCell.cellId, for: indexPath) as! ActorItemCell
        cell.setData(people: source[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelected?(source[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 110)
    }
}
