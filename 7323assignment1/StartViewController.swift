import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var fontSizeStepper: UIStepper!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var countdownTimer: Timer?
    var countdownValue: Int = 5
    var imageIndex = 0
    
    let images: [UIImage] = [
        UIImage(named: "Book1")!,
        UIImage(named: "Book2")!,
        UIImage(named: "Book3")!,
        UIImage(named: "Book4")!,
        UIImage(named: "Book5")!,
        UIImage(named: "Book6")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Stepper settings
        fontSizeStepper.minimumValue = 10
        fontSizeStepper.maximumValue = 30
        fontSizeStepper.stepValue = 1
        fontSizeStepper.value = 20
        fontSizeLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSizeStepper.value))
        
        // Set initial image and countdown
        imageView.image = images[imageIndex]
        countdownLabel.text = "\(countdownValue)"
        
        // Initialize countdown timer to update every second
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    @IBAction func fontSizeStepperChanged(_ sender: UIStepper) {
        let newFontSize = CGFloat(sender.value)
        fontSizeLabel.font = UIFont.systemFont(ofSize: newFontSize)
    }
    
    @objc func updateCountdown() {
        countdownValue -= 1
        countdownLabel.text = "\(countdownValue)"
        
        if countdownValue == 0 {
            changeImage()
            countdownValue = 5  // Reset countdown
        }
    }
    
    @objc func changeImage() {
        imageIndex = (imageIndex + 1) % images.count
        imageView.image = images[imageIndex]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        countdownTimer?.invalidate()
    }
}

