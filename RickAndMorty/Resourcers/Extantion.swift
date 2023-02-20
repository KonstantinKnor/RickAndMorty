//
//  Extantion.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 19.02.2023.
//

import UIKit
extension UIView {
func addSubviews(_ views: UIView...){
    views.forEach({
        addSubview($0)
    })
    }
}
