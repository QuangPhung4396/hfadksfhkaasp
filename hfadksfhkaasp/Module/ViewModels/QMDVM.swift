import UIKit

class QMDVM: QBaseVM {
    var data : Movie? {
        didSet {
            self.binData()
        }
    }
    var id: Int!
    init(id: Int) {
        super.init()
        self.id = id
        self.apiService = MAPI()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        
        isLoading = true
        (self.apiService as! MAPI).fetchDetail(id: self.id) { result in
            switch result {
            case .success(let movie):
                self.data = movie
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}
