import UIKit

class HotCell: UICollectionViewCell, FSPagerViewDataSource,FSPagerViewDelegate  {

    static let height: CGFloat = 266
    
    var lbTitle = UILabel()
    let pagerMovie: FSPagerView = FSPagerView()
    
    var source: [Movie] = []
    var sourceTV: [Television] = []
    
    var selectItemBlock: ((_ item: Movie) -> Void)?
    var selectItemTVBlock: ((_ item: Television) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.lbTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lbTitle.textColor = UIColor.white
        self.lbTitle.text = UtilService.getText("recent_watching")
        self.pagerMovie.backgroundColor = UIColor.clear
        
        self.addSubview(lbTitle)
        
        self.lbTitle.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(0)
            make.height.equalTo(32)
        }

        self.addSubview(pagerMovie)
        self.pagerMovie.snp.makeConstraints { make in
            make.top.equalTo(self.lbTitle.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        self.pagerMovie.dataSource = self
        self.pagerMovie.delegate = self
        self.pagerMovie.automaticSlidingInterval = 2.0
        self.pagerMovie.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 80, height: 194)
        self.pagerMovie.transformer = FSPagerViewTransformer(type: .linearTrending)
        self.pagerMovie.register(UINib(nibName: "HotItemCell", bundle: nil), forCellWithReuseIdentifier: "HotItemCell")
        self.pagerMovie.isInfinite = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(source: [Movie]){
        self.source = source
        pagerMovie.reloadData()
        lbTitle.text = UtilService.getText("best_movie")
    }
    
    func setData(sourceTV: [Television]){
        self.sourceTV = sourceTV
        pagerMovie.reloadData()
        lbTitle.text = UtilService.getText("best_tv_show")
    }

    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if self.source.count > 0 {
            return self.source.count
        } else if self.sourceTV.count > 0 {
            return self.sourceTV.count
        } else {
            return 0
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HotItemCell", at: index) as! HotItemCell
        if self.source.count > 0 {
            cell.setData(movie: source[index])
        } else if self.sourceTV.count > 0 {
            cell.setData(television: sourceTV[index])
        }
        return cell
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        if self.source.count > 0 {
            selectItemBlock?(source[index])
        } else if self.sourceTV.count > 0 {
            selectItemTVBlock?(sourceTV[index])
        }
    }
}

