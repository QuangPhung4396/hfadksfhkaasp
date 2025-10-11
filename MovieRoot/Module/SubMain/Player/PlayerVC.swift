import UIKit
import AVFoundation
import AVKit
import SnapKit

class PlayerVC: UIViewController {
    
    var lbSub: PLabel = PLabel()
    var playerView: PlayerView = PlayerView()
    
    var titleStackView: UIStackView = UIStackView()
    var btnClose = UIButton()
    var lbName = UILabel()
    var btnAirScreen: AVRoutePickerView = AVRoutePickerView()
    
    var lockView: UIView = UIView()
    var itemLockView: UIView = UIView()
    var btnLock: UIButton = UIButton()
    var imageLock: UIImageView = UIImageView()
    var lbLock: UILabel = UILabel()
    var lbLockDetail: UILabel = UILabel()
    
    var controlView: PView = PView()
    var actionStackView: UIStackView = UIStackView()
    var btnTogether: UIButton = UIButton()
    var btnSkip: UIButton = UIButton()
    var btnForward: UIButton = UIButton()
    var btnVolume: UIButton = UIButton()
    var btnServer: UIButton = UIButton()
    var btnSetting: UIButton = UIButton()
    var sliderView: CustomSlider = CustomSlider()
    var lbTotalTime: PLabel = PLabel()
    
    private let manager = VideoPlayerManager()
    private var hideWorkItem: DispatchWorkItem?
    private var isMuted = false
    
    var tvId: Int = 0
    var imdbid: String = ""
    var season: Int?
    var episode: TelevisionEpisode?
    var seasons: [TelevisionSeason] = []
    var episodes: [TelevisionEpisode] = []
    var name: String = ""
    var year: Int = 0
    var type: MediaType = .movie
    public var data: [MoDictionary] = []
    var source: [ContentDetail] = []
    var speed = 1.0
    var isShowCap = true
    var urlSelect = ""
    var isFirstSelectUrl = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        btnAirScreen.tintColor = UIColor.white
        
        self.view.addSubview(playerView)
        self.playerView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.view.addSubview(titleStackView)
        self.titleStackView.distribution = .fill
        self.titleStackView.backgroundColor = .clear
        self.titleStackView.axis = .horizontal
        self.titleStackView.alignment = .fill
        
        self.titleStackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        self.btnClose.snp.makeConstraints { make in
            make.width.equalTo(56)
        }
        
        self.btnAirScreen.snp.makeConstraints { make in
            make.width.equalTo(56)
        }
        self.btnClose.setImage(UIImage(named: "ic_qback_player"), for: .normal)
        self.btnClose.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        self.titleStackView.addArrangedSubview(btnClose)
        self.titleStackView.addArrangedSubview(lbName)
        self.titleStackView.addArrangedSubview(btnAirScreen)
        self.lbName.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.lbName.textColor = UIColor.white
        if(type == .movie) {
            lbName.text = name
        }else {
            lbName.text = episode?.name
        }
        self.btnClose.addTarget(self, action: #selector(actionClose), for: .touchUpInside)
        
        self.view.addSubview(controlView)
        controlView.cornerRadius = 15
        controlView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.controlView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(32)
        }
        self.controlView.addSubview(actionStackView)
        self.view.addSubview(lbSub)
        
        self.actionStackView.distribution = .fill
        self.actionStackView.backgroundColor = .clear
        self.actionStackView.axis = .horizontal
        self.actionStackView.alignment = .fill
        self.actionStackView.spacing = 8
        self.actionStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview().offset(0)
        }
        
        self.lbSub.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.bottom.equalTo(self.controlView.snp.top).offset(-16)
        }
        
        self.btnTogether.snp.makeConstraints { make in
            make.width.equalTo(32)
        }
        
        self.lbTotalTime.textColor = UIColor.white
        self.lbTotalTime.text = "00:00/00:00"
        self.lbTotalTime.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        self.lbTotalTime.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(32)
        }
        
        self.btnSkip.snp.makeConstraints { make in
            make.width.equalTo(32)
        }
        
        self.btnForward.snp.makeConstraints { make in
            make.width.equalTo(32)
        }
        
        self.btnVolume.snp.makeConstraints { make in
            make.width.equalTo(32)
        }
        
        self.btnServer.snp.makeConstraints { make in
            make.width.equalTo(32)
        }
        
        self.btnSetting.snp.makeConstraints { make in
            make.width.equalTo(32)
        }
        
        btnTogether.addTarget(self, action: #selector(actionTogether), for: .touchUpInside)
        btnSkip.addTarget(self, action: #selector(actionPrevius10), for: .touchUpInside)
        btnForward.addTarget(self, action: #selector(actionNext10), for: .touchUpInside)
        btnVolume.addTarget(self, action: #selector(actionVolume), for: .touchUpInside)
        btnServer.addTarget(self, action: #selector(actionServer), for: .touchUpInside)
        btnSetting.addTarget(self, action: #selector(actionSetting), for: .touchUpInside)
        
        self.actionStackView.addArrangedSubview(btnTogether)
        self.actionStackView.addArrangedSubview(sliderView)
        self.actionStackView.addArrangedSubview(lbTotalTime)
        self.actionStackView.addArrangedSubview(btnSkip)
        self.actionStackView.addArrangedSubview(btnForward)
        self.actionStackView.addArrangedSubview(btnVolume)
        self.actionStackView.addArrangedSubview(btnServer)
        self.actionStackView.addArrangedSubview(btnSetting)
        
        self.sliderView.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        self.btnTogether.setImage(UIImage(named: "ic_play_video"), for: .normal)
        self.btnSkip.setImage(UIImage(named: "ic_previus_10"), for: .normal)
        self.btnForward.setImage(UIImage(named: "ic_next_10"), for: .normal)
        self.btnVolume.setImage(UIImage(named: "ic_volume_on"), for: .normal)
        self.btnServer.setImage(UIImage(named: "ic_server_sub"), for: .normal)
        self.btnSetting.setImage(UIImage(named: "ic_settings"), for: .normal)
        self.btnVolume.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        self.btnServer.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.btnSetting.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom:4, right: 4)
        
        self.view.addSubview(lockView)
        self.lockView.backgroundColor = UIColor.clear
        self.lockView.isHidden = true
        self.lockView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.lockView.addSubview(itemLockView)
        self.itemLockView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-60)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(80)
        }
        self.itemLockView.addSubview(btnLock)
        self.btnLock.backgroundColor = UIColor.clear
        self.btnLock.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.itemLockView.addSubview(imageLock)
        self.imageLock.image = UIImage(named: "ic-lock")
        self.imageLock.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        self.itemLockView.addSubview(lbLock)
        self.lbLock.text = "Screen Locked"
        self.lbLock.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        self.lbLock.textColor = UIColor.white
        self.lbLock.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(22)
            make.top.equalTo(self.imageLock.snp.bottom).offset(2)
        }
        
        self.itemLockView.addSubview(lbLockDetail)
        self.lbLockDetail.text = "Tap to Unlock"
        self.lbLockDetail.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.lbLockDetail.textColor = UIColor.white
        self.lbLockDetail.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(22)
            make.top.equalTo(self.lbLock.snp.bottom).offset(2)
        }
        
        self.btnLock.addTarget(self, action: #selector(actionUnlock), for: .touchUpInside)
        
        prepareData()
        
        if let s = source.first, let sFirst = s.sources.first, let url = URL(string: sFirst.file) {
            self.urlSelect = sFirst.file
            manager.delegate = self
            playerView.showLoading()
            manager.load(url: url, autoplay: true)
            playerView.player = manager.player
        }
        sliderView.trackHeight = 5
        sliderView.thumbRadius = 10
        sliderView.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.5)
        sliderView.thumbTintColor = UIColor.white
        sliderView.minimumTrackTintColor = UIColor.white
        sliderView.minimumValue = 0
        sliderView.maximumValue = 1
        sliderView.value = 0
        
        lbSub.isHidden = !isShowCap
        
        lbSub.translatesAutoresizingMaskIntoConstraints = false
        lbSub.backgroundColor = UIColor.clear
        lbSub.textAlignment = .center
        lbSub.numberOfLines = 0
        let fontSize = UIDevice.current.userInterfaceIdiom == .pad ? 35.0 : 20.0
        lbSub.font = UIFont.boldSystemFont(ofSize: fontSize)
        lbSub.textColor = .white
        lbSub.layer.shadowColor = UIColor.black.cgColor
        lbSub.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        lbSub.layer.shadowOpacity = 0.9
        lbSub.layer.shadowRadius = 1.0
        lbSub.layer.shouldRasterize = true
        lbSub.layer.rasterizationScale = UIScreen.main.scale
        lbSub.lineBreakMode = .byWordWrapping
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLockView))
        lockView.addGestureRecognizer(tapGesture)
        lockView.isUserInteractionEnabled = true
        
    }
    
    private var language: LanguageModel {
        set {
            let str = newValue.toJSONString()
            UserDefaults.standard.set(str, forKey: "subtitle-language-default")
            UserDefaults.standard.synchronize()
        }
        get {
            var lang: LanguageModel?
            if let str = UserDefaults.standard.string(forKey: "subtitle-language-default") {
                lang = instantiate(jsonString: str)
            }
            return lang ?? englishLanguage
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeSupportedOrientation()
        lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        UIDevice.current.setValue(UIDeviceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        self.playerView.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lockOrientation(.all, andRotateTo: .portrait)
        UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    @objc private func didTapLockView() {
        showItemLockView()
    }
    
     func lockOrientation(_ orientation: UIInterfaceOrientationMask,
                                   andRotateTo rotateOrientation:UIInterfaceOrientation) {
           
           if let delegate = UIApplication.shared.delegate as? AppDelegate {
               delegate.orientation = orientation
           }
           
           UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
           UINavigationController.attemptRotationToDeviceOrientation()
       }
    
    
    private func prepareData() {
        source.removeAll()
        for item in data {
            if let _sources = item["sources"] as? [MoDictionary] {
                
                var sourcesNew: [LinkVideo] = []
                for j in _sources {
                    let source = LinkVideo.createInstance(j)
                    if sourcesNew.filter({$0.file == source.file}).isEmpty {
                        sourcesNew.append(LinkVideo.createInstance(j))
                    }
                }
                
                var tracksNew: [Subtitle] = []
                if let _tracks = item["tracks"] as? [MoDictionary] {
                    for j in _tracks {
                        let sub = Subtitle.createInstance(j)
                        if sub.label.contains(self.language.name) {
                            tracksNew.append(sub)
                        }
                    }
                }
                
                source.append(ContentDetail(sources: sourcesNew, tracks: tracksNew))
            }
        }
        findOpenSubtitle()
    }
    
    private func format(_ seconds: Double) -> String {
           guard seconds.isFinite && seconds >= 0 else { return "00:00" }
           let s = Int(seconds.rounded())
           let mm = s / 60
           let ss = s % 60
           return String(format: "%02d:%02d", mm, ss)
    }
 
    
    private func findOpenSubtitle() {
        Task {
            do {
                try await GetSubtitle.shared.findOpenSubtitleAsync(
                    self.name,
                    year: self.year,
                    provider: "opensubtitle",
                    imdbid: self.imdbid,
                    season: season,
                    episode: episode?.episode_number ?? 0,
                    lang: self.language.code,
                    langName: self.language.name
                )

                await MainActor.run {
                    if GetSubtitle.shared.onSubtitles.count > 0 {
                        let listSubLanguge = GetSubtitle.shared.onSubtitles
                        GetSubtitle.shared.subtitleSelected = listSubLanguge.first
                    }
                }
            } catch {
            }
        }
    }
    
   
    private func showItemLockView() {
        hideWorkItem?.cancel()
        
        itemLockView.isHidden = false
        itemLockView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.itemLockView.alpha = 1
        }
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.3, animations: {
                self.itemLockView.alpha = 0
            }, completion: { _ in
                self.itemLockView.isHidden = true
            })
        }
        
        hideWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
    }
    
    @objc func actionTogether() {
        manager.togglePlayPause()
    }
    @objc func sliderChanged(_ sender: UISlider) {
        manager.seek(toPercent: sender.value)
    }
    
    @objc func actionClose() {
        self.dismiss(animated: true)
    }
    
    @objc func actionPrevius10() {
        manager.seek(by: -10)
    }
    
    @objc func actionNext10() {
        manager.seek(by: +10)
    }
    
    @objc func actionVolume() {
        isMuted = !isMuted
        manager.volume(isMuted: isMuted)
        
        let imageName = isMuted ?  "ic_volume_off" : "ic_volume_on"
        btnVolume.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @objc func actionServer() {
        let vc = ServerPopupVC()
        vc.list = source
        vc.urlSelected = self.urlSelect
        vc.serverPopupBlock = { pack, tracks in
            guard URL(string: pack.file) != nil else { return }
            self.urlSelect = pack.file
            self.playerView.showLoading()
            self.manager.load(url: URL(string: pack.file)!, autoplay: true)
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @objc func actionSetting() {
        let vc = SettingVideoPopupVC()
        vc.language = language
        vc.speed = speed
        vc.isShowCap = self.isShowCap
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc func actionUnlock() {
        titleStackView.isHidden = false
        controlView.isHidden = false
        lockView.isHidden = true
    }
}

extension PlayerVC: VideoPlayerManagerDelegate, SettingVideoDelegate {
    func selectSwitch(isOn: Bool) {
        self.isShowCap = isOn
        self.lbSub.isHidden = !isOn
    }
    
    func lockScreen() {
        titleStackView.isHidden = true
        controlView.isHidden = true
        
        // Hiện lock view
        lockView.isHidden = false
        showItemLockView()
    }
    
    func selectSpeed() {
        let vc = SpeedVideoPopupVC()
        vc.speed = speed
        vc.speedVideoPopupBlock = { value in
            self.speed = value
            self.manager.setSpeed(speed: value)
        }
        self.present(vc, animated: true)
    }
    
    func videoPlayerManagerProgressPlaying(_ mgr: VideoPlayerManager, player: AVPlayerItem, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval, didUpdate currentTimeD: Double, duration: Double) {
        if duration > 0 {
            sliderView.value = Float(currentTimeD / duration)
        } else {
            sliderView.value = 0
        }
        
        lbTotalTime.text = format(currentTimeD) + " / " + format(duration)
        
        guard let subtitle = GetSubtitle.shared.subtitleSelected else {
            self.lbSub.text = nil
            return
        }
        if let webVTT = subtitle.webVTTCache {
            let subText = webVTT.searchSubtitles(time: Double(currentTime))
            self.lbSub.text = subText
            return
        }
        guard !GetSubtitle.shared.isDownloading else { return }
        GetSubtitle.shared.isDownloading = true
        Task {
            do {
                var webVTT: SubDetails?
                webVTT = try await GetSubtitle.shared.downloadSubSRTAsync(link: subtitle.file)
                if let webVTT = webVTT {
                    await MainActor.run {
                        GetSubtitle.shared.subtitleSelected = subtitle.withWebVTTCache(webVTT)
                    }
                    let subText = webVTT.searchSubtitles(time: Double(currentTime))
                    self.lbSub.text = subText

                } else {
                    self.lbSub.text = nil
                }
            } catch {
                self.lbSub.text = nil
            }
            GetSubtitle.shared.isDownloading = false
        }
    }
    
    func videoPlayerManager(_ mgr: VideoPlayerManager, didUpdate currentTime: Double, duration: Double) {
        // Cập nhật slider & label
        
    }
    
    func videoPlayerManager(_ mgr: VideoPlayerManager, didChangePlaying isPlaying: Bool) {
        btnTogether.setImage(isPlaying ? UIImage(named: "ic_play_video") : UIImage(named: "ic_pause_video"), for: .normal)
    }
    
    func videoPlayerManagerDidFinishPlaying(_ mgr: VideoPlayerManager, player: AVPlayerItem, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        btnTogether.setImage(UIImage(named: "ic_pause_video"), for: .normal)
    }
   
    func readyToPlay(isPlay: Bool) {
        if (isPlay) {
            isFirstSelectUrl = false
            self.playerView.hideLoading()
        } else {
            if !isFirstSelectUrl {
                self.playerView.hideLoading()
                self.alertPlayback { [weak self] in
                    guard self != nil else { return }
                }
            } else {
                var checkPlayNext = false
                
                var listLink: [LinkVideo] = [LinkVideo]()
                
                for items in self.source {
                    for item in items.sources {
                        listLink.append(item)
                    }
                }
                
                for index in 0..<listLink.count {
                    if listLink[index].file == self.urlSelect {
                        if index + 1 < listLink.count {
                            checkPlayNext = true
                            let sFirst = listLink[index + 1]
                            if let url = URL(string: sFirst.file) {
                                guard URL(string: sFirst.file) != nil else { return }
                                self.urlSelect = sFirst.file
                                self.playerView.showLoading()
                                self.manager.load(url: url, autoplay: true)
                            }
                            break
                        }
                    }
                }
                
                if !checkPlayNext {
                    isFirstSelectUrl = false
                    self.alertPlayback { [weak self] in
                        guard self != nil else { return }
                    }
                }
            }
        }
    }
    
    // MARK: translete language
    func selectTransleteLanguage() {
        let vc = LanguagePopupVC()
        vc.language = language
        vc.transleteLanguagePopupBlock = { language in
            self.language = language
            self.findOpenSubtitle()
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}
