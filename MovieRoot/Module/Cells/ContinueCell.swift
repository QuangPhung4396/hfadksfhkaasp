import UIKit

class ContinueCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImage.setImageBackground()
    }
    
    func setData(movie: MovieContinue) {
        posterImage.loadImage(url: movie.posterURL)
    }
    
    func setData(television: TelevisionContinue) {
        posterImage.loadImage(url: television.posterURL)
    }

}
