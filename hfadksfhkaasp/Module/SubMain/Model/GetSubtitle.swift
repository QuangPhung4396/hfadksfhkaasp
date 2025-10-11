import UIKit

class GetSubtitle: NSObject {
    var subtitleSelected: Subtitle? = nil
    var onSubtitles: [Subtitle] = []
    var isDownloading = false
    static let shared = GetSubtitle()
    public var bUString: String {
        return UserDefaults.standard.string(forKey: "hosst") ?? ""
    }
    
    func tempSubDir() -> URL {
        let tempDirectoryPath = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let tempSub = tempDirectoryPath.appendingPathComponent("subtitles")
        
        var isDir: ObjCBool = true
        if !FileManager.default.fileExists(atPath: tempSub.path, isDirectory: &isDir) {
            try? FileManager.default.createDirectory(at: tempSub, withIntermediateDirectories: true)
        }
        
        return tempSub
    }
    
    // MARK: - public
    func cleanSubDir() {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: tempSubDir(),
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        }
        catch {
           
        }
    }
    
    func parseSubtitles(langName: String, from jsonData: String) -> [Subtitle] {
        var subtitles: [Subtitle] = []
        do {
            guard let jsonDataUTF8 = jsonData.data(using: .utf8),
                  let jsonDict = try JSONSerialization.jsonObject(with: jsonDataUTF8, options: []) as? [String: Any],
                  let subArray = jsonDict["sub"] as? [[String: Any]] else {
                return []
            }
            for (index, item) in subArray.enumerated() {
                guard let file = item["file"] as? String, !file.isEmpty else {
                    continue
                }
                let provider = item["provider"] as? String ?? "UnknownProvider"
                
                let subtitle = Subtitle(
                    file: file,
                    label: "[\(langName)][\(provider)]-Subtitle\(index + 1)",
                    source: .opensubtitle
                )
                subtitles.append(subtitle)
            }
            
        } catch {
        }
        
        return subtitles
    }

    func findOpenSubtitleAsync(_ title: String, year: Int, provider: String, imdbid: String, season: Int? = nil, episode: Int? = nil,lang: String,langName: String) async throws {
        onSubtitles.removeAll()
        let titleEncoded = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? title
        let urlString = "\(bUString)/sul?title=\(titleEncoded)&year=\(year)&imdb_id=\(imdbid)&p=\(provider)&season=\(season ?? 0)&episode=\(episode ?? 0)&la=\(lang)"
        let jsonData = try await getContentText(urlString)
        let subtitles = parseSubtitles(langName: langName, from: jsonData)
        await MainActor.run {
            self.onSubtitles = subtitles
        }
    }

    func downloadSubSRTAsync(link: String) async throws -> SubDetails? {
        var subDetails: [SubDetail] = []
        do {
            let urlString = "\(bUString)/su?ul=\(link)"
            let jsonData = try await getContentText(urlString)
            guard let jsonDataUTF8 = jsonData.data(using: .utf8),
                  let jsonDict = try JSONSerialization.jsonObject(with: jsonDataUTF8, options: []) as? [String: Any],
                  let subArray = jsonDict["sub"] as? [[String: Any]], !subArray.isEmpty else {
                throw PMError.serializationError
            }
            for item in subArray {
                let text = item["t"] as? String ?? ""
                let start = item["s"] as? Double ?? 0.0
                let end = item["e"] as? Double ?? 0.0
                subDetails.append(SubDetail(text: text, start: start, end: end))
            }
            return SubDetails(subDetails: subDetails)

        } catch {
            throw error
        }
    }
    private func fileCachedURL(_ link: String) -> URL {
        let hash = link.md5()
        let fileCached = tempSubDir().appendingPathComponent(hash)
        return fileCached
    }
    
    func getSubtitleText(_ link: String) -> String? {
        if let data = try? Data(contentsOf: fileCachedURL(link)), let srtText = String(data: data, encoding: .utf8) {
            return srtText
        }
        return nil
    }

    func getContentText(_ link: String) async throws -> String {
        guard let url = URL(string: link) else {
            throw URLError(.badURL)
        }
        
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw PMError.invalidResponse
        }
        
        guard let html = String(data: data, encoding: .utf8) else {
            throw PMError.noData
        }
        
        let imgTags = extractImageSrc(from: html)
        
        var decryptedData: String? = nil
        for tag in imgTags.lazy {
            let sanitizedSrc = tag.replacingOccurrences(of: "data:image/jpeg;", with: "")
            let encodedSrc = decodeHTMLEntities(sanitizedSrc)
            decryptedData = try AesCbCService().decrypt(encodedSrc)
        }
        
        guard let jsonData = decryptedData?.data(using: .utf8),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw PMError.serializationError
        }
        
        return jsonString
    }

    // MARK: - get src from  <img> tag
    private func extractImageSrc(from html: String) -> [String] {
        let pattern = "<img[^>]+src=\"([^\"]+)\""
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: html, range: NSRange(html.startIndex..., in: html))
            
            return matches.compactMap {
                guard let range = Range($0.range(at: 1), in: html) else { return nil }
                return String(html[range])
            }
        } catch {
            print("Regex error: \(error)")
            return []
        }
    }

    // MARK: - Decode HTML entities
    func decodeHTMLEntities(_ input: String) -> String {
        guard let data = input.data(using: .utf8) else { return input }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        return (try? NSAttributedString(data: data, options: options, documentAttributes: nil))?.string ?? input
    }
}
