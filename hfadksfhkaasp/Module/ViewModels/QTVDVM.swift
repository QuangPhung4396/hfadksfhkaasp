import UIKit

class QTVDVM: QBaseVM {
    var data : Television? {
        didSet {
            self.binData()
        }
    }
    var id: Int!
    init(id: Int) {
        super.init()
        self.id = id
        self.apiService = TVAPI()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        
        isLoading = true
        (self.apiService as! TVAPI).fetchDetail(id: self.id) { result in
            switch result {
            case .success(let television):
                self.data = television
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}

