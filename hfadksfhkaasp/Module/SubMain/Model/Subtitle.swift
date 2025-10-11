import UIKit

enum SubSource {
    case original
    case opensubtitle
}

class Subtitle: NSObject {
    
    var file: String = ""
    var label: String = ""
    var source: SubSource?
    var webVTTCache: SubDetails?
    
    init(file: String, label: String, source: SubSource? = nil, webVTTCache: SubDetails? = nil) {
        self.file = file
        self.label = label
        self.source = source
        self.webVTTCache = webVTTCache
    }
    
    public static func createInstance(_ d: MoDictionary) -> Subtitle {
        let file = d["file"] as? String
        let label = d["label"] as? String
        return Subtitle(file: file ?? "", label: label ?? "", source: .original, webVTTCache: nil)
    }
    
    func withWebVTTCache(_ cache: SubDetails?) -> Subtitle {
        return Subtitle(file: self.file, label: self.label, source: self.source, webVTTCache: cache)
    }
    
    var webVTT: SubDetails? {
        if let srtText = GetSubtitle.shared.getSubtitleText(file) {
            let _webVTT = try? parseSubRip(srtText)
            return _webVTT
        }
        return nil
    }
    
    func parseSubRip(_ payload: String) throws -> SubDetails {
        var payload = payload.replacingOccurrences(of: "\n\r\n", with: "\n\n")
        payload = payload.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        payload = payload.replacingOccurrences(of: "\r\n", with: "\n")
        let regexStr = "(\\d+)\\n([\\d:,.]+)\\s+-{2}\\>\\s+([\\d:,.]+)\\n([\\s\\S]*?(?=\\n{2,}|$))"
        let regex = try NSRegularExpression(pattern: regexStr, options: .caseInsensitive)
        let matches = regex.matches(in: payload, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, payload.count))
        
        var subDetails: [SubDetail] = []
        
        for m in matches {
            let group = (payload as NSString).substring(with: m.range)
            var regex = try NSRegularExpression(pattern: "^[0-9]+", options: .caseInsensitive)
            var match = regex.matches(in: group, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, group.count))
            
            guard let _ = match.first else {
                continue
            }
            regex = try NSRegularExpression(pattern: "\\d{1,2}:\\d{1,2}:\\d{1,2}[,.]\\d{1,3}", options: .caseInsensitive)
            match = regex.matches(in: group, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, group.count))
            
            guard match.count == 2 else {
                continue
            }
            
            guard let from = match.first, let to = match.last else {
                continue
            }
            
            var h: TimeInterval = 0.0, m: TimeInterval = 0.0, s: TimeInterval = 0.0, c: TimeInterval = 0.0
            
            let fromStr = (group as NSString).substring(with: from.range)
            var scanner = Scanner(string: fromStr)
            h = scanner.scanDouble() ?? 0.0
            m = scanner.scanDouble() ?? 0.0
            s = scanner.scanDouble() ?? 0.0
            c = scanner.scanDouble() ?? 0.0
            
            let fromTime = (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)
            
            let toStr = (group as NSString).substring(with: to.range)
            scanner = Scanner(string: toStr)
            h = scanner.scanDouble() ?? 0.0
            m = scanner.scanDouble() ?? 0.0
            s = scanner.scanDouble() ?? 0.0
            c = scanner.scanDouble() ?? 0.0
            let toTime = (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)
            let range = NSMakeRange(0, to.range.location + to.range.length + 1)
            guard (group as NSString).length - range.length > 0 else {
                continue
            }
            
            let text = (group as NSString).replacingCharacters(in: range, with: "")
            subDetails.append(SubDetail(text: text, start: Double(fromTime * 1000), end: Double(toTime * 1000)))
        }
        
        return SubDetails(subDetails: subDetails)
    }
}
