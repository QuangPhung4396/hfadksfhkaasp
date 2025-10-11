import UIKit

class DetailMoreLikeCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let height: CGFloat = 223
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    
    var source: [Movie] = [] {
        didSet {
            if (collectionview != nil) {
                collectionview.reloadData()
                if source.count == 0 {
                    lbTitle.isHidden = true
                    collectionview.isHidden = true
                } else {
                    lbTitle.isHidden = false
                    collectionview.isHidden = false
                }
            }
        }
    }
    
    var sourceTV: [Television] = [] {
        didSet {
            if (collectionview != nil) {
                collectionview.reloadData()
                if sourceTV.count == 0 {
                    lbTitle.isHidden = true
                    collectionview.isHidden = true
                } else {
                    lbTitle.isHidden = false
                    collectionview.isHidden = false
                }
            }
        }
    }
    
    var selectItemBlock: ((_ item: Movie) -> Void)?
    var selectItemTVBlock: ((_ item: Television) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionview.register(UINib(nibName: DataRateCell.cellId, bundle: nil), forCellWithReuseIdentifier: DataRateCell.cellId)
        collectionview.delegate = self
        collectionview.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        collectionView.deselectItem(at: indexPath, animated: true)
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 118, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataRateCell.cellId, for: indexPath) as! DataRateCell
        if self.source.count > 0 {
            cell.setData(movie: source[indexPath.row])
        } else if self.sourceTV.count > 0 {
            cell.setData(television: sourceTV[indexPath.row])
        }
        return cell
    }
    
}
