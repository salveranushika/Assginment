import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial brightness level
        brightnessSlider.value = Float(UIScreen.main.brightness)
        
        // Retrieve dark mode setting from UserDefaults
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        darkModeSwitch.isOn = isDarkMode
        overrideUserInterfaceStyle = isDarkMode ? .dark : .light

        // Check if the user's birthday is saved
        if let savedDate = UserDefaults.standard.object(forKey: "userBirthday") as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            birthdayLabel.text = "My Birthday: \(dateFormatter.string(from: savedDate))"
            datePicker.date = savedDate
        } else {
            birthdayLabel.text = "My Birthday: Not set"
            datePicker.date = Date()
        }
        
        // Add listener for changes in DatePicker's value
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // Retrieve saved gender from UserDefaults
        if let savedGender = UserDefaults.standard.string(forKey: "userGender") {
            selectedGender = savedGender
            switch savedGender {
            case "male":
                genderSegmentedControl.selectedSegmentIndex = 0
            case "female":
                genderSegmentedControl.selectedSegmentIndex = 1
            case "non-binary":
                genderSegmentedControl.selectedSegmentIndex = 2
            default:
                genderSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
            }
        } else {
            genderLabel.text = "My gender is __"
        }
        
        // Hide the segmented control initially
        genderSegmentedControl.isHidden = true

        // Add tap gesture to gender label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        genderLabel.isUserInteractionEnabled = true
        genderLabel.addGestureRecognizer(tapGesture)
        
        // Update gender label display
        updateGenderLabel()
    }
    
    @IBAction func brightnessSliderChanged(_ sender: UISlider) {
        UIScreen.main.brightness = CGFloat(sender.value)
    }
    
    @IBAction func darkModeSwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
            overrideUserInterfaceStyle = .dark
            UserDefaults.standard.set(true, forKey: "isDarkMode")
        } else {
            overrideUserInterfaceStyle = .light
            UserDefaults.standard.set(false, forKey: "isDarkMode")
        }
        
        // Notify other view controllers of dark mode change
        NotificationCenter.default.post(name: NSNotification.Name("DarkModeChanged"), object: nil)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let selectedDate = dateFormatter.string(from: sender.date)
        birthdayLabel.text = "My Birthday: \(selectedDate)"
        UserDefaults.standard.set(sender.date, forKey: "userBirthday")
    }
    
    var selectedGender: String? {
        didSet {
            if let gender = selectedGender {
                genderLabel.text = "My gender is \(gender)"
                updateGenderLabel()
                genderSegmentedControl.isHidden = true
            }
        }
    }
    
    @objc func labelTapped() {
        genderSegmentedControl.isHidden = false
    }
    
    @IBAction func genderSelectionChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedGender = "male"
            UserDefaults.standard.set("male", forKey: "userGender")
        case 1:
            selectedGender = "female"
            UserDefaults.standard.set("female", forKey: "userGender")
        case 2:
            selectedGender = "non-binary"
            UserDefaults.standard.set("non-binary", forKey: "userGender")
        default:
            break
        }
        UserDefaults.standard.synchronize()
    }
    
    func updateGenderLabel() {
        let genderText = selectedGender ?? "__"
        let fullText = "My gender is \(genderText)"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let range = (fullText as NSString).range(of: genderText)
        attributedString.addAttribute(.backgroundColor, value: UIColor.systemBlue.withAlphaComponent(0.3), range: range)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: range)
        genderLabel.attributedText = attributedString
    }
}
