//
//  VideoPlayer.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift

class VideoPlayer: UIView  {
    
    //MARK: - Displayer
    var displayer: VideoPlayerDisplayer? {
        didSet {
            
            videoView.displayer = displayer
            disposeBag = DisposeBag()
            setupBindablesToDisplayer()
            setupBindablesFromDisplayer()
            
        }
    }
    
    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addGestureRecognizer(oneTapGesture)
        
        setupLayout()
        
    }
    
    //MARK: - Views
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = VERYLIGHTGRAYCOLOR
        return imageView
    }()
    
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return view
    }()
    
    private let videoIcon: UIImageView = {
        let image = #imageLiteral(resourceName: "videoIcon").withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = VERYLIGHTGRAYCOLOR
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let playIcon: UIImageView = {
        let image = #imageLiteral(resourceName: "playIcon").withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = VERYLIGHTGRAYCOLOR
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let oneTapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        return tap
    }()
    
    private let videoView: VideoView = {
        let videoView = VideoView()
        return videoView
    }()
    
    //MARK: - Layout
    private func setupLayout() {
        
        addSubview(thumbnailImageView)
        thumbnailImageView.fillSuperview()
        thumbnailImageView.addSubview(shadowView)
        shadowView.fillSuperview()
        thumbnailImageView.addSubview(videoIcon)
        videoIcon.anchor(top: thumbnailImageView.topAnchor, leading: nil, bottom: nil, trailing: thumbnailImageView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 10), size: .init(width: 30, height: 30))
        thumbnailImageView.addSubview(playIcon)
        playIcon.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 50, height: 50))
        playIcon.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor).isActive = true
        playIcon.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor).isActive = true
        
        addSubview(videoView)
        videoView.fillSuperview()
        
    }
    
    //MARK: - Reactive
    private var disposeBag = DisposeBag()
    
    private func setupBindablesToDisplayer() {
        guard let displayer = displayer else { return }
        oneTapGesture.rx.event.map { (_) -> Void in
            return ()
        }.bind(to: displayer.tappedVideo).disposed(by: disposeBag)
    }
    
    private func setupBindablesFromDisplayer() {
        guard let displayer = displayer else { return }
        
        displayer.playVideoRequested.subscribe(onNext: { [weak self ] (playVideoRequested) in
            
            UIView.animate(withDuration: 0.7, delay: 0, options: [AnimationOptions.allowUserInteraction], animations: {
                self?.thumbnailImageView.isHidden = playVideoRequested
                
                if playVideoRequested {
                    self?.videoView.isHidden = false
                    self?.videoView.alpha = 100
                } else {
                    self?.videoView.isHidden = true
                }
                
            }, completion: { (_) in
                if !playVideoRequested {
                    self?.videoView.alpha = 0
                }
            })
            
        }).disposed(by: disposeBag)
        
        displayer.thumbnailImage.subscribe(onNext: { [weak self] (thumbnailImage) in
            self?.thumbnailImageView.image = thumbnailImage
        }).disposed(by: disposeBag)
        
        displayer.thumbnailUrl.subscribe(onNext: { [weak self] (thumbnailUrl) in
            guard let url = thumbnailUrl else { return }
            self?.thumbnailImageView.sd_setImage(with: url)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(displayer.thumbnailImage, displayer.thumbnailUrl).map { (image, url) -> Bool in
            return image == nil && url == nil
            }.bind(to: rx.isHidden).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
