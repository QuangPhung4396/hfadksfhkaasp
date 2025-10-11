import UIKit


class HotItemCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDetail: UILabel!
    
    var imageURL: URL! {
        didSet {
            posterImage.loadImage(url: imageURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        posterImage.setImageBackground()
    }
    
    func setData(movie: Movie) {
        lbTitle.text = movie.title
        lbDetail.text = movie.genreText
        posterImage.loadImage(url: movie.backdropURL)
    }
    
    func setData(television: Television) {
        lbTitle.text = television.name
        lbDetail.text = television.genreText
        posterImage.loadImage(url: television.backdropURL)
    }
}
