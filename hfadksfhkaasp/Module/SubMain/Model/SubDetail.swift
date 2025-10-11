import Foundation

public struct SubDetail {
    public let text: String
    public let start: Double
    public let end: Double
    
    var timeStart: TimeInterval { return TimeInterval(start) / 1000 }
    var timeEnd: TimeInterval { return TimeInterval(end) / 1000 }
}


public struct SubDetails {
    
    public let subDetails: [SubDetail]
    
    public init(subDetails: [SubDetail]) {
        self.subDetails = subDetails
    }
    
    func searchSubtitles(time: Double) -> String? {
        guard let firstSub = subDetails.filter({ c in
            return c.start <= time && time <= c.end
        }).first else {
            return nil
        }
        
        return firstSub.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
