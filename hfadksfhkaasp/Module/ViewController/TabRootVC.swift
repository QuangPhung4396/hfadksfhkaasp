import UIKit

class TabRootVC: BaseVC, StackItemViewDelegate {

    var bottomStack: UIStackView = UIStackView()
    var viewStack: UIView = UIView()
    var pageView: UIView = UIView()
    var bannerView: UIView = UIView()
    
    var currentIndex = 0
    
    let movie = QMovieVC()
    let tv = QTiViVC()
    let favorite = QLoveVC()
    let search = QFindVC()
    let setting = QSetupVC()
    
    lazy var tabs: [StackItemView] = {
        var items = [StackItemView]()
        for _ in 0..<5 {
            items.append(StackItemView.newInstance)
        }
        return items
    }()
    
    lazy var tabModels: [BottomStackItem] = {
        return [
            BottomStackItem(title: UtilService.getText("movie"), image: "ic_qmovie"),
            BottomStackItem(title: UtilService.getText("tv_show"), image: "ic_qvideo"),
            BottomStackItem(title: UtilService.getText("favorite"), image: "ic_qfavorite"),
            BottomStackItem(title: UtilService.getText("search"), image: "ic_qsearch"),
            BottomStackItem(title: UtilService.getText("settings"), image: "ic_qsetting")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(bannerView)
        self.bannerView.backgroundColor = .clear
        
        self.bannerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.height.equalTo(56)
        }
        
        self.view.addSubview(viewStack)
        self.viewStack.backgroundColor = UIColor(rgb: 0x1F1D2B)
        self.viewStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.bottom.equalTo(self.bannerView.snp.top).offset(0)
            make.height.equalTo(72)
        }
        
        self.viewStack.addSubview(bottomStack)
        bottomStack.backgroundColor = UIColor.clear
        bottomStack.distribution = .equalSpacing
        bottomStack.alignment = .fill
        bottomStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview().offset(0)
        }
        self.view.addSubview(pageView)
        pageView.backgroundColor = UIColor.clear
        
        self.pageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.bottom.equalTo(self.viewStack.snp.top).offset(0)
        }
        
        self.setupTabs()
        self.addView(controller: movie)
        
        self.loadBannerAds(banner: "banner_home_detail", bannerMode: "banner_home_detail_mode", bannerView: bannerView)
        
    }
    
    func setupTabs() {
        for (index, model) in self.tabModels.enumerated() {
            let tabView = self.tabs[index]
            model.isSelected = index == 0
            tabView.item = model
            tabView.delegate = self
            self.bottomStack.addArrangedSubview(tabView)
        }
    }
    
    func handleTap(_ view: StackItemView) {
        self.tabs[self.currentIndex].isSelected = false
        view.isSelected = true
        self.currentIndex = self.tabs.firstIndex(where: { $0 === view }) ?? 0
        if self.currentIndex == 0 {
            self.addView(controller: movie)
        } else if self.currentIndex == 1 {
            self.addView(controller: tv)
        } else if self.currentIndex == 2 {
            self.addView(controller: favorite)
        } else if self.currentIndex == 3 {
            self.addView(controller: search)
        } else if self.currentIndex == 4 {
            self.addView(controller: setting)
        }
    }
    
    func addView(controller: UIViewController) {
        self.pageView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        pageView.addSubview(controller.view)
        controller.view.backgroundColor = .clear
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 0),
            controller.view.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: 0),
            controller.view.topAnchor.constraint(equalTo: pageView.topAnchor, constant: 0),
            controller.view.bottomAnchor.constraint(equalTo: pageView.bottomAnchor, constant: 0)
        ])
    }
}
