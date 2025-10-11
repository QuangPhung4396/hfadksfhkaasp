import UIKit
import StoreKit
import SnapKit

class QTiViVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate var listIDCell: [String] = [
        HotCell.cellId,
        RecentCell.cellId,
        TrendingCell.cellId,
        HomeActorCell.cellId,
        TopRateCell.cellId
    ]
    
    var nowPlayingVM: QTVSVM = QTVSVM()
    var popularVM: QTVSVM = QTVSVM()
    var topRate: QTVSVM = QTVSVM()
    var popularPeopleVM: QPPVM = QPPVM()
    var listRecent: [TelevisionContinue] = [TelevisionContinue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(collectionView)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
        }

        collectionView.register(HotCell.self, forCellWithReuseIdentifier: HotCell.cellId)
        collectionView.register(RecentCell.self, forCellWithReuseIdentifier: RecentCell.cellId)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: TrendingCell.cellId)
        collectionView.register(TopRateCell.self, forCellWithReuseIdentifier: TopRateCell.cellId)
        collectionView.register(HomeActorCell.self, forCellWithReuseIdentifier: HomeActorCell.cellId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        nowPlayingVM.binData = {
            self.collectionView.reloadData()
        }
        nowPlayingVM.loadData(path: ListType.tvAiringToday.rawValue)
        
        popularVM.binData = {
            self.collectionView.reloadData()
        }
        popularVM.loadData(path: ListType.tvPopular.rawValue)
        
        topRate.binData = {
            self.collectionView.reloadData()
        }
        topRate.loadData(path: ListType.tvTopRated.rawValue)
        
        QTVGVM.shared.binData = {
            self.collectionView.reloadData()
        }
        
        popularPeopleVM.binData = {
            self.collectionView.reloadData()
        }
        popularPeopleVM.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listRecent = BookmarkService.shared.getListBookmark(type: .tvShowC) as! [TelevisionContinue]
        self.collectionView.reloadData()
    }
    
    private func watchTVShow(_ tvShowC: TelevisionContinue){
        self.loadView.show()
        
        let tvDetailVM = QTVDVM(id: tvShowC.id)
        tvDetailVM.binData = { [self] in
            let sessions = tvDetailVM.data?.seasons ?? []
            
            let seasonDetailVM = QTVSDVM(tvId: tvShowC.id, seasonNumber: tvShowC.ss!)
            seasonDetailVM.binData = {
                let seaEspisode = seasonDetailVM.data?.episodes ?? []
                BookmarkService.shared.addBookmark(data: tvShowC, type: .tvShowC)
                QNetworkLoad.shared.loadT(tvShowC.name, season: tvShowC.ss!, episode: tvShowC.epi!, imdb: tvShowC.imdb!) { [weak self] data in
                    guard let self = self else { return }
                    if data.count == 0 {
                        self.alertNotLink {
                            
                        }
                    
                        return
                    }
                    self.loadView.dismiss()
                    let player = PlayerVC()
                    player.type = .tv
                    player.name = tvShowC.name
                    player.tvId = tvShowC.id
                    player.data = data
                    player.imdbid = tvShowC.imdb!
                    player.season = tvShowC.ss!
                    player.episode = seaEspisode.filter{$0.episode_number == tvShowC.epi!}.first
                    player.seasons = sessions
                    player.episodes = seaEspisode
                    player.modalPresentationStyle = .fullScreen
                    self.present(player, animated: true)
                }
                
              }
            seasonDetailVM.loadData()
        }
        tvDetailVM.loadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listIDCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch listIDCell[indexPath.row] {
        case HotCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotCell.cellId, for: indexPath) as! HotCell
            cell.setData(sourceTV: popularVM.data)
            cell.selectItemTVBlock = { item in
                self.openDetail(item)
            }
            return cell
        case RecentCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentCell.cellId, for: indexPath) as! RecentCell
            cell.setData(sourceTV: listRecent)
            cell.selectItemTVBlock = { item in
                self.watchTVShow(item)
            }
            return cell
        case TrendingCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCell.cellId, for: indexPath) as! TrendingCell
            cell.setData(sourceTV: nowPlayingVM.data)
            cell.selectItemTVBlock = { item in
                self.openDetail(item)
            }
            cell.seeAllTVBlock = {
                self.openListMore(type: ListType.tvAiringToday)
            }
            return cell
        case TopRateCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRateCell.cellId, for: indexPath) as! TopRateCell
            cell.sourceTV = topRate.data
            cell.selectItemTVBlock = { item in
                self.openDetail(item)
            }
            cell.seeAllTVBlock = {
                self.openListMore(type: ListType.tvTopRated)
            }
            return cell
        case HomeActorCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeActorCell.cellId, for: indexPath) as! HomeActorCell
            cell.source = popularPeopleVM.data
            cell.onSelected = { item in
                self.openActorDetail(item.id)
            }
            
            cell.seeAllActor = { items in
                self.openListActor()
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var h: CGFloat = 0
        switch listIDCell[indexPath.row] {
        case HotCell.cellId:
            h = popularVM.getSizeData() == 0 ? 0 : HotCell.height
        case RecentCell.cellId:
            h = listRecent.count == 0 ? 0 : RecentCell.height
        case TrendingCell.cellId:
            h = nowPlayingVM.getSizeData() == 0 ? 0 : TrendingCell.height
        case TopRateCell.cellId:
            h = topRate.getSizeData() == 0 ? 0 : TopRateCell.height
        case HomeActorCell.cellId:
            h = popularPeopleVM.getSizeData() == 0 ? 0 : HomeActorCell.heigt
        default:
            h = 0
        }
        return .init(width: UIScreen.main.bounds.size.width, height: h)
    }

}
