import UIKit
import AVKit
import AVFoundation

class PlayerView: UIView {
    var spinner = UIActivityIndicatorView(style: .medium)

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }

    var player: AVPlayer? {
        get {
            playerLayer.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {

            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                if spinner.superview == nil {
                    self.addSpinner()
                }
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .playing || newStatus == .paused {
                        self!.spinner.stopAnimating()
                    } else {
                        self!.spinner.startAnimating()
                    }
                }
            }

        }
    }

    func addSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    }
}

