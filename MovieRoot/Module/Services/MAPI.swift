import UIKit

class MAPI: APIService {
    // MARK: - genre
    func fetchGenre(_ completion: @escaping (Result<GenreResponse, PMError>) -> ()) {
        guard let url = makeURL("genre/movie/list") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, completion: completion)
    }
    
    func fetchMovie(page: Int, path: String, completion: @escaping (Result<MovieResponse, PMError>) -> ()) {
        guard let url = makeURL(path) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func search(term: String, page: Int, completion: @escaping (Result<MovieResponse, PMError>) -> ()) {
        guard let url = makeURL("search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": term,
            "page": page
        ], completion: completion)
    }
    
    // MARK: - detail
    func fetchDetail(id: Int, completion: @escaping (Result<Movie, PMError>) -> ()) {
        guard  let url = makeURL("movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["append_to_response":"videos,images,credits"], completion: completion)
    }
    
    // MARK: - detail more
    func fetchRecommendation(id: Int, page: Int, completion: @escaping (Result<MovieResponse, PMError>) -> ()) {
        guard  let url = makeURL("movie/\(id)/recommendations") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
    
    func fetchSimilar(id: Int, page: Int, completion: @escaping (Result<MovieResponse, PMError>) -> ()) {
        guard  let url = makeURL("movie/\(id)/similar") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecoder(url: url, params: ["page": page], completion: completion)
    }
}
