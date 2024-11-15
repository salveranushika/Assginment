import UIKit

class BookTableViewController: UITableViewController {

    var books: [[String: String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load book data
        if let loadedBooks = BookData.getBooks() as? [[String : String]] {
            books = loadedBooks
        }
        
        // Add Observer for Dark mode changes
        NotificationCenter.default.addObserver(self, selector: #selector(updateDarkMode), name: NSNotification.Name("DarkModeChanged"), object: nil)
        
        // Set initial display style based on UserDefaults
        overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
        
        // Set up Table Header View
        setupTableHeaderView()
    }
    
    var isDarkModeEnabled: Bool {
        return UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    func setupTableHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 10, width: 200, height: 40))
        titleLabel.text = "My Book"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerView.addSubview(titleLabel)

        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        headerView.addSubview(settingsButton)

        NSLayoutConstraint.activate([
            settingsButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -30),
            settingsButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 40),
            settingsButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        tableView.tableHeaderView = headerView
    }

    @objc func settingsButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    
    @objc func updateDarkMode() {
        overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return books.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = books[indexPath.section]
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
            cell.textLabel?.text = book["title"]
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorCell", for: indexPath)
            cell.textLabel?.text = "Author: \(book["author"] ?? "Unknown")"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
            if let imageName = book["image"] {
                DispatchQueue.global().async {
                    if let image = UIImage(named: imageName) {
                        DispatchQueue.main.async {
                            if let currentCell = tableView.cellForRow(at: indexPath) {
                                currentCell.imageView?.image = image
                                currentCell.setNeedsLayout()
                            }
                        }
                    }
                }
            }
            
            cell.imageView?.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            cell.imageView?.addGestureRecognizer(tapGesture)
            cell.imageView?.tag = indexPath.section
            
            return cell
        default:
            return UITableViewCell()
        }
    }

    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView, let image = imageView.image {
            let zoomVC = ImageZoomViewController()
            zoomVC.image = image
            zoomVC.modalPresentationStyle = .overFullScreen
            present(zoomVC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let selectedBook = books[indexPath.section]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "BookDetailViewController") as? BookDetailViewController {
                detailVC.bookTitle = selectedBook["title"]
                detailVC.bookAuthor = selectedBook["author"]
                detailVC.bookImage = UIImage(named: selectedBook["image"] ?? "")
                detailVC.bookDescription = selectedBook["description"]
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}
