import Foundation
import UIKit
import AVFoundation

 class PlayerView: UIView {
     private let playerLayer = AVPlayerLayer()
         private let loadingIndicator = UIActivityIndicatorView(style: .large)

         var player: AVPlayer? {
             get { playerLayer.player }
             set { playerLayer.player = newValue }
         }

         override init(frame: CGRect) {
             super.init(frame: frame)
             setup()
         }

         required init?(coder: NSCoder) {
             super.init(coder: coder)
             setup()
         }

         private func setup() {
             // Add player layer
             layer.addSublayer(playerLayer)

             // Setup loading indicator
             loadingIndicator.hidesWhenStopped = true
             loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
             addSubview(loadingIndicator)

             NSLayoutConstraint.activate([
                 loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                 loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
             ])
         }

         override func layoutSubviews() {
             super.layoutSubviews()
             playerLayer.frame = bounds
         }

         // MARK: - Public helpers
         func showLoading() {
             bringSubviewToFront(loadingIndicator)
             loadingIndicator.startAnimating()
         }

         func hideLoading() {
             loadingIndicator.stopAnimating()
         }
}
