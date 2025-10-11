import UIKit

class ActorItemCell: UICollectionViewCell {
    //MARK: -outlets
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(people: People){
        posterImage.loadImage(url: people.profileURL)
        nameLabel.text = people.name
    }
    
    func setCornerRadius(radius: CGFloat){
        posterImage.layer.cornerRadius = radius
    }
}
