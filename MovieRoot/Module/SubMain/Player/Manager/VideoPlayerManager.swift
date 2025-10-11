import AVFoundation
import UIKit

protocol VideoPlayerManagerDelegate: AnyObject {
    func videoPlayerManager(_ mgr: VideoPlayerManager, didChangePlaying isPlaying: Bool)
    func readyToPlay(isPlay: Bool)
    func videoPlayerManagerDidFinishPlaying(_ mgr: VideoPlayerManager, player: AVPlayerItem, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval)
    func videoPlayerManagerProgressPlaying(_ mgr: VideoPlayerManager, player: AVPlayerItem, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval, didUpdate currentTimeD: Double, duration: Double)
}

final class VideoPlayerManager: NSObject {
    private(set) var player = AVPlayer()
    private var timeObserver: Any?
    private var statusObserver: NSKeyValueObservation?
    private var endObserver: NSObjectProtocol?
    
    weak var delegate: VideoPlayerManagerDelegate?
    
    // Layer để gắn vào UIView hiển thị
    var playerLayer: AVPlayerLayer {
        return AVPlayerLayer(player: player)
    }
    
    deinit {
        removeObservers()
    }
    
    func load(url: URL, autoplay: Bool = false) {
        removeObservers()
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        
        // Quan sát trạng thái item để biết khi nào ready và lấy duration
        statusObserver = item.observe(\.status, options: [.initial, .new]) { [weak self] item, _ in
            guard let self else { return }
            switch item.status {
            case .readyToPlay:
                delegate?.readyToPlay(isPlay: true)
                self.startProgressUpdates()
                if autoplay { self.play() }
                self.notifyTimeUpdate()
            case .failed:
                delegate?.readyToPlay(isPlay: false)
            default:
                break
            }
        }
        
        // Quan sát kết thúc phát
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.delegate?.videoPlayerManagerDidFinishPlaying(self, player: item, playTimeDidChange: CMTimeGetSeconds(item.duration), totalTime: CMTimeGetSeconds(item.duration))
        }
    }
    
    func setSpeed(speed: Double) {
        player.rate = Float(speed)
        player.currentItem?.audioTimePitchAlgorithm = .spectral
    }
    
    func play() {
        player.play()
        delegate?.videoPlayerManager(self, didChangePlaying: true)
    }
    
    func pause() {
        player.pause()
        delegate?.videoPlayerManager(self, didChangePlaying: false)
    }
    
    func togglePlayPause() {
        if player.timeControlStatus == .playing { pause() } else { play() }
    }
    
    func volume(isMuted: Bool) {
        player.isMuted = isMuted
    }
    
    /// Tua +/- giây (ví dụ -10 hoặc +10)
    func seek(by seconds: Double) {
        let current = currentTime()
        let target = current + seconds
        seek(to: target)
    }
    
    /// Tua theo phần trăm slider (0...1)
    func seek(toPercent percent: Float) {
        let duration = durationTime()
        guard duration.isFinite && duration > 0 else { return }
        let target = Double(percent) * duration
        seek(to: target)
    }
    
    // MARK: - Helpers
    
    func currentTime() -> Double {
        return player.currentTime().seconds
    }
    
    func durationTime() -> Double {
        guard let item = player.currentItem else { return 0 }
        let dur = item.duration.seconds
        return dur.isFinite ? dur : 0
    }
    
    private func seek(to seconds: Double) {
        let duration = durationTime()
        let clamped = max(0, min(seconds, duration))
        let cm = CMTime(seconds: clamped, preferredTimescale: 600)
        player.seek(to: cm, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            self?.notifyTimeUpdate()
        }
    }
    
    private func startProgressUpdates() {
        // Cập nhật mỗi 0.5 giây
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            self?.notifyTimeUpdate()
        }
    }
    
    private func notifyTimeUpdate() {
        guard let item = player.currentItem else { return }

        let current = currentTime()
        let duration = durationTime()
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
                let totalTime = CMTimeGetSeconds(item.duration)
                
                delegate?.videoPlayerManagerProgressPlaying(
                    self,
                    player: item,
                    playTimeDidChange: currentTime,
                    totalTime: totalTime,
                    didUpdate: current,
                    duration: duration
                )
    }
    
    private func removeObservers() {
        if let timeObserver {
            player.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        statusObserver = nil
        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
            self.endObserver = nil
        }
    }
    
}
