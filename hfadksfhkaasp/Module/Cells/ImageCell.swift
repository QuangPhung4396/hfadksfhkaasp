import UIKit
import SnapKit

class ImageCell: UICollectionViewCell {

    var posterImage: PImageView = PImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        posterImage.contentMode = .scaleAspectFill
        posterImage.cornerRadius = 16
        self.addSubview(posterImage)
        posterImage.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().offset(0)
        }
        posterImage.setImageBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageUrl(url: URL!) {
        posterImage.loadImage(url: url)
    }
}
