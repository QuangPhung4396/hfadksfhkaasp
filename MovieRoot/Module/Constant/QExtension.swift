import UIKit
import Kingfisher
import CommonCrypto
import CryptoSwift
import CryptoKit

extension UIFont {
    static func fontReular(_ size: CGFloat) -> UIFont? {
        return UIFont.systemFont(ofSize: size)
    }

    static func fontBold(_ size: CGFloat) -> UIFont? {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    static func fontSemiBold(_ size: CGFloat) -> UIFont? {
        return UIFont.boldSystemFont(ofSize: size)
    }
}

extension String {
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    
    var pathExtension: String {
        return fileURL.pathExtension
    }
    
    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }
    
    func trimming() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var toJson: MoDictionary? {
        let data = Data(self.utf8)
        
        do {
            // make sure this JSON is in the format we expect
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? MoDictionary
            return json
        } catch let error as NSError {
            print("Convert to JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    var toArrayJson: [MoDictionary]? {
        if let data = self.data(using: .utf8) {
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [MoDictionary]
                return result
            } catch { }
        }
        return nil
    }
    
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: .caseInsensitive) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }
}

extension Dictionary {
    func jsonString() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self)
        if let string = String(data: data, encoding: .utf8) {
            return string
        }
        throw NSError.make(code: 1002, userInfo: ["message": "Data cannot be converted to .utf8 string"])
    }
    
    func toData() throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: self)
        return data
    }
}

extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    
    static func createController<T: UIViewController>() -> T {
        return main.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}

// MARK: - UIColor
extension UIColor {
    static let shadow = UIColor(rgb: 0x8F8F8F).withAlphaComponent(0.8)
    
    convenience init(rgb: Int) {
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

     convenience init(hex: String, alpha: CGFloat = 1.0) {
         var hexValue = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

         if hexValue.hasPrefix("#") {
             hexValue.remove(at: hexValue.startIndex)
         }

         if hexValue.count != 6 {
             self.init(red: 0, green: 0, blue: 0, alpha: alpha)
             return
         }

         var rgbValue: UInt64 = 0
         Scanner(string: hexValue).scanHexInt64(&rgbValue)

         let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
         let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
         let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

         self.init(red: red, green: green, blue: blue, alpha: alpha)
     }
    
}

extension UIWindow {
    static var keyWindow: UIWindow? {
        // MARK: - iOS13 or later
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
            return windowScene.windows.first
        }
        else {
            // MARK: - iOS12 or earlier
            guard let appDelegate = UIApplication.shared.delegate else { return nil }
            return appDelegate.window ?? nil
        }
    }
    
    var topMost: UIViewController? {
        return UIWindow.keyWindow?.rootViewController
    }
}

extension UIApplication {
    static func findTopController(root: UIViewController? = UIWindow.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = root as? UINavigationController {
            return findTopController(root: nav.visibleViewController)
        }
        else if let tab = root as? UITabBarController, let selected = tab.selectedViewController {
            return findTopController(root: selected)
        }
        else if let presented = root?.presentedViewController {
            return findTopController(root: presented)
        }
        return root
    }
    
    static  func orientation() -> UIInterfaceOrientation {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return .unknown
            }
            return windowScene.interfaceOrientation
        }
        else {
            return UIApplication.shared.statusBarOrientation
        }
    }
    
    class func getTopController(base: UIViewController? = UIWindow.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopController(base: presented)
        }
        return base
    }
}

extension UIView {
    func roundTopLeftRight(radius: CGFloat, color: UIColor = .black, offset: CGSize = .zero) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
    func setImageBackground() {
        backgroundColor = .shadow
    }
}

extension UIButton {
    func addBlurEffect() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubviewToFront(imageView)
        }
    }
}

extension UIImage {
    class func original(_ name: String) -> UIImage? {
        return UIImage(named: name)?.withRenderingMode(.alwaysOriginal)
    }
    
    func blurred(radius: CGFloat) -> UIImage {
        let ciContext = CIContext(options: nil)
        guard let cgImage = cgImage else { return self }
        let inputImage = CIImage(cgImage: cgImage)
        guard let ciFilter = CIFilter(name: "CIGaussianBlur") else { return self }
        ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
        ciFilter.setValue(radius, forKey: "inputRadius")
        guard let resultImage = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
        guard let cgImage2 = ciContext.createCGImage(resultImage, from: inputImage.extent) else { return self }
        return UIImage(cgImage: cgImage2)
    }
    
    convenience init?(imgName name: String) {
        self.init(named: name, in: Bundle.current, compatibleWith: nil)
    }
}

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let minutes = (time) % 60
        let hours = (time / 60)
        return String(format: "%0.2d:%0.2d:00",hours,minutes)
    }
}

extension UIDevice {
    var is_iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

extension Encodable {
    func toJSONString() -> String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}

extension UICollectionViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func registerItem<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
}

extension UICollectionReusableView {
    static var cellID: String {
        return String(describing: self)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell {
    static var cellId: String {
        return String(describing: self)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UILabel {
    func labelTwoColor(title: String, colorTitle: UIColor, fontTitle: UIFont? = nil, detail: String, colorDetail: UIColor, fontDetail: UIFont? = nil) {
        let ss = "\(title)\(detail)"
        let attributed = NSMutableAttributedString(string: ss)
        
        // title
        let range1 = NSString(string: ss).range(of: title)
        attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: colorTitle, range: range1)
        attributed.addAttribute(NSAttributedString.Key.font, value: (fontTitle ?? UIFont.fontReular(12))!, range: range1)
        
        // detail
        let range2 = NSString(string: ss).range(of: detail)
        attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: colorDetail, range: range2)
        attributed.addAttribute(NSAttributedString.Key.font, value: (fontDetail ?? UIFont.fontReular(12))!, range: range2)
        
        self.attributedText = attributed
    }
}

extension UITableView {
    public func reloadDataAndKeepOffset() {
        // stop scrolling
        setContentOffset(contentOffset, animated: false)
            
        // calculate the offset and reloadData
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        let afterContentSize = contentSize
            
        // reset the contentOffset after data is updated
        let newOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height))
        setContentOffset(newOffset, animated: false)
    }
    
    func registerItem<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func registerItemNib<T: UITableViewCell>(cell: T.Type) {
        let nib = UINib(nibName: T.identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let cell = dequeueReusableCell(withIdentifier: T.identifier) as! T
        return cell
    }
    
}
extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}

extension UIImageView {
    func loadImage(url: URL?){
        if (url != nil) {
            self.kf.setImage(with: url!)
        }
    }
}

extension Date {
    public func toSring() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: Date())
    }
}

extension String {
    public func aesEncrypt() throws -> String {
        let encrypted = try AES(key: key, iv: iv, padding: .pkcs7).encrypt([UInt8](self.data(using: .utf8)!))
        return Data(encrypted).base64EncodedString()
    }
    
    public func aesDecrypt() throws -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        let decrypted = try AES(key: key, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
        return String(bytes: decrypted, encoding: .utf8)
    }
    
    func sha256() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            return stringData.sha256()
        }
        return ""
    }
    
    func toDictionary() -> MoDictionary? {
        if let data = self.data(using: .utf8) {
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? MoDictionary
                return result
            } catch { }
        }
        return nil
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.date(from: self)
    }
    
    func md5() -> String {
        if #available(iOS 13.0, *) {
            guard let d = self.data(using: .utf8) else { return ""}
            let digest = Insecure.MD5.hash(data: d)
            let h = digest.reduce("") { (res: String, element) in
                let hex = String(format: "%02x", element)
                let  t = res + hex
                return t
            }
            return h
            
        } else {
            // Fall back to pre iOS13
            let length = Int(CC_MD5_DIGEST_LENGTH)
            var digest = [UInt8](repeating: 0, count: length)
            
            if let d = self.data(using: .utf8) {
                _ = d.withUnsafeBytes { body -> String in
                    CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)
                    return ""
                }
            }
            let result = (0 ..< length).reduce("") {
                $0 + String(format: "%02x", digest[$1])
            }
            return result
            
        }
    }
}

extension Data {
    public func sha256() -> String{
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        return hexString
    }
}

extension Dictionary {
    func toJson() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self)
        if let string = String(data: data, encoding: .utf8) {
            return string
        }
        throw NSError(domain: "Dictionary", code: 1, userInfo: ["message": "Data cannot be converted to .utf8 string"])
    }
}

extension UIViewController {
    
    func changeSupportedOrientation() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        switch delegate.`orientation` {
        case .portrait:
            delegate.orientation = .landscapeLeft
        default:
            delegate.orientation = .portrait
        }
    }
    
    private func showAlertConfirm(title: String, message: String? = nil, okAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            okAction()
        }))
        present(alert, animated: true)
    }
    
    func alertPlayback(onReport: @escaping () -> Void) {
        let alert = UIAlertController(title: "Opps!", message: somethingwrong, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.addAction(UIAlertAction(title: "Report", style: .default, handler: { _ in
            onReport()
        }))
        present(alert, animated: true)
    }
    
    public func alertNotLink(onReport: @escaping () -> Void) {
        let alert = UIAlertController(title: "Opps!", message: emptylink, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
            onReport()
        }))
        present(alert, animated: true)
    }
    
    func alertReport(message: String? = nil, okAction: @escaping () -> Void) {
        showAlertConfirm(title: "Report", message: message, okAction: okAction)
    }
    
    private func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    public func alertNotice(message: String? = nil) {
        showAlert(title: "Notice", message: message)
    }
    
    public func alertWarning(message: String? = nil) {
        showAlert(title: "Warning", message: message)
    }
    
    public func alertError(message: String? = nil) {
        showAlert(title: "Error", message: message)
    }
    
    func add(_ child: UIViewController, frame: CGRect? = nil) {
            addChild(child)

            if let frame = frame {
                child.view.frame = frame
            }

            view.addSubview(child.view)
            child.didMove(toParent: self)
        }

        func remove() {
            willMove(toParent: nil)
            view.removeFromSuperview()
            removeFromParent()
        }
    
}

extension UIColor {
    static func by(r: Int, g: Int, b: Int, a: CGFloat = 1) -> UIColor {
        let d = CGFloat(255)
        return UIColor(red: CGFloat(r) / d, green: CGFloat(g) / d, blue: CGFloat(b) / d, alpha: a)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit, thumbnail: UIImage? = nil) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async() { [weak self] in
                    self?.image = thumbnail
                }
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit, thumbnail: UIImage? = nil) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode, thumbnail: thumbnail)
    }
}

extension UIImage {
    static func getImage(_ name: String) -> UIImage? {
        let bundle = UtilService.bundle()
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
}

extension UIButton {
    func set(active: Bool) {
        isSelected = active
    }
}
