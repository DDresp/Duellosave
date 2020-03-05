//
//  UploadUserTableViewController.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxCocoa
import RxSwift
import JGProgressHUD
import CropViewController

class UploadUserTableViewController<T: UploadUserDisplayer>: UploadTableViewController<T>, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    //MARK: - Variables
    var datasource: UploadUserDatasource?
    var delegate: UploadUserDelegate?
    
    //MARK: - Setup
    init(displayer: T) {
        super.init(style: .grouped)
        self.displayer = displayer
        self.datasource = UploadUserDatasource(displayer: displayer)
        self.delegate = UploadUserDelegate(displayer: displayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationItems()
        setupBindablesToDisplayer()
        setupBindablesFromDisplayer()
    }
    
    private func setupTableView() {
        
        view.backgroundColor = EXTREMELIGHTGRAYCOLOR
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        tableView.allowsSelection = false
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.dataSource = datasource
        tableView.delegate = delegate
        
    }
    
    private func setupNavigationItems() {
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = submitButton
        navigationItem.title = "Profile Settings"
        navigationItem.rightBarButtonItem?.tintColor = NAVBARCOLOR
        
    }
    
    //MARK: - Views
    lazy var submitButton = UIBarButtonItem(title: "Submit", style: .done, target: nil, action: nil)
    lazy var cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: nil, action: nil)
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    //MARK: - Interactions
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    //MARK: - Delegation
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.originalImage] as? UIImage
        
        guard let image = img else {
            picker.dismiss(animated: true)
            return
        }
        let cropViewController = CropViewController(croppingStyle: .circular, image: image)
        cropViewController.delegate = self
        let progressHud = JGProgressHUD(style: .dark)
        progressHud.textLabel.text = "loading"
        progressHud.show(in: picker.view)
        picker.present(cropViewController, animated: true) {
            progressHud.dismiss(animated: false)
        }
        
    }
    
    //TODO: check if cropViewController variable might be necessary
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        displayer?.getUploadUserHeaderDisplayer().image.accept(image.withRenderingMode(.alwaysOriginal))
        let blurView = ProfileImageSuccessView()
        blurView.alpha = 0
        cropViewController.view.addSubview(blurView)
        blurView.fillSuperview()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            blurView.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true)
            }
        }
        
    }
    
    //MARK: - Reactive
    private func setupBindablesToDisplayer() {
        
        guard let displayer = displayer else { return }
        submitButton.rx.tap.asDriver().drive(displayer.submitTapped).disposed(by: disposeBag)
        cancelButton.rx.tap.asDriver().drive(displayer.cancelTapped).disposed(by: disposeBag)
        
    }
    
    private func setupBindablesFromDisplayer() {
        
        displayer?.showImagePickerView.asObservable().subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.displayer?.isLoading.accept(true)
            self.present(self.imagePicker, animated: true, completion: {
                self.displayer?.isLoading.accept(false)
            })
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
