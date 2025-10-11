import UIKit

class DetailTrailerItemCell: UICollectionViewCell {

    @IBOutlet weak var imageTrailer: PImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(video: Video){
        imageTrailer.loadImage(url: video.youtubeThumbnailURL)
    }
    
}
