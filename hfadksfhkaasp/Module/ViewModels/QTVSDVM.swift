import UIKit

class QTVSDVM: QBaseVM {
    var data : TelevisionSeason? {
        didSet {
            self.binData()
        }
    }
    var tvId: Int!
    var seasonNumber: Int!
    
    init(tvId: Int, seasonNumber: Int) {
        super.init()
        self.tvId = tvId
        self.seasonNumber = seasonNumber
        self.apiService = TVAPI()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        
        isLoading = true
        (self.apiService as! TVAPI).fetchSeasonDetail(tvId: self.tvId, seasonNumber: self.seasonNumber) { result in
            switch result {
            case .success(let tmp):
                self.data = tmp
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}

