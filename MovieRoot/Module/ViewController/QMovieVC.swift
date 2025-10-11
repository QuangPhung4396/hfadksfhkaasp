import UIKit
import StoreKit
import SnapKit

class QMovieVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate var listIDCell: [String] = [
        HotCell.cellId,
        RecentCell.cellId,
        TrendingCell.cellId,
        HomeActorCell.cellId,
        TopRateCell.cellId
    ]
    
    var nowPlayingVM: QMVM = QMVM()
    var popularVM: QMVM = QMVM()
    var topRatedVM: QMVM = QMVM()
    var popularPeopleVM: QPPVM = QPPVM()
    var listRecent: [MovieContinue] = [MovieContinue]()
    
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
        nowPlayingVM.loadData(path: ListType.mNowPlaying.rawValue)
        
        popularVM.binData = {
            self.collectionView.reloadData()
        }
        popularVM.loadData(path: ListType.mPopular.rawValue)
        
        topRatedVM.binData = {
            self.collectionView.reloadData()
        }
        topRatedVM.loadData(path: ListType.mTopRated.rawValue)
        
        QMGVM.shared.binData = {
            self.collectionView.reloadData()
        }
        
        popularPeopleVM.binData = {
            self.collectionView.reloadData()
        }
        popularPeopleVM.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listRecent = BookmarkService.shared.getListBookmark(type: .movieC) as! [MovieContinue]
        self.collectionView.reloadData()
    }
    
    func actionWatch(movieC: MovieContinue) {
        self.loadView.show()
        QNetworkLoad.shared.loadM(movieC.title, year: movieC.yearInt, imdb: movieC.imdb_id) { [weak self] data in
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
                    let player = PlayerVC()
                    player.type = .movie
                    player.name = movieC.title
                    player.data = data
                    player.imdbid = movieC.imdb_id
                    player.year = movieC.yearInt
                    player.modalPresentationStyle = .overFullScreen
                    self.present(player, animated: true)
                    BookmarkService.shared.addBookmark(data: movieC, type: .movieC)
              }
            } else {
                if isShowReward! {
                    let alert = UIAlertController(title: title, message: "Watching an ad to watch movie", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    alert.addAction(UIAlertAction(title: "Watch ads", style: .default, handler: { _ in
                        AdsReward.shared.tryToPresentDidEarnReward { success in
                            let player = PlayerVC()
                            player.type = .movie
                            player.name = movieC.title
                            player.data = data
                            player.imdbid = movieC.imdb_id
                            player.year = movieC.yearInt
                            player.modalPresentationStyle = .overFullScreen
                            self.present(player, animated: true)
                            BookmarkService.shared.addBookmark(data: movieC, type: .movieC)
                        }
                    }))
                    self.present(alert, animated: true)
                } else {
                    InterstitialHandle.shared.present() {
                        let player = PlayerVC()
                        player.type = .movie
                        player.name = movieC.title
                        player.data = data
                        player.imdbid = movieC.imdb_id
                        player.year = movieC.yearInt
                        player.modalPresentationStyle = .overFullScreen
                        self.present(player, animated: true)
                        BookmarkService.shared.addBookmark(data: movieC, type: .movieC)
                    }
                }
            }
        }
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
            cell.setData(source: nowPlayingVM.data)
            cell.selectItemBlock = { item in
                self.openDetail(item)
            }
            return cell
        case RecentCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentCell.cellId, for: indexPath) as! RecentCell
            cell.setData(source: listRecent)
            cell.selectItemBlock = { item in
                self.actionWatch(movieC: item)
            }
            return cell
        case TrendingCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCell.cellId, for: indexPath) as! TrendingCell
            cell.setData(source: popularVM.data)
            cell.selectItemBlock = { item in
                self.openDetail(item)
            }
            cell.seeAllBlock = {
                self.openListMore(type: ListType.mPopular)
            }
            return cell
        case TopRateCell.cellId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRateCell.cellId, for: indexPath) as! TopRateCell
            cell.source = topRatedVM.data
            cell.selectItemBlock = { item in
                self.openDetail(item)
            }
            cell.seeAllBlock = {
                self.openListMore(type: ListType.mTopRated)
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
            h = nowPlayingVM.getSizeData() == 0 ? 0 : HotCell.height
        case RecentCell.cellId:
            h = listRecent.count == 0 ? 0 : RecentCell.height
        case TrendingCell.cellId:
            h = popularVM.getSizeData() == 0 ? 0 : TrendingCell.height
        case TopRateCell.cellId:
            h = topRatedVM.getSizeData() == 0 ? 0 : TopRateCell.height
        case HomeActorCell.cellId:
            h = popularPeopleVM.getSizeData() == 0 ? 0 : HomeActorCell.heigt
        default:
            h = 0
        }
        return .init(width: UIScreen.main.bounds.size.width, height: h)
    }

}
