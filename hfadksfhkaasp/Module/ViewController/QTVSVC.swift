import UIKit

class QTVSVC: BaseVC {
    // MARK: - properties
    fileprivate let listIDSeasonsCell: [String] = [
        DetailListSesonCell.cellId,
        DetailSesonCell.cellId
    ]
    
    fileprivate var sesonSelect: TelevisionSeason?
    fileprivate var tvDetailVM: IMDBVM?
    var tvId: Int = 0
    var name: String = ""
    var television: Television?
    var seasons: [TelevisionSeason] = []
    var seaEspisode: [Int: [TelevisionEpisode]] = [:]
    
    // MARK: - view model
    
    var mtableView: UITableView = UITableView()
    var btnBack = UIButton()
    var titleLabel = UILabel()
    
    fileprivate var seasonDetailVM: QTVSDVM!
    
    // MARK: - life cycle viewcontroller
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
        
        self.view.addSubview(titleLabel)
        self.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.text = "Seasons"
        self.titleLabel.textAlignment = .center
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.height.equalTo(56)
        }
        
        self.view.addSubview(mtableView)
        self.mtableView.backgroundColor = UIColor.clear
        self.mtableView.separatorStyle = .none
        self.mtableView.delegate = self
        self.mtableView.dataSource = self
        self.mtableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.top.equalTo(self.btnBack.snp.bottom).offset(0)
        }
        
        mtableView.register(UINib(nibName: DetailListSesonCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailListSesonCell.cellId)
        mtableView.register(UINib(nibName: DetailSesonCell.cellId, bundle: nil),
                           forCellReuseIdentifier: DetailSesonCell.cellId)
        
        self.sesonSelect = seasons[0]
        
        self.seasonDetailVM = QTVSDVM(tvId: tvId, seasonNumber: (self.sesonSelect?.season_number)!)
        self.seasonDetailVM?.binData = {
            self.mtableView.reloadData()
        }
        seasonDetailVM?.loadData()
        tvDetailVM = IMDBVM(id: tvId)
        tvDetailVM?.loadData()
        titleLabel.text = television?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: action
    @objc func actionBack(_ sender: Any) {
        self.backAction()
    }
    
}

extension QTVSVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch listIDSeasonsCell[indexPath.row] {
        case DetailListSesonCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailListSesonCell.cellId) as! DetailListSesonCell
            cell.source = seasons
            cell.sesonSelect = self.sesonSelect
            cell.selectSeason = { [self] season in
                self.loadView.setMessage("Please wait...")
                self.loadView.show()
                self.sesonSelect = season
                self.seasonDetailVM = QTVSDVM(tvId: tvId, seasonNumber: self.sesonSelect!.season_number!)
                self.seasonDetailVM?.binData = {
                    self.mtableView.reloadData()
                    self.loadView.dismiss()
                }
                self.seasonDetailVM?.loadData()
                self.mtableView.reloadData()
            }
            return cell
        case DetailSesonCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailSesonCell.cellId) as! DetailSesonCell
            cell.episodes = self.seasonDetailVM!.data == nil ? [] : (self.seasonDetailVM!.data!.episodes ?? [])
            cell.backdrop = television!.backdropURL
            cell.selectEpisode = { episode in
                self.watchTVShow(episode)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch listIDSeasonsCell[indexPath.row] {
        case DetailListSesonCell.cellId:
            return DetailListSesonCell.height
        case DetailSesonCell.cellId:
            return self.seasonDetailVM!.data == nil ? 0 : (self.seasonDetailVM!.data!.episodes?.count == 0 ? 0 : CGFloat(self.seasonDetailVM!.data!.episodes!.count*94 + 16))
        default:
            return UITableView.automaticDimension
        }
    }
    
    private func watchTVShow(_ episode: TelevisionEpisode){
        guard let season = self.sesonSelect,
              let detail = self.tvDetailVM,
              let dataT = television,
              let externalIds = detail.externalIds else { return }
        
        let name = dataT.name
        let ss = season.season_number ?? 0
        let epi = episode.episode_number ?? 0
        let imdb = externalIds.imdb_id ?? ""
        self.loadView.setMessage(UtilService.getText("please_wait"))
        self.loadView.show()
        QNetworkLoad.shared.loadT(name, season: ss, episode: epi, imdb: imdb) { [weak self] data in
            guard let self = self else { return }
            self.loadView.dismiss()
            if data.count == 0 {
                self.alertNotLink {
                    
                }
            
                return
            }
            
            let isShowReward: Bool? = DataObject.shared.extraFind("is_detail_reward")
            if isShowReward == nil {
                InterstitialHandle.shared.present() {
                    let tvShowC = TelevisionContinue(id: detail.id, name: name, backdrop_path: dataT.backdrop_path, poster_path: dataT.poster_path, ss: ss, epi: epi, imdb: imdb)
                    BookmarkService.shared.addBookmark(data: tvShowC, type: .tvShowC)
                    let player = PlayerVC()
                    player.type = .tv
                    player.name = name
                    player.tvId = self.tvId
                    player.data = data
                    player.imdbid = imdb
                    player.season = ss
                    player.episode = episode
                    player.seasons = self.seasons
                    player.episodes = self.seasonDetailVM!.data == nil ? [] : (self.seasonDetailVM!.data!.episodes ?? [])
                    player.modalPresentationStyle = .fullScreen
                    self.present(player, animated: true)
              }
            } else {
                if isShowReward! {
                    let alert = UIAlertController(title: title, message: "Watching an ad to watch TV Show", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    alert.addAction(UIAlertAction(title: "Watch ads", style: .default, handler: { _ in
                        AdsReward.shared.tryToPresentDidEarnReward { success in
                            let tvShowC = TelevisionContinue(id: detail.id, name: name, backdrop_path: dataT.backdrop_path, poster_path: dataT.poster_path, ss: ss, epi: epi, imdb: imdb)
                            BookmarkService.shared.addBookmark(data: tvShowC, type: .tvShowC)
                            
                            let player = PlayerVC()
                            player.type = .tv
                            player.name = name
                            player.tvId = self.tvId
                            player.data = data
                            player.imdbid = imdb
                            player.season = ss
                            player.episode = episode
                            player.seasons = self.seasons
                            player.episodes = self.seasonDetailVM!.data == nil ? [] : (self.seasonDetailVM!.data!.episodes ?? [])
                            player.modalPresentationStyle = .fullScreen
                            self.present(player, animated: true)
                        }
                    }))
                    self.present(alert, animated: true)
                } else {
                    InterstitialHandle.shared.present() {
                        let tvShowC = TelevisionContinue(id: detail.id, name: name, backdrop_path: dataT.backdrop_path, poster_path: dataT.poster_path, ss: ss, epi: epi, imdb: imdb)
                        BookmarkService.shared.addBookmark(data: tvShowC, type: .tvShowC)
                        
                        let player = PlayerVC()
                        player.type = .tv
                        player.name = name
                        player.tvId = self.tvId
                        player.data = data
                        player.imdbid = imdb
                        player.season = ss
                        player.episode = episode
                        player.seasons = self.seasons
                        player.episodes = self.seasonDetailVM!.data == nil ? [] : (self.seasonDetailVM!.data!.episodes ?? [])
                        player.modalPresentationStyle = .fullScreen
                        self.present(player, animated: true)
                    }
                }
            }
        }
    }
}
