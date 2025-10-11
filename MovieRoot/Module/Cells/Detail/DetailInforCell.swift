import UIKit

class DetailInforCell: UITableViewCell {

    static let height: CGFloat = 330
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var posterImage: PImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(movie: Movie?) {
        posterImage.loadImage(url: movie?.backdropURL)
        titleLabel.text = movie?.title
        genresLabel.text = movie?.genreText
        lengthLabel.text = movie?.durationText
        rateLabel.text = movie?.ratingText
    }
    
    func setData(television: Television?) {
        posterImage.loadImage(url: television?.backdropURL)
        titleLabel.text = television?.name
        genresLabel.text = television?.genreText
        if television != nil {
            lengthLabel.text = "\(television!.seasonList.count) Seasons"
        }
        rateLabel.text = television?.ratingText
    }
    
}
