import UIKit

class QFindVC: BaseVC, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var lineMovie: UIView!
    @IBOutlet weak var lineTV: UIView!
    @IBOutlet weak var lineActor: UIView!
    @IBOutlet weak var tfInput: UITextField!
    
    var textSearch: String?
    
    //MARK: -view model
    fileprivate var movieVM: QSMVM?
    fileprivate var tvShowVM: QSTVM?
    fileprivate var peopleVM: QSPVM?

    //MARK: -outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    private var typeSelect = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfInput.attributedPlaceholder = NSAttributedString(
            string: UtilService.getText("find_your_movie"),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x92929D)]
        )
        searchCollectionView.register(UINib(nibName: DataRateCell.cellId, bundle: nil),
                                      forCellWithReuseIdentifier: DataRateCell.cellId)
        searchCollectionView.register(UINib(nibName: ActorItemCell.cellId, bundle: nil), forCellWithReuseIdentifier: ActorItemCell.cellId)
        
        searchTextField.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.reloadData()
        
        if textSearch != nil {
            searchTextField.text = textSearch
            startSearch()
            viewEmpty.isHidden = true
        } else {
            viewEmpty.isHidden = false
        }
        
        lineMovie.isHidden = false
        lineTV.isHidden = true
        lineActor.isHidden = true
        
    }
    
    @IBAction func actionMovie(_ sender: Any) {
        typeSelect = 0
        lineMovie.isHidden = false
        lineTV.isHidden = true
        lineActor.isHidden = true
        self.searchCollectionView.reloadData()
        self.checkEmpty()
    }
    
    @IBAction func actionTVShow(_ sender: Any) {
        typeSelect = 1
        lineMovie.isHidden = true
        lineTV.isHidden = false
        lineActor.isHidden = true
        self.searchCollectionView.reloadData()
        self.checkEmpty()
    }
    
    @IBAction func actionActor(_ sender: Any) {
        typeSelect = 2
        lineMovie.isHidden = true
        lineTV.isHidden = true
        lineActor.isHidden = false
        self.searchCollectionView.reloadData()
        self.checkEmpty()
    }
    
    // MARK: - request api
    fileprivate func startSearch() {
        let term = searchTextField.text!.trimming()
        if term.isEmpty {
            self.viewEmpty.isHidden = false
        } else {
            self.viewEmpty.isHidden = true
        }
        self.searchCollectionView.setContentOffset(.zero, animated: false)
        
        movieVM = QSMVM(term: term)
        movieVM?.binData = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.searchCollectionView.reloadData()
                self.checkEmpty()
            }
        }
        movieVM?.loadData()
        
        tvShowVM = QSTVM(term: term)
        tvShowVM?.binData = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.searchCollectionView.reloadData()
                self.checkEmpty()
            }
        }
        tvShowVM?.loadData()
        
        peopleVM = QSPVM(term: term)
        peopleVM?.binData = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.searchCollectionView.reloadData()
                self.checkEmpty()
            }
        }
        peopleVM?.loadData()
    }
    
    func checkEmpty(){
        if typeSelect == 0 {
            if (movieVM?.data ?? []).count == 0 {
                self.viewEmpty.isHidden = false
            } else {
                self.viewEmpty.isHidden = true
            }
        } else if typeSelect == 1 {
            if (tvShowVM?.data ?? []).count == 0 {
                self.viewEmpty.isHidden = false
            } else {
                self.viewEmpty.isHidden = true
            }
        } else {
            if (peopleVM?.data ?? []).count == 0 {
                self.viewEmpty.isHidden = false
            } else {
                self.viewEmpty.isHidden = true
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if typeSelect == 0 {
            return self.movieVM?.getSizeData() ?? 0
        } else if typeSelect == 1 {
            return self.tvShowVM?.getSizeData() ?? 0
        } else  {
            return self.peopleVM?.getSizeData() ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if typeSelect == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataRateCell.cellId, for: indexPath) as! DataRateCell
            cell.setData(movie: self.movieVM!.data[indexPath.row])
            return cell
        } else if typeSelect == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataRateCell.cellId, for: indexPath) as! DataRateCell
            cell.setData(television: self.tvShowVM!.data[indexPath.row])
            return cell
        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorItemCell.cellId, for: indexPath) as! ActorItemCell
            cell.setData(people: self.peopleVM!.data[indexPath.row])
            cell.setCornerRadius(radius: (UIScreen.main.bounds.size.width/3 - 19)/2)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if typeSelect == 2 {
            return .init(width: UIScreen.main.bounds.size.width/3 - 19, height: UIScreen.main.bounds.size.width/3 + 11)
        } else {
            return .init(width: UIScreen.main.bounds.size.width/3 - 19, height: (UIScreen.main.bounds.size.width/3 - 19)*16/11)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if typeSelect == 0 {
            self.openDetail(movieVM!.data[indexPath.row])
        } else if typeSelect == 1 {
            self.openDetail(tvShowVM!.data[indexPath.row])
        } else  {
            self.openActorDetail(self.peopleVM!.data[indexPath.row].id)
        }
    }
    
}

extension QFindVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        startSearch()
        return true
    }
}
