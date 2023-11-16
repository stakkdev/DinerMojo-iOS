//
//  PickerTextField.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 28.09.2017.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import UIKit

fileprivate enum PickerMode {
    case date
    case time
    case number
}

protocol PickerTextFieldDelegate: class {
    func getStartDate()->Date
}

class PickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    fileprivate var mode: PickerMode = .date
    private var datePicker = UIDatePicker()
    private var numberPicker = UIPickerView()
    weak var pickerDelegate: PickerTextFieldDelegate?
    var datePickerTextField: PickerTextField?
    var selectedDate: Date?
    var selectedNumber: Int?
    var maxRows : Int?
    
    @IBInspectable var date: Bool = false {
        didSet {
            if date {
                self.mode = .date
            }
        }
    }
    
    @IBInspectable var time: Bool = false {
        didSet {
            if time {
                self.mode = .time
            }
        }
    }
    
    @IBInspectable var number: Bool = false {
        didSet {
            if number {
                self.mode = .number
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let row = row + 1
        self.text = "\(row) \(row == 1 ? ("person") : ("people"))"
        self.selectedNumber = row
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let maxRows = maxRows {
            return maxRows
        }
        
        return 30
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @objc func didChangeDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateFormat = self.mode == .date ? "dd-MM-yyyy" : "h:mm a"
        
        let future15Min = getDateFromFutureWithMinValue(value: 15)
        let dateToUse = self.datePicker.date < future15Min ? future15Min : self.datePicker.date
        
        self.text = dateFormatter.string(from: dateToUse)
        self.selectedDate = dateToUse
    }
    
    private func getDateFromFutureWithMinValue(value: Int)->Date {
        let calendar = Calendar.current
        var dateToUse = Date()
        var nextDiff = value - calendar.component(.minute, from: dateToUse) % value
        
        if let delegate = pickerDelegate {
            dateToUse = delegate.getStartDate()
        
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: dateToUse)
            let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: datePicker.date)
            var mergedComponments = DateComponents()
            mergedComponments.year = dateComponents.year!
            mergedComponments.month = dateComponents.month!
            mergedComponments.day = dateComponents.day!
            mergedComponments.hour = timeComponents.hour!
            mergedComponments.minute = timeComponents.minute!
            mergedComponments.second = timeComponents.second!
            let mergedDate = calendar.date(from: mergedComponments)!
            
            
            nextDiff = value - calendar.component(.minute, from: mergedDate) % value
            if nextDiff == value {
                nextDiff = 0
            }
            datePicker.date = calendar.date(byAdding: .minute, value: nextDiff, to: mergedDate)!
            dateToUse = datePicker.date
            nextDiff = 0
            
        }
        
        let newDate = calendar.date(byAdding: .minute, value: nextDiff, to: dateToUse) ?? dateToUse
        return newDate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if inputView == nil {
            self.delegate = self.mode == .time ? self : nil
            switch self.mode {
            case .date, .time:
                
                let futureAverage15MinDate = getDateFromFutureWithMinValue(value: 15)
                self.datePicker.setDate(futureAverage15MinDate, animated: false)
                self.selectedDate = futureAverage15MinDate
                self.didChangeDate()
                self.datePicker.minimumDate = futureAverage15MinDate
                self.datePicker.locale = Locale(identifier: "en_US")
                self.datePicker.datePickerMode = self.mode == .date ? .date : .time
                self.datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
                if #available(iOS 13.4, *) {
                    self.datePicker.preferredDatePickerStyle = .wheels
                }
                if self.mode == .time {
                    self.datePicker.minuteInterval = 15
                }
                
                self.inputView = self.datePicker
            case .number:
                self.numberPicker.delegate = self
                self.numberPicker.dataSource = self
                self.selectedNumber = 1
                self.numberPicker.selectRow(0, inComponent: 0, animated: false)
                self.inputView = self.numberPicker
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let date = self.datePickerTextField?.selectedDate {
            let order = Calendar.current.compare(date, to: Date(), toGranularity: .day)
            if order == .orderedDescending {
                self.datePicker.minimumDate = nil
            } else {
                self.datePicker.minimumDate = Date()
            }
        }
    }
    
}
