import UIKit

class LinkVideo: Equatable {
    
    var file: String = ""
    var title: String = ""
    
    init(file: String, title: String) {
        self.file = file
        self.title = title
    }
    
    static func == (lhs: LinkVideo, rhs: LinkVideo) -> Bool {
        return lhs.file == rhs.file && lhs.title == rhs.title
    }
    
    static func createInstance(_ d: MoDictionary) -> LinkVideo {
        let file = d["file"] as? String
        let title = d["title"] as? String
        return LinkVideo(file: file ?? "", title: title ?? "")
    }
}
