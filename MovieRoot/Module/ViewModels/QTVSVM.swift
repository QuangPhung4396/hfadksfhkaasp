import UIKit

class QTVSVM: QBaseVM {
    var data : [Television] = [] {
        didSet {
            self.binData()
        }
    }
    var page: Int = 1
    var isNextPage: Bool = true
    
    override init() {
        super.init()
        self.page = 1
        self.isNextPage = true
        self.apiService = TVAPI()
    }
    
    func loadPage(data: [Television], page: Int){
        self.page = page
        self.data = data
        self.isNextPage = true
    }
    
    func loadData(path: String) {
        if isLoading {
            return
        }
        
        if !isNextPage {
            self.binData()
            return
        }
        
        isLoading = true
        (self.apiService as! TVAPI).fetchTVShow(page: self.page, path: path) { result in
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

