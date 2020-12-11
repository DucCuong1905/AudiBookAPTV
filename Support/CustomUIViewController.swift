//
//  CustomUIViewController.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/16/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//


// Thực hiện việc di duyển các nút mà không cần chúng nó phải sếp thẳng hàng với nhau
import Foundation
extension UIViewController {
    func addFocusGuide(from origin: UIView, to destination: UIView, direction: UIRectEdge) -> UIFocusGuide {
        let focusGuide = UIFocusGuide()
        view.addLayoutGuide(focusGuide)
        focusGuide.preferredFocusEnvironments = [destination]

        // Configure size to match origin view
        focusGuide.widthAnchor.constraint(equalTo: origin.widthAnchor).isActive = true
        focusGuide.heightAnchor.constraint(equalTo: origin.heightAnchor).isActive = true

        switch direction {
        case .bottom: // swipe down
            focusGuide.topAnchor.constraint(equalTo: origin.bottomAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
        case .top: // swipe up
            focusGuide.bottomAnchor.constraint(equalTo: origin.topAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
        case .left: // swipe left
            focusGuide.topAnchor.constraint(equalTo: origin.topAnchor).isActive = true
            focusGuide.rightAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
        case .right: // swipe right
            focusGuide.topAnchor.constraint(equalTo: origin.topAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: origin.rightAnchor).isActive = true
        default:
            
            
            // Not supported :(
            break
        }

        return focusGuide
    }
}
