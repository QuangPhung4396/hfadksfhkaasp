import UIKit
import SnapKit

protocol SelectItem {
    func selectCell(indexSelect: Int, section: Int)
}

class ChooseCell: UITableViewCell {

    var lbTitle: UILabel = UILabel()
    var imageSelect: UIImageView = UIImageView()
    var viewContent: PView = PView()
    
    var indexSelect = 0
    var section = 0
    var selectItem: SelectItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        lbTitle.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbTitle.textColor = UIColor.white
        
        imageSelect.image = UIImage(named: "radio_button_checked")
        self.addSubview(viewContent)
        self.viewContent.borderWidth = 1
        self.viewContent.cornerRadius = 16
        self.viewContent.addSubview(lbTitle)
        self.viewContent.addSubview(imageSelect)
        self.viewContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectCell)))
        
        self.viewContent.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
        }
        
        imageSelect.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(16)
        }
        
        lbTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().offset(0)
            make.trailing.equalTo(self.imageSelect.snp.leading).offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func selectCell(_ sender: Any) {
        if let selectItem = self.selectItem {
            selectItem.selectCell(indexSelect: self.indexSelect, section: self.section)
        }
    }
    
    func setData(title: String, index: Int, section: Int = 0, isSelected: Bool) {
        self.section = section
        self.indexSelect = index
        self.viewContent.borderColor = isSelected ? UIColor(rgb: 0x12CDD9) : UIColor.white.withAlphaComponent(0.5)
        self.lbTitle.textColor = isSelected ? UIColor(rgb: 0x12CDD9) : UIColor.white
        imageSelect.isHidden = !isSelected
        lbTitle.text = title
    }
    
}
