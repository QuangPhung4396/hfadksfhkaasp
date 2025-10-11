import UIKit

class QSTVM: QBaseVM {
    var data : [Television] = [] {
        didSet {
            self.binData()
        }
    }
    var term: String!
    var page: Int = 1
    var isNextPage: Bool = true
    
    init(term: String) {
        super.init()
        self.term = term
        self.page = 1
        self.isNextPage = true
        self.apiService = TVAPI()
        self.data = []
    }
    
    func loadData() {
        if isLoading {
            return
        }
        
        if term == "" {
            self.binData()
            return
        }
        
        if !isNextPage {
            self.binData()
            return
        }
        
        isLoading = true
        (self.apiService as! TVAPI).search(self.term) { result in
            switch result {
            case .success(let response):
                self.data += response.results
                self.isNextPage = response.results.count > 0
                self.page = self.isNextPage ? self.page + 1 : self.page
            case .failure(let error):
                self.error = error
                self.isNextPage = false
            }
            self.isLoading = false
        }
    }
    func getSizeData() -> Int{
        return data.count
    }
}

