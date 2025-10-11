import UIKit

class TVAPI: APIService {
    // MARK: - genre
    func fetchGenre(_ completion: @escaping (Result<GenreResponse, PMError>) -> ()) {
        guard let url = makeURL("genre/tv/list") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, completion: completion)
    }

    func fetchTVShow(page: Int, path: String, completion: @escaping (Result<TelevisionResponse, PMError>) -> ()) {
        guard let url = makeURL(path) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func search(_ term: String, completion: @escaping (Result<TelevisionResponse, PMError>) -> ()) {
        guard let url = makeURL("search/tv") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": term
        ], completion: completion)
    }
    
    func fetchDetail(id: Int, completion: @escaping (Result<Television, PMError>) -> ()) {
        guard  let url = makeURL("tv/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["append_to_response":"videos,images,credits"], completion: completion)
    }

    func fetchRecommendation(id: Int, page: Int, completion: @escaping (Result<TelevisionResponse, PMError>) -> ()) {
        guard  let url = makeURL("tv/\(id)/recommendations") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchSimilar(id: Int, page: Int, completion: @escaping (Result<TelevisionResponse, PMError>) -> ()) {
        guard  let url = makeURL("tv/\(id)/similar") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchSeasonDetail(tvId: Int, seasonNumber: Int, completion: @escaping (Result<TelevisionSeason, PMError>) -> ()) {
        guard  let url = makeURL("tv/\(tvId)/season/\(seasonNumber)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, completion: completion)
    }
    
    func searchIMDB(id: Int, completion: @escaping (Result<TelevisionExternalIds, PMError>) -> ()) {
        guard  let url = makeURL("tv/\(id)/external_ids") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, completion: completion)
    }
    
}
