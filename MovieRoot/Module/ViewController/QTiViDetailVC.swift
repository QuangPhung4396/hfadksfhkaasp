import UIKit

class QTiViDetailVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var listIDTelevisionCell: [String] = [
        DetailInforCell.cellId,
        DetailIntroduceCell.cellId,
        DetailScenesCell.cellId,
        DetailTrailerCell.cellId,
        DetailMoreLikeCell.cellId
    ]
    
    var btnBack = UIButton()
    var viewBottom = UIView()
    var bannerView: UIView = UIView()
    var btnFavorite: UIButton = UIButton()
    var btnWatchNow: PButton = PButton()
    var tableView: UITableView = UITableView()
    
    var tvId: Int = 0
    var indexTab: Int = 0
    fileprivate var castSelected: Cast?
    fileprivate var collapsedOverview: Bool = true
    fileprivate var collapsedOverviewPeople: Bool = true
    fileprivate var collapsedOverviewActing: Bool = true
    
    fileprivate var televisionDetailVM: QTVDVM?
    fileprivate var televisionRecommendationVM: QTVRVM?
    fileprivate var peopleDetailVM: QPDVM?
    fileprivate var peopleCreditVM: QPCVM!
    fileprivate var seasonDetailVM: QTVSDVM!
    
    fileprivate var sesonSelect: TelevisionSeason?
    
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
        
        self.view.addSubview(bannerView)
        self.bannerView.backgroundColor = .clear
        
        self.bannerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.height.equalTo(56)
        }
        
        self.view.addSubview(viewBottom)
        self.viewBottom.backgroundColor = .clear
        
        self.viewBottom.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.height.equalTo(56)
            make.bottom.equalTo(self.bannerView.snp.top).offset(-16)
        }
        
        self.view.addSubview(tableView)
        self.tableView.backgroundColor = .clear
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.bottom.equalTo(self.viewBottom.snp.top).offset(-16)
            make.top.equalTo(self.btnBack.snp.bottom).offset(0)
        }
        
        self.viewBottom.addSubview(btnFavorite)
        self.btnFavorite.addTarget(self, action: #selector(actionFavorite), for: .touchUpInside)
        self.btnFavorite.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.btnFavorite.snp.makeConstraints { make in
            make.width.height.equalTo(56)
            make.leading.top.equalToSuperview().offset(0)
        }
        
        self.viewBottom.addSubview(btnWatchNow)
        self.btnWatchNow.cornerRadius = 28
        self.btnWatchNow.backgroundColor = UIColor(rgb: 0x12CDD9)
        self.btnWatchNow.setTitleColor(UIColor.white, for: .normal)
        self.btnWatchNow.setTitle(UtilService.getText("watch_now"), for: .normal)
        self.btnWatchNow.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.btnWatchNow.addTarget(self, action: #selector(actionWatch), for: .touchUpInside)
        self.btnWatchNow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview().offset(0)
            make.leading.equalTo(self.btnFavorite.snp.trailing).offset(8)
        }
        
        tableView.register(UINib(nibName: DetailInforCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailInforCell.cellId)
        tableView.register(UINib(nibName: DetailIntroduceCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailIntroduceCell.cellId)
        tableView.register(UINib(nibName: DetailScenesCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailScenesCell.cellId)
        tableView.register(UINib(nibName: DetailTrailerCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailTrailerCell.cellId)
        tableView.register(UINib(nibName: DetailMoreLikeCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailMoreLikeCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        televisionDetailVM = QTVDVM(id: tvId)
        televisionDetailVM!.binData = { [self] in
            if (self.televisionDetailVM!.data?.seasons!.count)! > 0 {
                self.sesonSelect = self.televisionDetailVM!.data?.seasons?[0]
                
                self.seasonDetailVM = QTVSDVM(tvId: tvId, seasonNumber: (self.sesonSelect?.season_number)!)
                self.seasonDetailVM?.binData = {
                    self.tableView.reloadData()
                }
                seasonDetailVM?.loadData()
                
            }
            self.tableView.reloadData()
        }
        televisionDetailVM!.loadData()
        
        televisionRecommendationVM = QTVRVM(id: tvId)
        televisionRecommendationVM?.binData = {
            self.tableView.reloadData()
        }
        televisionRecommendationVM?.loadData()
        self.loadBannerAds(banner: "banner_movie_detail", bannerMode: "banner_movie_detail_mode", bannerView: bannerView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if BookmarkService.shared.checkIsBookmark(id: tvId, type: .tvShow) {
            btnFavorite.setImage(UIImage(named: "ic_like"), for: .normal)
        } else {
            btnFavorite.setImage(UIImage(named: "ic_unlike"), for: .normal)
        }
    }
    
    @objc func actionBack() {
        self.backAction()
    }
    
    @objc func actionWatch() {
        if let television = self.televisionDetailVM?.data {
            let seasonController: QTVSVC = QTVSVC()
            seasonController.tvId = television.id
            seasonController.name = television.name
            seasonController.seasons = television.seasons ?? []
            seasonController.television = television
            navigationController?.pushViewController(seasonController, animated: true)
        }
    }
    
    @objc func actionFavorite() {
        if let tvshow = televisionDetailVM?.data as? Television {
            if BookmarkService.shared.checkIsBookmark(id: tvshow.id, type: .tvShow) {
                btnFavorite.setImage(UIImage(named: "ic_unlike"), for: .normal)
                BookmarkService.shared.deleteBookmark(item: tvshow, type: .tvShow)
                let alert = UIAlertController(title: UtilService.getText("notification"), message: UtilService.getText("remove_playlist_success"), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: UtilService.getText("ok"), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                if BookmarkService.shared.addBookmark(data: tvshow, type: .tvShow) {
                    btnFavorite.setImage(UIImage(named: "ic_like"), for: .normal)
                    let alert = UIAlertController(title: UtilService.getText("notification"), message: UtilService.getText("add_playlist_success"), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: UtilService.getText("ok"), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: UtilService.getText("notification"), message: UtilService.getText("add_playlist_failed"), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: UtilService.getText("ok"), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listIDTelevisionCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch listIDTelevisionCell[indexPath.row] {
        case DetailInforCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailInforCell.cellId) as! DetailInforCell
            cell.setData(television: televisionDetailVM?.data)
            return cell
        case DetailIntroduceCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailIntroduceCell.cellId) as! DetailIntroduceCell
            cell.isCollapsed = collapsedOverview
            cell.onChangedState = { collapsed in
                self.collapsedOverview = collapsed
                self.tableView.reloadData()
            }
            cell.overview = televisionDetailVM?.data == nil ? "" : televisionDetailVM!.data?.overview
            return cell
        case DetailScenesCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailScenesCell.cellId) as! DetailScenesCell
            cell.sourceTV = televisionDetailVM?.data?.images?.backdrops ?? []
            return cell
        case DetailTrailerCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTrailerCell.cellId) as! DetailTrailerCell
            cell.source = televisionDetailVM?.data?.videos?.results ?? []
            cell.onPlay = { video in
                self.openTrailer(self.televisionDetailVM!.data!, key: video.key)
            }
            return cell
        case DetailMoreLikeCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailMoreLikeCell.cellId) as! DetailMoreLikeCell
            cell.sourceTV = televisionRecommendationVM?.data ?? []
            cell.selectItemBlock = { movie in
                self.openDetail(movie)
            }
            
            cell.selectItemTVBlock = { tv in
                self.openDetail(tv)
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch listIDTelevisionCell[indexPath.row]{
        case DetailInforCell.cellId:
            return televisionDetailVM?.data == nil ? 0 : DetailInforCell.height
        case DetailIntroduceCell.cellId:
            return televisionDetailVM?.data == nil ? 0 : DetailIntroduceCell.height
        case DetailScenesCell.cellId:
            return (televisionDetailVM?.data == nil || ((televisionDetailVM?.data?.images?.backdrops ?? []).count == 0)) ? 0 : DetailScenesCell.height
        case DetailTrailerCell.cellId:
            return (televisionDetailVM?.data == nil || ((televisionDetailVM?.data?.videos!.results ?? []).count == 0)) ? 0 : DetailTrailerCell.height
        case DetailMoreLikeCell.cellId:
            return televisionRecommendationVM?.data.count == 0 ? 0 : DetailMoreLikeCell.height
        default:
            return UITableView.automaticDimension
        }
    }
}
