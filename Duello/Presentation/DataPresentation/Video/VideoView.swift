//
//  VideoView.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa
import AVFoundation

class VideoView: UIView {
    
    //MARK: - Displayer
    var displayer: VideoPlayerDisplayer? {
        didSet {
            
            self.disposeBag = DisposeBag()
            self.activityIndicatorView.startAnimating()
            self.playerLayer.player = nil
            self.setupBindablesFromDisplayer()
            self.setupBindablesToDisplayer()
            
        }
        
    }
    
    //MARK: - Variables
    var playerLooper: AVPlayerLooper?
    var player: AVQueuePlayer = AVQueuePlayer()
    var playerItem: AVPlayerItem?
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    //MARK: - Views
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let soundIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = VERYLIGHTGRAYCOLOR
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let oneTapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        return tap
    }()

    lazy var soundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(oneTapGesture)
        return view
    }()
    
    lazy var playBackSlider: CustomSlider = {
       let slider = CustomSlider()
        slider.backgroundColor = .clear
        slider.setThumbImage(UIImage(), for: .normal)
        slider.minimumValue = 0
        slider.isContinuous = true
        slider.minimumTrackTintColor = .gray
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderEnded), for: .touchUpInside)
        return slider
    }()
    
    //MARK: - Interactions
    @objc func sliderEnded(_ playBackSlider: UISlider) {
        let floatedSeconds = Float64(playBackSlider.value)
        let timeScale = player.currentItem?.asset.duration.timescale ?? 1
        let targetTime = CMTimeMakeWithSeconds(floatedSeconds, preferredTimescale: timeScale)
        player.seek(to: targetTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        player.play()
    }
    
    @objc func sliderChanged(_ playBackSlider: UISlider, event: UIEvent) {
        player.pause()
    }
    
    //MARK: - Layout
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    private func setupLayout() {
        
        addSubview(controlsContainerView)
        controlsContainerView.fillSuperview()
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(soundView)
        soundView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, size: .init(width: 50, height: 50))
        soundView.addSubview(soundIcon)
        soundIcon.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 30, height: 30))
        soundIcon.centerInSuperview()
        
        controlsContainerView.addSubview(playBackSlider)
        playBackSlider.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: -5, bottom: 0, right: -5), size: .init(width: 0, height: 30))
        
    }
    
    //MARK: - Methods
    private func startVideo() {

        guard let url = displayer?.getVideoUrl() else { return }
        
        playerItem = AVPlayerItem(url: url)
        
        let duration = self.playerItem?.asset.duration

        let seconds = CMTimeGetSeconds(duration ?? CMTimeMake(value: 0, timescale: 0))
        let floatseconds = Float(seconds)
        
        playBackSlider.maximumValue = floatseconds
        player = AVQueuePlayer(playerItem: self.playerItem)
        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] (time) in
            guard let self = self else { return }
            if self.player.rate == 0 {
                return
            }
            if self.player.currentItem?.status == .readyToPlay {
                let time = CMTimeGetSeconds(self.player.currentTime())
                self.player.currentTime()
                self.playBackSlider.setValue(Float(time), animated: false)
            }
        })
        player.isMuted = displayer?.isMuted.value ?? true
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem!)
        playerLayer.player = player
        player.seek(to: CMTime.zero)
        player.play()
        activityIndicatorView.stopAnimating()
    }
    
    private func stopVideo() {
        player.seek(to: CMTime.zero)
        playBackSlider.value = 0
        player.pause()
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        oneTapGesture.rx.event.asObservable().map { (_) -> () in
            return ()
            }.bind(to: displayer.tappedSoundIcon).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromDisplayer() {
        guard let displayer = displayer else { return }
        
        let isMuted = displayer.isMuted.share(replay: 2, scope: .whileConnected)
        
        isMuted.map { (isMuted) -> UIImage? in
            if isMuted {
                return UIImage(named: "soundoffIcon")?.withRenderingMode(.alwaysTemplate)
            } else {
                return UIImage(named: "soundonIcon")?.withRenderingMode(.alwaysTemplate)
            }
            }.flatMap { (image) -> Observable<UIImage> in
                return Observable.from(optional: image)
            }.bind(to: soundIcon.rx.image).disposed(by: disposeBag)
        
        isMuted.subscribe(onNext: { [weak self] (isMuted) in
            if isMuted {
                self?.player.isMuted = true
            } else {
                self?.player.isMuted = false
            }
        }).disposed(by: disposeBag)
        
        displayer.shouldPlayVideo.subscribe(onNext: { [weak self] (shouldPlayVideo) in
            if shouldPlayVideo {
                self?.startVideo()
            } else {
                self?.stopVideo()
            }
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
