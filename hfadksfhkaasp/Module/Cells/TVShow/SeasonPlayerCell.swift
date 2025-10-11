import UIKit

class SeasonPlayerCell: UICollectionViewCell {

    @IBOutlet weak var imageThumb: PImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbOverView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(episode: TelevisionEpisode){
        imageThumb.loadImage(url: episode.backdropURL)
        lbTitle.text = "\(UtilService.getText("episode")) \(episode.episode_number ?? 0)"
        lbDate.text = episode.airDateText
        lbOverView.text = episode.overview ?? ""
    }
    
}
