import UIKit

class QListVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: -
    var btnBack = UIButton()
    var lbTitle = UILabel()
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var typeSelected: ListType = .mPopular
    var tvVM: QTVSVM = QTVSVM()
    var movieVM: QMVM = QMVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(lbTitle)
        self.lbTitle.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.lbTitle.textColor = UIColor.white
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
        
        collectionView.register(UINib(nibName: DataRateCell.cellId, bundle: nil), forCellWithReuseIdentifier: DataRateCell.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.cr.addFootRefresh {
            self.loadingIfNeed()
        }
        
        tvVM.binData = {
            self.collectionView.reloadData()
            self.collectionView.cr.endLoadingMore()
        }
        
        movieVM.binData = {
            self.collectionView.reloadData()
            self.collectionView.cr.endLoadingMore()
        }
        
        if typeSelected == .mPopular {
            self.lbTitle.text = UtilService.getText("popular_movies")
            movieVM.loadData(path: typeSelected.rawValue)
        } else if typeSelected == .mTopRated {
            self.lbTitle.text = UtilService.getText("top_rated_movies")
            movieVM.loadData(path: typeSelected.rawValue)
        } else if typeSelected == .tvAiringToday {
            self.lbTitle.text = UtilService.getText("airing_today")
            tvVM.loadData(path: typeSelected.rawValue)
        } else if typeSelected == .tvTopRated {
            self.lbTitle.text = UtilService.getText("top_rated_tv_show")
            tvVM.loadData(path: typeSelected.rawValue)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    fileprivate func loadingIfNeed() {
        if typeSelected == .mPopular {
            if movieVM.isLoading { return }
            movieVM.loadData(path: typeSelected.rawValue)
        } else if typeSelected == .mTopRated {
            if movieVM.isLoading { return }
            movieVM.loadData(path: typeSelected.rawValue)
        } else if typeSelected == .tvAiringToday {
            if tvVM.isLoading { return }
            tvVM.loadData(path: typeSelected.rawValue)
        } else if typeSelected == .tvTopRated {
            if tvVM.isLoading { return }
            tvVM.loadData(path: typeSelected.rawValue)
        }
    }
    
    @objc func actionBack(_ sender: Any) {
        self.backAction()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if typeSelected == .mPopular || typeSelected == .mTopRated {
            return movieVM.getSizeData()
        } else if typeSelected == .tvAiringToday || typeSelected == .tvTopRated {
            return tvVM.getSizeData()
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataRateCell.cellId, for: indexPath) as! DataRateCell
        if typeSelected == .mPopular || typeSelected == .mTopRated {
            cell.setData(movie: movieVM.data[indexPath.row])
        } else if typeSelected == .tvAiringToday || typeSelected == .tvTopRated {
            cell.setData(television: tvVM.data[indexPath.row])
        }
        return cell
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
        return .init(width: UIScreen.main.bounds.size.width/3 - 19, height: (UIScreen.main.bounds.size.width/3 - 19)*16/11)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if typeSelected == .mPopular || typeSelected == .mTopRated {
            self.openDetail(movieVM.data[indexPath.row])
        } else if typeSelected == .tvAiringToday || typeSelected == .tvTopRated {
            self.openDetail(tvVM.data[indexPath.row])
        }
    }
}
