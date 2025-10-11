import UIKit

class QLoveVC: BaseVC, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var lineMovie: UIView!
    @IBOutlet weak var lineTV: UIView!
    
    var movies: [Movie] = []
    var tvShow: [Television] = []
    private var typeSelect = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: DataRateCell.cellId, bundle: nil),
                                      forCellWithReuseIdentifier: DataRateCell.cellId)
        collectionView.register(UINib(nibName: ActorItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: ActorItemCell.cellId)
        lineMovie.isHidden = false
        lineTV.isHidden = true
    }
    
    @IBAction func actionMovie(_ sender: Any) {
        self.movies = BookmarkService.shared.getListBookmark(type: .movie) as! [Movie]
        typeSelect = 0
        lineMovie.isHidden = false
        lineTV.isHidden = true
        self.collectionView.reloadData()
        self.checkEmpty()
    }
    
    @IBAction func actionTVShow(_ sender: Any) {
        self.tvShow = BookmarkService.shared.getListBookmark(type: .tvShow) as! [Television]
        typeSelect = 1
        lineMovie.isHidden = true
        lineTV.isHidden = false
        self.collectionView.reloadData()
        self.checkEmpty()
    }
    
    func checkEmpty(){
        if typeSelect == 0 {
            if movies.count == 0 {
                self.viewEmpty.isHidden = false
            } else {
                self.viewEmpty.isHidden = true
            }
        } else if typeSelect == 1 {
            if tvShow.count == 0 {
                self.viewEmpty.isHidden = false
            } else {
                self.viewEmpty.isHidden = true
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if typeSelect == 0 {
            return movies.count
        } else  {
            return tvShow.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if typeSelect == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataRateCell.cellId, for: indexPath) as! DataRateCell
            cell.setData(movie: movies[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataRateCell.cellId, for: indexPath) as! DataRateCell
            cell.setData(television: tvShow[indexPath.row])
            return cell
        }
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
        if typeSelect == 0 {
            self.openDetail(movies[indexPath.row])
        } else  {
            self.openDetail(tvShow[indexPath.row])
        }
    }
}
