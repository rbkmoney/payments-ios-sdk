// Copyright 2019 RBKmoney
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import RxCocoa
import RxSwift
import UIKit

final class BankCardCardNumberFormatter: NSObject {

    // MARK: - Internal
    var maxLength: Int?

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let selectedRange = textField.selectedTextRange, let text = textField.text, let textRange = Range(range, in: text) else {
            return true
        }

        // Начальная позиция курсора
        var currentPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)

        // Добавляем новый символ в указанную позицию
        let newText = text.replacingCharacters(in: textRange, with: string)

        // Пересчитываем положение курсора в зависимости от добавленного или удаленного символа
        currentPosition += string.isEmpty ? -1 : string.count

        var digitsString = ""
        let originalCursorPosition = currentPosition

        // Избавляемся от пробелов и перерасчитываем положение курсора
        for index in Swift.stride(from: 0, to: newText.count, by: 1) {
            let characterToAdd = newText[newText.index(newText.startIndex, offsetBy: index)]

            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsString.append(characterToAdd)
            } else if index < originalCursorPosition {
                currentPosition -= 1
            }
        }

        if let length = maxLength, length < digitsString.count {
            digitsString = String(digitsString.prefix(length))

            if currentPosition + string.count < length {
                currentPosition += string.count
            } else {
                currentPosition = length
            }
        }

        // Добавляем символы пробела перед каждой группой цифр, перерасчитываем положение курсора
        var formatedNumber = ""
        let currentCursor = currentPosition

        for index in 0 ..< digitsString.count {
            if index % 4 == 0 && index > 0 {
                formatedNumber.append(" ")

                if index < currentCursor {
                    currentPosition += 1
                }
            }

            let char = digitsString[digitsString.index(digitsString.startIndex, offsetBy: index)]
            formatedNumber.append(char)
        }

        // Генерируем событие изменения текста
        textField.text = nil
        textField.insertText(formatedNumber)

        // Устанавливаем актуальную позицию курсора
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: currentPosition) {
            DispatchQueue.main.async {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
            }
        }

        return false
    }
}

extension Reactive where Base: BankCardCardNumberFormatter {

    var maxLength: Binder<Int?> {
        return Binder(base) { base, length in
            base.maxLength = length
        }
    }
}
