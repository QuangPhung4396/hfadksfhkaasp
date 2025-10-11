import Foundation
import UIKit

struct AppSetting {
    static let id = "6472057066"
    static let email = "joeypanchal@gmail.com"
    static let homepage = "https://joeypanchal.github.io"
    static let privacy = "https://joeypanchal.github.io/privacy.html"
    static let list_ads = "https://quangphung4396.github.io/movieios.github.io/list-adses.json"
    static let key_movie_db = "194603623f3b6d81db9e7c24fa2feab7"
    static let titleNoti = "RINO Photo"
    static let contentNoti = "Craft posters effortlessly"
}

struct AdsId {
    public static var shared = AdsId()
    // MARK: - keys admob
    
    @LocalStorage(key: "admob_banner", value: "ca-app-pub-4345728927696445/1832274618")
    public var admob_banner: String
    
    @LocalStorage(key: "admob_inter", value: "ca-app-pub-4345728927696445/9519192942")
    public var admob_inter: String
    
    @LocalStorage(key: "admob_inter_splash", value: "ca-app-pub-4345728927696445/2531112767")
    public var admob_inter_splash: String
    
    @LocalStorage(key: "admob_reward", value: "ca-app-pub-4345728927696445/3012660192")
    public var admob_reward: String
    
    @LocalStorage(key: "admob_reward_interstitial", value: "ca-app-pub-4345728927696445/7355229883")
    public var admob_reward_interstitial: String
    
    @LocalStorage(key: "admob_small_native", value: "ca-app-pub-4345728927696445/3479338714")
    public var admob_small_native: String
    
    @LocalStorage(key: "admob_medium_native", value: "ca-app-pub-4345728927696445/9386496857")
    public var admob_medium_native: String
    
    @LocalStorage(key: "admob_manual_native", value: "ca-app-pub-4345728927696445/7000840815")
    public var admob_manual_native: String
    
    @LocalStorage(key: "admob_appopen", value: "ca-app-pub-4345728927696445/4134170174")
    public var admob_appopen: String
    
    // ?
    @LocalStorage(key: "applovin_id", value: "")
    public var applovin_id: String
}

let prefix_host_image = "https://image.tmdb.org/t/p/w500"
let prefix_host_themoviedb = "https://api.themoviedb.org/3/"
let prefixSrcImage = "data:image/jpeg;"
let _host = "https://subscene.com"

let iv = "6f9bbc19f78f980f"
let key = "cb4b10abaadd1e422b15ff7586307842"

public let emptylink = (try? "9EyuhW1AfiHgoKlhrQNq1NxtFIPvSqTsVkPHTHAxOZWgqMPCR2Rauq3LZbN8lc72".aesDecrypt()) ?? ""
public let cantplay = (try? "8SK+FERq/8fHVtMHjO1OubFXtWWwDqvemzrYnEs+F5Y=".aesDecrypt()) ?? ""
public let episodeisplay = (try? "dfAIRY8Cf8cpNuYhM6hxa5j4EIEaAvhUSqkUNgJyiPc=".aesDecrypt()) ?? ""
public let somethingwrong = (try? "Bdx+HFB35ZgYuxVnMnWxYg7W6Zid55vFc5AwCLiDE1r9sa8lnrCyRTGVD2i/zqInf7blRwC+8dtmJa9SiTzkfA==".aesDecrypt()) ?? ""
public let episodeFuture = (try? "dfAIRY8Cf8cpNuYhM6hxazY5fAUzsg2r5xFW0jAkWcw=".aesDecrypt()) ?? ""
public let moiveFuture = (try? "yXFsqDWvISu4ADEBdeTm9ue6tAw2XMDqlQNKCba3EP0=".aesDecrypt()) ?? ""

public typealias MoDictionary = [String:Any?]
public typealias MoAnyHashable = [AnyHashable : Any]

public enum MediaType: String {
    case movie
    case tv
}

enum PMError: Error, CustomNSError {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    case none
    
    var localizedDescription: String {
        switch self {
        case .apiError:
            return "Failed to fetch data"
        case .invalidEndpoint:
            return "Invalid endpoit"
        case .invalidResponse:
            return "Invalid response"
        case .noData:
            return "No data"
        case .serializationError:
            return "Failed to decode data"
        case .none:
            return "An error occurs"
        }
    }
    
    var errorUserInfo: [String : Any]{
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}
