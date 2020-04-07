//
//  PostCell.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

class PostCell<T: PostDisplayer>: UICollectionViewCell {

    //MARK: - Displayer
    var displayer: T?

    //MARK: - Variables
    var mediaViewHeightConstraint: NSLayoutConstraint?

    //MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = EXTREMELIGHTGRAYCOLOR
        setupLayout()
    }

    //MARK: - Views
    var mediaView = UIView() //The specific PostCells will inject their media content in this cell (images, video etc)
    private var deactivatedView = DeactivatedView()

    //Labels
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        label.textColor = DARKGRAYCOLOR
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.lightCustomFont(size: VERYSMALLFONTSIZE)
        label.textColor = DARKGRAYCOLOR
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DARKGRAYCOLOR
        label.font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.lightCustomFont(size: SMALLFONTSIZE)
        label.numberOfLines = 3
        return label
    }()

    //ImageViews
    private let profileImageView: SmallProfileImageView = {
        let iv = SmallProfileImageView(frame: .zero)
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.borderColor = LIGHTGRAYCOLOR.cgColor
        iv.layer.borderWidth = 0.5
        return iv
    }()

    private lazy var profileImageViewContainer: SmallProfileImageViewContainer = {
        let view = SmallProfileImageViewContainer()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        view.addSubview(profileImageView)
        profileImageView.fillSuperview()
        return view
    }()

    //Buttons
    private let ellipsisButtonTapped: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        return tap
    }()

    private let ellipsisButton: EllipsisButton = {
        let button = EllipsisButton(type: .system)
        let ellipsisIcon = #imageLiteral(resourceName: "ellipsisButton").withRenderingMode(.alwaysTemplate)
        button.setImage(#imageLiteral(resourceName: "ellipsisButton").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = DARKGRAYCOLOR
        button.isUserInteractionEnabled = false
        return button
    }()

    private lazy var ellipsisButtonContainer: EllipsisButtonContainer = {
        let view = EllipsisButtonContainer()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(ellipsisButtonTapped)
        view.addSubview(ellipsisButton)
        ellipsisButton.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: STANDARDSPACING))
        ellipsisButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()

    let showMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("show more", for: .normal)
        button.setTitleColor(FACEBOOKBLUECOLOR, for: .normal)
        button.titleLabel?.font = UIFont.boldCustomFont(size: SMALLFONTSIZE)
        button.contentHorizontalAlignment = .left
        button.isHidden = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 5, right: 0)
        return button
    }()

    //ViewControllers
    var socialMediaController: SocialMediaCollectionViewController = {
        let viewController = SocialMediaCollectionViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        viewController.view.isHidden = true
        return viewController
    }()

    //StackViews
    private lazy var credentialsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, categoryLabel])
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return stackView
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageViewContainer, credentialsStackView, ellipsisButtonContainer])
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    lazy var bottomTextStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, showMoreButton])
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: STANDARDSPACING, bottom: 0, right: STANDARDSPACING)
        return stackView
    }()

    lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bottomTextStackView, socialMediaController.view])
        stackView.spacing = 15
        stackView.axis = .vertical
        return stackView
    }()

    //Interactive Views
    let likePercentageView: LikePercentageView = {
        let likeView = LikePercentageView()
        return likeView
    }()

    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isHidden = true
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(oneTapGesture)
        return blurView
    }()

    //MARK: - Interactions
    //Gestures
    private let oneTapGesture: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.numberOfTapsRequired = 1
        return gestureRecognizer
    }()

    lazy var doubleTapGesture: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.numberOfTapsRequired = 2
        gestureRecognizer.require(toFail: oneTapGesture)
        return gestureRecognizer
    }()

    let feedBackGenerator = UIImpactFeedbackGenerator(style: .medium)

    //MARK: - Layout
    
    private func setupLayout() {

        //Layout StackViews
        contentView.addSubview(headerStackView)
        contentView.addSubview(bottomStackView)
        headerStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: STANDARDSPACING, bottom: 0, right: 0))
        headerStackView.alignment = .center

        bottomStackView.anchor(top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: STANDARDSPACING, right: 0))

        //Layout Media View
        contentView.addSubview(mediaView)
        mediaView.anchor(top: headerStackView.bottomAnchor, leading: contentView.leadingAnchor, bottom: bottomStackView.topAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: STANDARDSPACING, right: 0))

        mediaViewHeightConstraint = mediaView.heightAnchor.constraint(equalToConstant: frame.width)
        mediaViewHeightConstraint?.isActive = true

        //Layout Deactivated View
        contentView.addSubview(deactivatedView)
        deactivatedView.anchor(top: headerStackView.bottomAnchor, leading: contentView.leadingAnchor, bottom: bottomStackView.topAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: STANDARDSPACING, right: 0))

        //Layout Interactive Views
        mediaView.addSubview(blurView)
        blurView.fillSuperview()

        blurView.contentView.addSubview(likePercentageView)
        likePercentageView.anchor(top: blurView.contentView.topAnchor, leading: blurView.contentView.leadingAnchor, bottom: nil, trailing: blurView.contentView.trailingAnchor)
        likePercentageView.heightAnchor.constraint(equalToConstant: 17).isActive = true

    }

    //MARK: - Methods

    func fit() {
        guard let displayer = displayer else { return }

        setupText(displayer: displayer)
        layoutSocialMedia(displayer: displayer)
        updateExpansion(displayer: displayer)
        updateMediaHeight(displayer: displayer)
        layoutIfNeeded()

    }

    func configure() {

        disposeBag = DisposeBag()
        guard let displayer = self.displayer else { return }
        updateMediaHeight(displayer: displayer)
        contentView.frame = bounds
        
        layoutIfNeeded()
        
        setupText(displayer: displayer)
        setupProfileImage(displayer: displayer)
        setupSocialMedia(displayer: displayer)
        setupLikeView(displayer: displayer)
        updateExpansion(displayer: displayer)

        layoutIfNeeded()

        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()

    }

    private func setupText(displayer: T) {
        categoryLabel.text = displayer.categoryName
        nameLabel.text = displayer.userName
        titleLabel.text = displayer.title
        descriptionLabel.text = displayer.description
    }

    private func setupProfileImage(displayer: T) {
        guard let url = URL(string: displayer.userProfileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
    }

    private func setupSocialMedia(displayer: T) {
        socialMediaController.displayer = displayer.socialMediaDisplayer
        layoutSocialMedia(displayer: displayer)
    }

    private func layoutSocialMedia(displayer: T) {
        if displayer.userHasSocialMediaNames {
            socialMediaController.view.isHidden = false
        } else {
            socialMediaController.view.isHidden = true
        }
    }

    private func setupLikeView(displayer: T) {
        if displayer.showLikeView.value {
            blurView.isHidden = false
            likePercentageView.showLikeView(percentage: displayer.rate)
        } else {
            blurView.isHidden = true
        }
    }

    private func updateExpansion(displayer: T) {

        if displayer.didExpand.value {
            descriptionLabel.numberOfLines = 0
            showMoreButton.isHidden = true

        } else {
            showMoreButton.isHidden = false

            if descriptionLabel.calculateMaxLines() > 3 {
                descriptionLabel.numberOfLines = 2
                showMoreButton.isHidden = false
            } else {
                descriptionLabel.numberOfLines = 3
                showMoreButton.isHidden = true
            }
        }

    }
    
    private func updateMediaHeight(displayer: T) {
        var mediaRatio = displayer.mediaRatio
        mediaRatio = max(mediaRatio, MINMEDIAHEIGHTRATIO)
        mediaRatio = min(mediaRatio, MAXMEDIAHEIGHTRATIO)
        mediaViewHeightConstraint?.constant = frame.width * CGFloat(mediaRatio)
    }

    //MARK: - Reactive
    var disposeBag = DisposeBag()

    func setupBindablesToDisplayer() {

        guard let displayer = displayer else { return }

        ellipsisButtonTapped.rx.event.map { (_) -> Void in
            return ()
        }.bind(to: displayer.tappedEllipsis).disposed(by: disposeBag)

        showMoreButton.rx.tap.asObservable().map { (_) -> Bool in
            return true
        }.bind(to: displayer.didExpand).disposed(by: disposeBag)

        doubleTapGesture.rx.event.do(onNext: { [weak self] (_) in
            self?.feedBackGenerator.impactOccurred()
        }).map { (_) -> Void in
            return ()
        }.bind(to: displayer.doubleTapped).disposed(by: disposeBag)

        oneTapGesture.rx.event.filter { [weak self] (_) -> Bool in
            //shouldn't interrupt current animation
            if self?.likePercentageView.isAnimating == true {
                return false
            } else {
                return true
            }
        }.map { (_) -> Void in
            return()
        }.bind(to: displayer.likeBlurViewTapped).disposed(by: disposeBag)

    }

    func setupBindablesFromDisplayer() {

        guard let displayer = displayer else { return }

        displayer.didExpand.asObservable().subscribe(onNext: { [weak self] (isExpanded) in
            guard let displayer = self?.displayer else { return }
            self?.updateExpansion(displayer: displayer)
        }).disposed(by: disposeBag)

        displayer.showLikeView.subscribe(onNext: { [weak self] (showLikeView) in
            if showLikeView {
                self?.blurView.isHidden = false
                self?.likePercentageView.showLikeViewAnimation(percentage: self?.displayer?.rate ?? 0, duration: 0.45, fromStart: true)
            } else {
                self?.blurView.isHidden = true
            }
        }).disposed(by: disposeBag)

        displayer.isDeactivated.map { (isDeactivated) -> Bool in
            return !isDeactivated
        }.bind(to: deactivatedView.rx.isHidden).disposed(by: disposeBag)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
