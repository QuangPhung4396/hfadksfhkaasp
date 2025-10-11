import UIKit

class QBaseVM: NSObject {
    var error : PMError?  {
        didSet {
            self.binData()
        }
    }
    var apiService: APIService!
    var isLoading: Bool = false
    var binData : (() -> ()) = {}
}
