//
//  DietTypes.swift
//  CleanEats
//
//  Created by Öykü Hazer Ekinci on 29.07.2023.
//

import UIKit

class DietTypes: UIViewController {
    var viewModel = DietTypesViewModel()
        var collectionView: UICollectionView!

        override func viewDidLoad() {
            super.viewDidLoad()
            setupViews()
        }

        func setupViews() {
            view.backgroundColor = UIColor(red: 200/255, green: 240/255, blue: 200/255, alpha: 1.0)
            setupCollectionView()
            setupTitleLabel()
        }

        func setupCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical

            collectionView = UICollectionView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height - 150), collectionViewLayout: layout)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            collectionView.backgroundColor = UIColor(red: 200/255, green: 240/255, blue: 200/255, alpha: 1.0)
            view.addSubview(collectionView)
        }

        func setupTitleLabel() {
            let titleLabel = UILabel(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 60))
            titleLabel.numberOfLines = 2
            titleLabel.textAlignment = .justified
            titleLabel.textColor = .darkGray
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.text = "To select a diet type, click on one of the options from the list below."
            view.addSubview(titleLabel)
        }
    }

    extension DietTypes: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        //Return the number of items in the collection view, which is equal to the number of diet types in the view model
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.model.dietTypes.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .systemGreen
            cell.layer.cornerRadius = 10

            //Configure the cell's label with the diet type name
            let label = UILabel(frame: cell.contentView.bounds)
            label.text = viewModel.model.dietTypes[indexPath.item]
            label.textColor = .white
            label.textAlignment = .center
            cell.contentView.addSubview(label)

            return cell
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width - 20, height: 80)
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            //Get the selected diet type
            let selectedDiet = viewModel.model.dietTypes[indexPath.item]
            //Push the DailyList view controller with the selected diet type view model to the navigation stack
            navigationController?.pushViewController(DailyList(viewModel: DailyListViewModel(selectedDiet: selectedDiet)), animated: true)
        }
    }
