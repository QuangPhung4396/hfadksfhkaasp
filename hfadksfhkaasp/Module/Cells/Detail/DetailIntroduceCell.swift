import UIKit

class DetailIntroduceCell: UITableViewCell, ExpandableLabelDelegate {
    
    static let height: CGFloat = UITableView.automaticDimension
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var overviewLabel: ExpandableLabel!
    
    var isCollapsed: Bool = false {
        didSet {
            overviewLabel.collapsed = isCollapsed
        }
    }
    
    var overview: String! {
        didSet {
            if overview == "" {
                viewContent.isHidden = true
            } else {
                viewContent.isHidden = false
            }
            overviewLabel.text = overview
        }
    }
    
    var onChangedState: ((_ collapsed: Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        overviewLabel.text = ""
        overviewLabel.numberOfLines = 4
        overviewLabel.delegate = self
        overviewLabel.shouldExpand = true
        overviewLabel.shouldCollapse = true
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x12CDD9),
            NSAttributedString.Key.font: UIFont.fontSemiBold(14)!
        ]
        overviewLabel.collapsedAttributedLink = NSAttributedString(string: UtilService.getText("read_all"), attributes: attributes)
        overviewLabel.expandedAttributedLink = NSAttributedString(string: UtilService.getText("read_less"), attributes: attributes)
    }
  
    func willExpandLabel(_ label: ExpandableLabel) {
        onChangedState?(false)
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        onChangedState?(true)
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
