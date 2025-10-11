import UIKit

class QTVGVM: QBaseVM {
    var data : [Genre] = [] {
        didSet {
            self.binData()
        }
    }
    
    static let shared = QTVGVM()
    
    override init() {
        super.init()
        self.apiService = TVAPI()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        isLoading = true
        
        (self.apiService as! TVAPI).fetchGenre { result in
            switch result {
            case .success(let genre):
                self.data = genre.genres
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}

