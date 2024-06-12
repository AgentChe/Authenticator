//
//  CreateOrEditFieldFormatter.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 20.05.2024.
//

import UIKit

struct CreateOrEditFieldFormatter {
    static func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let selectedRange = textField.selectedTextRange, let text = textField.text, let rangeText = Range(range, in: text) else {
            return true
        }
        
        var currentPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)

        let newText = text.replacingCharacters(in: rangeText, with: string)

        currentPosition += string.isEmpty ? -(currentPosition - range.location) : string.count

        var clearedString = ""
        let originalCursorPosition = currentPosition

        newText
            .enumerated()
            .forEach { index, char in
                if !char.isWhitespace {
                    clearedString.append(char)
                } else if index < originalCursorPosition {
                    currentPosition -= 1
                }
            }

        var formatedValue = ""
        let currentCursor = currentPosition

        clearedString.enumerated().forEach { index, char in
            if index % 4 == 0 && index > 0 {
                formatedValue.append(" ")
                
                if index < currentCursor {
                    currentPosition += 1
                }
            }
            
            formatedValue.append(char)
        }

        textField.text = formatedValue
        textField.sendActions(for: .editingChanged)
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: currentPosition) {
            DispatchQueue.main.async {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
            }
        }

        return false
    }
}
