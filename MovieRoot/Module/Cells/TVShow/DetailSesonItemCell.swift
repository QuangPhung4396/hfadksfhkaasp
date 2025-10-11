import UIKit

class DetailSesonItemCell: UITableViewCell {

    @IBOutlet weak var imageThumb: PImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    var selectEpisode: ((_ episodes: TelevisionEpisode) -> Void)?
    
    var episode: TelevisionEpisode? {
        didSet {
            if episode?.still_path != "" {
                imageThumb.loadImage(url: UtilService.makeURLImage(episode?.still_path))
            }
            lbTitle.text = "\(UtilService.getText("episode")) \(episode?.episode_number ?? 0)"
            lbDate.text = episode?.airDateText
        }
    }
    
    var backdrop: URL? {
        didSet {
            imageThumb.loadImage(url: backdrop)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func selectCell(_ sender: Any) {
        if let selectEpisode = self.selectEpisode {
            selectEpisode(episode!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
