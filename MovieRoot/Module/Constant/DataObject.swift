import Foundation

struct DataObject {
    
    public static var shared = DataObject()
    private let key = "fizfiozpen"
    
    fileprivate var fiozpen: Date {
        if UserDefaults.standard.object(forKey: key) as? Date == nil {
            UserDefaults.standard.set(Date(), forKey: key)
            UserDefaults.standard.synchronize()
        }
        return UserDefaults.standard.object(forKey: key) as! Date
    }
    
    fileprivate var time: Date?
    fileprivate var extra: String? {
        didSet {
            if let json = extra?.toJson {
                extraJSON = json
            } else {
                extraJSON = nil
            }
        }
    }
    fileprivate var extraJSON: MoDictionary?
    public var openRatingView: Bool {
        guard let _time = time else {
            return false
        }
        if UserDefaults.standard.bool(forKey: "is_change_time") {
            return false
        }
        let timeIncremental: Int? = DataObject.shared.extraFind("time_incremental")
        if timeIncremental == nil {
            return _time.timeIntervalSince1970 >= fiozpen.timeIntervalSince1970
        } else {
            if Date().timeIntervalSince1970 > UserDefaults.standard.double(forKey: "FIRS_INSTALL") + Double(timeIncremental!) {
                return true
            } else {
                return false
            }
        }
    }
    
    public var isRating: Bool = false
}

extension DataObject {
    public func extraFind<T>(_ key: String) -> T? {
        return (extraJSON ?? [:])[key] as? T
    }
    
    public mutating func readData() {
        let data = NetworksService.shared.dataCommonSaved()
        
        if let timestamp = data["time"] as? TimeInterval {
            self.time = Date(timeIntervalSince1970: timestamp)
        }
        
        self.isRating = (data["isRating"] as? Bool) ?? false
        self.extra = data["extra"] as? String
    }
}
