import UIKit

class DataRateCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var lbVote: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImage.setImageBackground()
    }
    
    func setData(movie: Movie) {
        lbVote.text = movie.voteAverageText
        posterImage.loadImage(url: movie.posterURL)
    }
    
    func setData(television: Television) {
        lbVote.text = television.voteAverageText
        posterImage.loadImage(url: television.posterURL)
    }

}
