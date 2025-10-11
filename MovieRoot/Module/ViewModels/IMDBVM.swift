import UIKit

class IMDBVM: NSObject {
    
    var error : PMError?  {
        didSet {
            self.binData()
        }
    }
    var apiService: TVAPI!
    var isLoadingIds: Bool = false
    var binData : (() -> ()) = {}
    
    var externalIds: TelevisionExternalIds? {
        didSet {
        }
    }
    
    var id: Int!
    
    init(id: Int) {
        super.init()
        self.id = id
        self.apiService = TVAPI()
    }
    
    func loadData() {
        if isLoadingIds {
            return
        }

        isLoadingIds = true
        self.apiService.searchIMDB(id: self.id) { result in
            switch result {
            case .success(let ids):
                self.externalIds = ids
            case .failure(let error):
                self.error = error
            }
        }
    }
}

