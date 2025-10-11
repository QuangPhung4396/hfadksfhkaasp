import UIKit

class ContentDetail: Equatable {
    
    var sources: [LinkVideo] = [LinkVideo]()
    var tracks: [Subtitle] = [Subtitle]()
    
    init(sources: [LinkVideo], tracks: [Subtitle]) {
        self.sources = sources
        self.tracks = tracks
    }
    
    static func == (lhs: ContentDetail, rhs: ContentDetail) -> Bool {
        return lhs.sources == rhs.sources
    }
}
