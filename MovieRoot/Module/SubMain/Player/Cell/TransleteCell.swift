import UIKit
import SnapKit

class TransleteCell: UICollectionViewCell {
    
    var lb: PLabel = PLabel()
    var iv: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lb.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lb.textColor = UIColor.white
        
        iv.image = UIImage(named: "radio_button_checked")
        self.addSubview(lb)
        self.addSubview(iv)
        
        iv.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(16)
        }
        
        lb.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().offset(0)
            make.trailing.equalTo(iv.snp.leading).offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setData(model: LanguageModel, transleteAppModel: LanguageModel) {
        let isHident = model.id != transleteAppModel.id
        iv.isHidden = isHident
        lb.text = model.name
    }

}
