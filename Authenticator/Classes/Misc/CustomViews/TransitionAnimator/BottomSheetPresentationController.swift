//
//  BottomSheetPresentationController.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 29.04.2024.
//

import UIKit

class BottomSheetPresentationController: DimmedPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView,
            let presentedView = presentedView else { return .zero }
    
        let containerFrame = containerView.bounds
        
        let targetWidth = containerFrame.width
        let fittingSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )
        let targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize, withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow).height
            
        var frame = containerFrame
        frame.origin.y += frame.size.height - targetHeight
        frame.size.width = targetWidth
        frame.size.height = targetHeight
        return frame
    }
}
