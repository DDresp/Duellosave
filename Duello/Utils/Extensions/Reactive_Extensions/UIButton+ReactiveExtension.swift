//
//  UIButton+ReactiveExtension.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    
    public var titleColor: Binder<UIColor> {
        return Binder(self.base, binding: { (button, color) in
            button.setTitleColor(color, for: .normal)
        })
    }
    
}

