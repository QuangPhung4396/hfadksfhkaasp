import UIKit
import SnapKit

class QActorDetailVC: BaseVC, UITableViewDelegate, UITableViewDataSource {

    var btnBack = UIButton()
    var tableView: UITableView = UITableView()
    
    var actorId: Int = 0
    var cast: Cast?
    fileprivate let listIDCastCell: [String] = [
        CastDetailCell.cellId,
        CastIntroCell.cellId,
        CastKnowForCell.cellId,
        CastActionCell.cellId
    ]
    
    fileprivate var collapsedOverviewPeople: Bool = true
    fileprivate var collapsedOverviewActing: Bool = true
    
    fileprivate var peopleDetailVM: QPDVM?
    fileprivate var peopleCreditVM: QPCVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(btnBack)
        self.btnBack.setImage(UIImage(named: "ic_back_movie"), for: .normal)
        self.btnBack.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        self.btnBack.snp.makeConstraints { make in
            make.top.leading.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.height.width.equalTo(56)
        }
        self.btnBack.addTarget(self, action: #selector(actionBack), for: .touchUpInside)
        self.view.addSubview(tableView)
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.top.equalTo(self.btnBack.snp.bottom).offset(0)
        }
        
        tableView.register(UINib(nibName: CastDetailCell.cellId, bundle: nil),
                           forCellReuseIdentifier: CastDetailCell.cellId)
        tableView.register(UINib(nibName: CastIntroCell.cellId, bundle: nil),
                           forCellReuseIdentifier: CastIntroCell.cellId)
        tableView.register(UINib(nibName: CastKnowForCell.cellId, bundle: nil),
                           forCellReuseIdentifier: CastKnowForCell.cellId)
        tableView.register(UINib(nibName: CastActionCell.cellId, bundle: nil),
                           forCellReuseIdentifier: CastActionCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.peopleDetailVM = QPDVM(id: actorId)
        self.peopleDetailVM?.binData = {
            self.tableView.reloadData()
            let item = self.peopleDetailVM!.data!
            self.cast = Cast(id: item.id, character: item.biography!, name: item.name, known_for_department: item.known_for_department, profile_path: item.profile_path)
        }
        self.peopleDetailVM?.loadData()
        
        self.peopleCreditVM = QPCVM(id: actorId)
        self.peopleCreditVM?.binData = {
            self.tableView.reloadData()
        }
        self.peopleCreditVM?.loadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func actionBack(_ sender: Any) {
        self.backAction()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listIDCastCell.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (listIDCastCell[indexPath.row]){
        case CastDetailCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastDetailCell.cellId) as! CastDetailCell
            cell.cast = peopleDetailVM?.data
            return cell
        case CastIntroCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastIntroCell.cellId) as! CastIntroCell
            cell.isCollapsed = collapsedOverviewPeople
            cell.onChangedState = { collapsed in
                self.collapsedOverviewPeople = collapsed
                self.tableView.reloadData()
            }
            cell.overview = "N/A"
            if peopleDetailVM?.data != nil {
                cell.overview = peopleDetailVM?.data!.biography ?? "N/A"
            }
            return cell
        case CastKnowForCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastKnowForCell.cellId) as! CastKnowForCell
            cell.source = peopleCreditVM?.data ?? []
            cell.selectItemBlock = { item in
                if let movie = item as? Movie {
                    self.openDetail(movie)
                }
                else if let tele = item as? Television {
                    self.openDetail(tele)
                }
            }
            return cell
        case CastActionCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastActionCell.cellId) as! CastActionCell
            cell.actings = peopleCreditVM?.actings ?? []
            cell.isCollapsed = self.collapsedOverviewActing
            cell.onChangedState = {
                self.collapsedOverviewActing = !self.collapsedOverviewActing
                self.tableView.reloadData()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (listIDCastCell[indexPath.row]){
        case CastDetailCell.cellId:
            return peopleDetailVM?.data == nil ? 0 : CastDetailCell.height
        case CastIntroCell.cellId:
            return CastIntroCell.height
        case CastKnowForCell.cellId:
            return peopleCreditVM?.data == nil ? 0 : CastKnowForCell.height
        case CastActionCell.cellId:
            if peopleCreditVM == nil || peopleCreditVM?.actings == nil || peopleCreditVM?.actings.count == 0 {
                return 0
            } else {
                if collapsedOverviewActing == true {
                    return peopleCreditVM!.actings.count > 7 ? 560 : CGFloat(peopleCreditVM!.actings.count * 70 + 70)
                } else {
                    return CGFloat(peopleCreditVM!.actings.count) * 70 + 70
                }
            }
        default:
            return UITableView.automaticDimension
        }
    }
}
