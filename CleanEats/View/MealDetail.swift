//
//  MealDetail.swift
//  CleanEats
//
//  Created by Öykü Hazer Ekinci on 01.08.2023.
//

import UIKit

class MealDetail: UIViewController {

    var viewModel: MealDetailViewModel
       
       private let mealNameLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.font = UIFont.boldSystemFont(ofSize: 20)
           label.textColor = .orange
           return label
       }()

       private let mealImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.translatesAutoresizingMaskIntoConstraints = false
           imageView.contentMode = .scaleAspectFill
           imageView.clipsToBounds = true
           imageView.layer.cornerRadius = 10
           imageView.layer.masksToBounds = true
           return imageView
       }()

       private let spoonacularSourceUrlButton: UIButton = {
           let button = UIButton(type: .system)
           button.translatesAutoresizingMaskIntoConstraints = false
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
           button.setTitleColor(.orange, for: .normal)
           button.addTarget(self, action: #selector(openSpoonacularSourceUrl(_:)), for: .touchUpInside)
           return button
       }()

       private lazy var stackView: UIStackView = {
           let centeringView = UIView()
           centeringView.translatesAutoresizingMaskIntoConstraints = false
           centeringView.addSubview(mealNameLabel)
           mealNameLabel.centerXAnchor.constraint(equalTo: centeringView.centerXAnchor).isActive = true

           let stackView = UIStackView(arrangedSubviews: [centeringView, mealImageView, spoonacularSourceUrlButton])
           stackView.translatesAutoresizingMaskIntoConstraints = false
           stackView.axis = .vertical
           stackView.spacing = 50
           return stackView
       }()

       init(viewModel: MealDetailViewModel) {
           self.viewModel = viewModel
           super.init(nibName: nil, bundle: nil)
       }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1.0)
           navigationController?.navigationBar.tintColor = .darkGray
           setupViews()
           displayMealDetails()
       }

    //Add the stack view to the view hierarchy and set up its constraints
       func setupViews() {
           view.addSubview(stackView)

           NSLayoutConstraint.activate([
               stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
               stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
           ])
       }

    //Fetch and display the meal details using the view model
       func displayMealDetails() {
           
           //Check if the meal details are available in the view model
           guard let meal = viewModel.meal,
                 let mealName = meal["title"] as? String,
                 let imageUrlString = meal["image"] as? String,
                 let spoonacularSourceUrl = meal["spoonacularSourceUrl"] as? String else {
               print("Error: Missing meal details.")
               return
           }

           mealNameLabel.text = mealName

           //Load the meal image asynchronously from the provided URL
           DispatchQueue.global().async {
               if let data = try? Data(contentsOf: URL(string: imageUrlString)!),
                  let image = UIImage(data: data) {
                   DispatchQueue.main.async {
                       self.mealImageView.image = image
                   }
               }
           }

           //Set the title and accessibility identifier of the button to open the Spoonacular source URL
           spoonacularSourceUrlButton.setTitle("View on Spoonacular", for: .normal)
           spoonacularSourceUrlButton.accessibilityIdentifier = spoonacularSourceUrl
       }

    //Open the Spoonacular source URL when the button is tapped
       @objc func openSpoonacularSourceUrl(_ sender: UIButton) {
           guard let urlStr = sender.accessibilityIdentifier,
                 let url = URL(string: urlStr) else {
               return
           }

           UIApplication.shared.open(url)
       }
   }
