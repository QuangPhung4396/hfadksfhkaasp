import UIKit

class QPDVM: QBaseVM {
    var data : People? {
        didSet {
            self.binData()
        }
    }
    var id: Int!
    
    init(id: Int) {
        super.init()
        self.id = id
        self.apiService = PAPI()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        isLoading = true
        
        (self.apiService as! PAPI).fetchDetail(id: self.id) { result in
            switch result {
            case .success(let people):
                self.data = people
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}
