import UIKit

enum BookmarkType: String {
    case movie = "MVF"
    case tvShow = "TVSF"
    case movieC = "MVC"
    case tvShowC = "TVSFC"
}

class BookmarkService: NSObject {
    
    static let shared: BookmarkService = BookmarkService()
    
    override init() {}
    
    // MARK: - private
    private func getURLFileJson(type: BookmarkType) -> URL? {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileUrl = documentURL.appendingPathComponent("\(type.rawValue).json")
        return fileUrl
    }
    
    private func saveDataJson(data: [Any], type: BookmarkType) -> Bool {
        guard let fileUrl = getURLFileJson(type: type) else { return false }
        
        do {
            var listData = [NSDictionary]()
            
            for item in data {
                if type == .movie {
                    listData.append((item as! Movie).dictionary)
                } else if type == .tvShow {
                    listData.append((item as! Television).dictionary)
                } else if type == .movieC {
                    listData.append((item as! MovieContinue).dictionary)
                } else if type == .tvShowC {
                    listData.append((item as! TelevisionContinue).dictionary)
                }
            }
            
            let data = try JSONSerialization.data(withJSONObject: listData, options: .prettyPrinted)
            try data.write(to: fileUrl, options: [])
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - public
    func getListBookmark(type: BookmarkType) -> [Any] {
        guard let url = getURLFileJson(type: type) else { return [] }
        
        do {
            let data = try Data(contentsOf: url)
            
            if type == .movie {
                let listMovie: [Movie] = try JSONDecoder().decode([Movie].self, from: data)
                return listMovie
            } else if type == .tvShow {
                let listMovie: [Television] = try JSONDecoder().decode([Television].self, from: data)
                return listMovie
            } else if type == .movieC {
                let listMovie: [MovieContinue] = try JSONDecoder().decode([MovieContinue].self, from: data)
                return listMovie
            } else if type == .tvShowC {
                let listMovie: [TelevisionContinue] = try JSONDecoder().decode([TelevisionContinue].self, from: data)
                return listMovie
            }
        } catch { }
        return []
    }
    
    @discardableResult
    func addBookmark(data: Any, type: BookmarkType) -> Bool {
        if checkIsBookmark(item: data, type: type) {
            return false
        }
        else {
            var listNewData = getListBookmark(type: type)
            listNewData.insert(data, at: 0)
            return saveDataJson(data: listNewData, type: type)
        }
    }
    
    @discardableResult
    func deleteBookmark(item: Any, type: BookmarkType) -> Bool {
        if checkIsBookmark(item: item, type: type) {
            switch type {
            case .movie:
                guard var listMovie = getListBookmark(type: type) as? [Movie] else { return false }
                listMovie.removeAll(where: { $0.id == (item as! Movie).id })
                return saveDataJson(data: listMovie, type: type)
            case .tvShow:
                guard var listTvShow = getListBookmark(type: type) as? [Television] else { return false }
                listTvShow.removeAll(where: { $0.id == (item as! Television).id })
                return saveDataJson(data: listTvShow, type: type)
            case .movieC:
                guard var listMovie = getListBookmark(type: type) as? [MovieContinue] else { return false }
                listMovie.removeAll(where: { $0.id == (item as! MovieContinue).id })
                return saveDataJson(data: listMovie, type: type)
            case .tvShowC:
                guard var listTvShow = getListBookmark(type: type) as? [TelevisionContinue] else { return false }
                listTvShow.removeAll(where: { $0.id == (item as! TelevisionContinue).id })
                return saveDataJson(data: listTvShow, type: type)
            }
        }
        return false
    }
    
    @discardableResult
    func checkIsBookmark(item: Any, type: BookmarkType) -> Bool {
        switch type {
        case .movie:
            return checkIsBookmark(id: (item as! Movie).id, type: type)
        case .tvShow:
            return checkIsBookmark(id: (item as! Television).id, type: type)
        case .movieC:
            return checkIsBookmark(id: (item as! MovieContinue).id, type: type)
        case .tvShowC:
            return checkIsBookmark(id: (item as! TelevisionContinue).id, type: type)
        }
    }
    
    @discardableResult
    func checkIsBookmark(id: Int, type: BookmarkType) -> Bool {
        switch type {
        case .movie:
            guard let listMovie = getListBookmark(type: type) as? [Movie] else { return false }
            
            if listMovie.first(where: { $0.id == id }) != nil {
                return true
            }
            else {
                return false
            }
        case .tvShow:
            guard let listTvShow = getListBookmark(type: type) as? [Television] else { return false }
            
            if listTvShow.first(where: { $0.id == id }) != nil {
                return true
            }
            else {
                return false
            }
        case .movieC:
            guard let listMovie = getListBookmark(type: type) as? [MovieContinue] else { return false }
            
            if listMovie.first(where: { $0.id == id }) != nil {
                return true
            }
            else {
                return false
            }
        case .tvShowC:
            guard let listTvShow = getListBookmark(type: type) as? [TelevisionContinue] else { return false }
            
            if listTvShow.first(where: { $0.id == id }) != nil {
                return true
            }
            else {
                return false
            }
        }
    }
    
    @discardableResult
    func resetBookmark(type: BookmarkType)  -> Bool {
        switch type {
        case .movie:
            guard var listMovie = getListBookmark(type: type) as? [Movie] else { return false }
            listMovie.removeAll(where: { $0.id != 0 })
            return saveDataJson(data: listMovie, type: type)
        case .tvShow:
            guard var listTvShow = getListBookmark(type: type) as? [Television] else { return false }
            listTvShow.removeAll(where: { $0.id != 0 })
            return saveDataJson(data: listTvShow, type: type)
        case .movieC:
            guard var listMovie = getListBookmark(type: type) as? [MovieContinue] else { return false }
            listMovie.removeAll(where: { $0.id != 0 })
            return saveDataJson(data: listMovie, type: type)
        case .tvShowC:
            guard var listTvShow = getListBookmark(type: type) as? [TelevisionContinue] else { return false }
            listTvShow.removeAll(where: { $0.id != 0 })
            return saveDataJson(data: listTvShow, type: type)
        }
    }
    
}
