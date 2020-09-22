//
//  BookingViewController.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 27.07.2017.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import UIKit

@objc protocol BookingViewControllerDelegate : class {
    func callRestaurant()
}

@objc class BookingViewController: UIViewController {
    @objc let maxPhoneLength = 12
    @objc weak var delegate : BookingViewControllerDelegate?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var requestBookingButton: UIButton!
    @IBOutlet weak var dateField: PickerTextField!
    @IBOutlet weak var timeField: PickerTextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var numberField: PickerTextField!
    @IBOutlet weak var requestTextView: UITextView!
    
    @IBOutlet weak var dateFieldContainer: UIView!
    @IBOutlet weak var timeFieldContainer: UIView!
    @IBOutlet weak var numberFieldContainer: UIView!
    @IBOutlet weak var phoneNumberContainer: UIView!
    
    @objc var venue: DMVenue?
    
    var loading = false {
        didSet {
            manageLoading()
        }
    }
    
    private func manageLoading() {
        requestBookingButton.setTitle(loading ? "" : "Request Booking", for: .normal)
        spinner.isHidden = !loading
        
        if loading {
            spinner.startAnimating()
        }
    }
    
    @IBAction func sendBookingInfo(_ sender: Any) {
        
        guard let phone = phoneField.text else {
            showWarningWith(title: "Sorry", message: "Phone number is required")
            return
        }
        
        if phone.isEmpty {
            showWarningWith(title: "Sorry", message: "Phone number is required")
            return
        }
        
        guard let date = self.dateField.selectedDate, let time = self.timeField.selectedDate, let number = self.numberField.selectedNumber, let selectedId = self.venue?.primitiveModelID() else { return }
        guard let bookingDate = self.combineDateWithTime(date: date, time: time) else { return }
        
        if checkIfTodayDate(date: bookingDate) {
            if !canBookForTodayAction() {
                return
            }
        }
        
        let request = DMVenueRequest()
        
        loading = true
        request.postBooking(selectedId as NSNumber, date: bookingDate.iso8601, number: number as NSNumber, clientDesc: self.requestTextView.text, phone: phone) { (error, data) in
            DispatchQueue.main.async {
                let title = error == nil ? "Thank you!" : "Sorry"
                let message = error == nil ? "Thank you for your booking request. The restaurant will contact you asap to confirm your booking. If not confirmed please contact the restaurant directly." : "Something went wrong, please try again or call venue"
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.modalPresentationStyle = .overFullScreen
                self.present(alertController, animated: true, completion: nil)
                self.loading = false
            }
        }
    }
    
    private func canBookForTodayAction()->Bool {
        if let bookingToday = venue?.booking_today_allow.boolValue {
            if bookingToday {
                return true
            }
        }
        
        guard let phone = venue?.phone_number() else {
            showWarningWith(title: "Sorry", message: "You can't book for today")
            return false
        }
        
        if phone.isEmpty {
            showWarningWith(title: "Sorry", message: "You can't book for today")
            return false
        }
        
        let alertController = UIAlertController(title: "", message: "Sorry, this venue prefers you call for bookings on the same day to avoid disappointment", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Call venue to book now", style: .destructive, handler: { (_) in
            DispatchQueue.main.async {
                self.delegate?.callRestaurant()
            }
        }))
        
        self.modalPresentationStyle = .overFullScreen
        self.present(alertController, animated: true, completion: nil)
        
        return false
    }
    
    private func checkIfTodayDate(date : Date)->Bool {
        return NSCalendar.current.isDateInToday(date)
    }
    
    private func showWarningWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.modalPresentationStyle = .overFullScreen
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.title = self.venue?.name() ?? ""
        timeField.pickerDelegate = self
        self.timeField.datePickerTextField = self.dateField
        self.phoneField.keyboardType = .phonePad
        self.phoneField.delegate = self
        if let maxPeople = self.venue?.booking_max_people.intValue {
            self.numberField.maxRows = maxPeople > 0 ? maxPeople : 1
        }
        
        phoneNumberContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneContainerClicked)))
        dateFieldContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateContainerClicked)))
        timeFieldContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timeContainerClicked)))
        numberFieldContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(numberContainerClicked)))
        
        manageLoading()
    }
    
    @objc private func phoneContainerClicked() {
        phoneField.becomeFirstResponder()
    }
    
    @objc private func dateContainerClicked() {
        dateField.becomeFirstResponder()
    }
    
    @objc private func timeContainerClicked() {
        timeField.becomeFirstResponder()
    }
    
    @objc private func numberContainerClicked() {
        numberField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        
        return calendar.date(from: mergedComponments)
    }
    
}

extension BookingViewController : PickerTextFieldDelegate {
    func getStartDate() -> Date {
        if let dateFieldDate = dateField.selectedDate {
            return dateFieldDate
        }
        return Date()
    }
}

extension BookingViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxPhoneLength
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return formatter
    }()
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
}
