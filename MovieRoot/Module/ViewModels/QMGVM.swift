import UIKit

class QMGVM: QBaseVM {
    var data : [Genre] = [] {
        didSet {
            self.binData()
        }
    }
    
    static let shared = QMGVM()
    
    override init() {
        super.init()
        self.apiService = MAPI()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        isLoading = true
        
        (self.apiService as! MAPI).fetchGenre { result in
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
