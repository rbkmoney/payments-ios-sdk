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

final class BankCardExpirationDatePickerView: UIView {

    // MARK: - Types
    struct ExpirationDate {
        let month: Int
        let year: Int
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Private
    private func initialize() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        embedSubview(pickerView)

        pickerView.dataSource = self
        pickerView.delegate = self

        // Симулируем бесконечный барабан месяцев. На самом деле в нем будет Constants.numberOfMonthRows элементов.
        // Выбираем в качестве начального значения что-то близкое к середине.
        let initialMonthRow = Constants.numberOfMonthRows / 2 / Constants.monthsPerYear * Constants.monthsPerYear +
                              validMonthsRange.lowerBound % Constants.monthsPerYear

        pickerView.selectRow(initialMonthRow, inComponent: Constants.monthComponent, animated: false)
    }

    private lazy var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = .current

        return calendar
    }()

    private lazy var validMonthsRange: ClosedRange<Int> = {
        let components = calendar.dateComponents([.month, .year], from: Date())

        guard let month = components.month, let year = components.year else {
            fatalError("Failed to get current month and year")
        }

        let minMonth = year * Constants.monthsPerYear + (month - 1)
        let maxMonth = minMonth + Constants.monthsRangeLength - 1

        return minMonth ... maxMonth
    }()

    private lazy var monthNames: [String] = calendar.standaloneMonthSymbols

    private let pickerView = UIPickerView()

    fileprivate let didSelectDate = PublishRelay<ExpirationDate>()
}

extension Reactive where Base: BankCardExpirationDatePickerView {

    var didSelectDate: Signal<Base.ExpirationDate> {
        return base.didSelectDate.asSignal()
    }
}

extension BankCardExpirationDatePickerView.ExpirationDate {

    var formattedString: String {
        return String(format: "%02d", month) + "/" + "\(year)".suffix(2)
    }
}

extension BankCardExpirationDatePickerView: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let monthRow = pickerView.selectedRow(inComponent: Constants.monthComponent)
        let yearRow = pickerView.selectedRow(inComponent: Constants.yearComponent)

        let year = validMonthsRange.lowerBound / Constants.monthsPerYear + yearRow
        var month = monthRow % Constants.monthsPerYear + 1

        let value = year * Constants.monthsPerYear + (month - 1)

        if validMonthsRange.contains(value) == false {
            let candidats: [Int?]

            if value < validMonthsRange.lowerBound {
                candidats = [
                    validMonthsRange.lowerBound % Constants.monthsPerYear + 1,
                    validMonthsRange.map({ $0 % Constants.monthsPerYear + 1 }).max()
                ]
            } else {
                candidats = [
                    validMonthsRange.map({ $0 % Constants.monthsPerYear + 1 }).min(),
                    validMonthsRange.upperBound % Constants.monthsPerYear + 1
                ]
            }

            let monthRowsRange = 0 ..< Constants.numberOfMonthRows

            let tuple = candidats
                .compactMap { $0 }
                .flatMap { element -> [(row: Int, month: Int)] in
                    let delta = month - element
                    let row = monthRow - (delta < 0 ? delta + Constants.monthsPerYear : delta)
                    return [(row, element), (row + Constants.monthsPerYear, element)]
                }
                .filter { monthRowsRange.contains($0.row) }
                .min { abs($0.row - monthRow) < abs($1.row - monthRow) }

            if let tuple = tuple {
                month = tuple.month
                pickerView.selectRow(tuple.row, inComponent: Constants.monthComponent, animated: true)
            }
        }

        didSelectDate.accept(ExpirationDate(month: month, year: year))

        // Если выбрали другой год, то перезагружаем барабан месяцев с целью обновления цвета элементов.
        if component == Constants.yearComponent {
            pickerView.reloadComponent(Constants.monthComponent)
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard component == Constants.monthComponent else {
            let year = validMonthsRange.lowerBound / Constants.monthsPerYear + row
            return "\(year)".attributed(with: .enabled)
        }

        let yearRow = pickerView.selectedRow(inComponent: Constants.yearComponent)
        let month = row % Constants.monthsPerYear
        let value = (validMonthsRange.lowerBound / Constants.monthsPerYear + yearRow) * Constants.monthsPerYear + month

        return monthNames[month].attributed(with: validMonthsRange.contains(value) ? .enabled : .disabled)
    }
}

extension BankCardExpirationDatePickerView: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard component == Constants.yearComponent else {
            return Constants.numberOfMonthRows
        }

        let firstYear = validMonthsRange.lowerBound / Constants.monthsPerYear
        let lastYear = validMonthsRange.upperBound / Constants.monthsPerYear

        return lastYear - firstYear + 1
    }
}

private enum Constants {

    static let yearsRangeLength: Int = 15
    static let monthsPerYear: Int = 12
    static let monthsRangeLength: Int = yearsRangeLength * monthsPerYear

    static let monthComponent: Int = 0
    static let yearComponent: Int = 1

    static let numberOfMonthRows: Int = 250 * 2 * monthsPerYear
}

private extension TextAttributes {

    static let disabled = TextAttributes().textColor(.lightGray)
    static let enabled = TextAttributes().textColor(.black)
}
