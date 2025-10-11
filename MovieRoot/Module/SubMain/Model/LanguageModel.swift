import Foundation

struct LanguageModel: Encodable, Decodable {
    let code: String
    let name: String
    let id: String
}

func instantiate<T: Decodable>(jsonString: String) -> T? {
    return try? JSONDecoder().decode(T.self, from: jsonString.data(using: .utf8)!)
}

func getLanguages() -> [LanguageModel] {
    var listLanguage = [LanguageModel]()
    listLanguage.append(LanguageModel(code: "en", name: "English", id: "sublanguageid-eng"))
    listLanguage.append(LanguageModel(code: "ar", name: "Arabic", id: "sublanguageid-ara"))
    listLanguage.append(LanguageModel(code: "zh", name: "Chinese", id: "sublanguageid-chi"))
    listLanguage.append(LanguageModel(code: "hr", name: "Croatian", id: "sublanguageid-hrv"))
    listLanguage.append(LanguageModel(code: "nl", name: "Dutch", id: "sublanguageid-dut"))
    listLanguage.append(LanguageModel(code: "no", name: "Norwegian", id: "sublanguageid-nor"))
    listLanguage.append(LanguageModel(code: "fr", name: "French", id: "sublanguageid-fre"))
    listLanguage.append(LanguageModel(code: "de", name: "German", id: "sublanguageid-ger"))
    listLanguage.append(LanguageModel(code: "el", name: "Greek", id: "sublanguageid-ell"))
    listLanguage.append(LanguageModel(code: "he", name: "Hebrew", id: "sublanguageid-heb"))
    listLanguage.append(LanguageModel(code: "it", name: "Italian", id: "sublanguageid-ita"))
    listLanguage.append(LanguageModel(code: "id", name: "Indonesia", id: "sublanguageid-ind"))
    listLanguage.append(LanguageModel(code: "ja", name: "Japanese", id: "sublanguageid-jpn"))
    listLanguage.append(LanguageModel(code: "la", name: "Latin", id: "sublanguageid-lav"))
    listLanguage.append(LanguageModel(code: "pl", name: "Polish", id: "sublanguageid-pol"))
    listLanguage.append(LanguageModel(code: "pt", name: "Portuguese", id: "sublanguageid-por"))
    listLanguage.append(LanguageModel(code: "ro", name: "Romanian", id: "sublanguageid-rum"))
    listLanguage.append(LanguageModel(code: "ru", name: "Russian", id: "sublanguageid-rus"))
    listLanguage.append(LanguageModel(code: "es", name: "Spanish", id: "sublanguageid-spa"))
    listLanguage.append(LanguageModel(code: "sr", name: "Serbian", id: "sublanguageid-scc"))
    listLanguage.append(LanguageModel(code: "sv", name: "Swedish", id: "sublanguageid-swe"))
    listLanguage.append(LanguageModel(code: "th", name: "Thai", id: "sublanguageid-tha"))
    listLanguage.append(LanguageModel(code: "tr", name: "Turkish", id: "sublanguageid-tur"))
    listLanguage.append(LanguageModel(code: "ukr", name: "Ukrainian", id: "sublanguageid-ukr"))
    listLanguage.append(LanguageModel(code: "vi", name: "Vietnamese", id: "sublanguageid-vie"))
    return listLanguage
}
let englishLanguage = LanguageModel(code: "en", name: "English", id: "sublanguageid-eng")
