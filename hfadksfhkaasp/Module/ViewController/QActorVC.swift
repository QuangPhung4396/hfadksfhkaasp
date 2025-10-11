import UIKit
import CRRefresh

class QActorVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: -
    var btnBack = UIButton()
    var lbTitle = UILabel()
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate var peopleListVM: QPPVM = QPPVM()
    var listData: [Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(lbTitle)
        self.lbTitle.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.lbTitle.textColor = UIColor.white
        self.lbTitle.text = "Actor"
        self.lbTitle.textAlignment = .center
        
        self.lbTitle.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.height.equalTo(56)
        }
        
        self.view.addSubview(btnBack)
        self.btnBack.setImage(UIImage(named: "ic_back_movie"), for: .normal)
        self.btnBack.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        self.btnBack.snp.makeConstraints { make in
            make.top.leading.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.height.width.equalTo(56)
        }
        self.btnBack.addTarget(self, action: #selector(actionBack), for: .touchUpInside)
        
        self.view.addSubview(collectionView)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.top.equalTo(self.btnBack.snp.bottom).offset(0)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
        
        collectionView.register(UINib(nibName: ActorItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: ActorItemCell.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        peopleListVM.binData = {
            self.collectionView.reloadData()
            self.collectionView.cr.endLoadingMore()
        }
        peopleListVM.loadData()
        
        collectionView.cr.addFootRefresh {
            if self.peopleListVM.isLoading { return }
            self.peopleListVM.loadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func actionBack(_ sender: Any) {
        self.backAction()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.peopleListVM.getSizeData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.openActorDetail(self.peopleListVM.data[indexPath.row].id)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.bounds.size.width/3 - 19, height: (UIScreen.main.bounds.size.width/3 + 11))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorItemCell.cellId, for: indexPath) as! ActorItemCell
        cell.setData(people: self.peopleListVM.data[indexPath.row])
        cell.setCornerRadius(radius: (UIScreen.main.bounds.size.width/3 - 19)/2)
        return cell
    }
}

