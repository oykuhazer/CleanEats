//
//  DailyList.swift
//  CleanEats
//
//  Created by Öykü Hazer Ekinci on 30.07.2023.
//

import UIKit
import Alamofire

class DailyList: UIViewController {

    var viewModel: DailyListViewModel
    var tableView: UITableView!
    var selectedDietLabel: UILabel!
        init(viewModel: DailyListViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            setupViews()
            setupSelectedDietLabel()

            if let selectedDiet = viewModel.model.selectedDiet {
                selectedDietLabel.text = "Selected Diet Category: \(selectedDiet)"
            } else {
                selectedDietLabel.text = "No Diet Selected"
            }

            generateWeeklyMealPlan()
        }
    func setupViews() {
            view.backgroundColor = UIColor(red: 200/255, green: 240/255, blue: 200/255, alpha: 1.0)
            navigationController?.navigationBar.tintColor = .systemGreen
            selectedDietLabel = UILabel()
            setupSelectedDietLabel()
            setupTableView()
        }

        func setupSelectedDietLabel() {
            selectedDietLabel.frame = CGRect(x: 20, y: 140, width: view.bounds.width - 40, height: 30)
            selectedDietLabel.textAlignment = .center
            selectedDietLabel.textColor = .darkGray
            selectedDietLabel.font = UIFont.boldSystemFont(ofSize: 20)
            view.addSubview(selectedDietLabel)
        }

        func setupTableView() {
            tableView = UITableView(frame: view.bounds, style: .plain)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MealCell")
            tableView.backgroundColor = UIColor(red: 200/255, green: 240/255, blue: 200/255, alpha: 1.0)
            view.addSubview(tableView)

            //Add insets to the table view to adjust its position below the selected diet label
            let insets = UIEdgeInsets(top: 120, left: 0, bottom: 0, right: 0)
            tableView.contentInset = insets
        }

        func generateWeeklyMealPlan() {
            //Generate the weekly meal plan based on the selected diet
            guard let selectedDiet = viewModel.model.selectedDiet else { return }

            let apiKey = "cdccaa60c50b4423a2ec1dedd7946848"
            let baseURL = "https://api.spoonacular.com/mealplanner/generate"
            
            //Parameters for the API request
            let parameters: [String: Any] = [
                "timeFrame": "day",
                "targetCalories": 2000,
                "diet": selectedDiet,
                "exclude": "shellfish,olives"
            ]

            //Array to store all the weekly meals
            var allWeeklyMeals: [[String: Any]] = []
            let dispatchGroup = DispatchGroup()

            //Fetch meals for each day in the week
            for dayIndex in 0..<7 {
                dispatchGroup.enter()

                let currentDate = Calendar.current.date(byAdding: .day, value: dayIndex, to: Date())!
                let formattedDate = DateFormatter.localizedString(from: currentDate, dateStyle: .short, timeStyle: .none)
                
                //Add the formatted date to the parameters for the API request
                let parametersWithDate = parameters.merging(["timeFrame": formattedDate]) { $1 }

                //Make the API request to get the meal for the current day
                AF.request(baseURL, method: .get, parameters: parametersWithDate, headers: ["x-api-key": apiKey])
                    .responseJSON { [weak self] response in
                        defer { dispatchGroup.leave() }

                        switch response.result {
                        case .success(let value):
                            if let json = value as? [String: Any], let meals = json["meals"] as? [[String: Any]] {
                                
                                //Append the fetched meals for the day to the allWeeklyMeals array
                                allWeeklyMeals.append(contentsOf: meals)
                            }
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                        }

                        //Update the view model with the weekly meals and reload the table view
                        self?.viewModel.model.weeklyMeals = allWeeklyMeals
                        self?.tableView.reloadData()
                    }
            }

            //Notify when all API requests are completed
            dispatchGroup.notify(queue: .main) {
                
                self.viewModel.model.weeklyMeals = allWeeklyMeals
                self.tableView.reloadData()
            }
        }
    
    //Function to fetch meal details for a given mealId using the Spoonacular API
    func fetchMealDetails(for mealId: Int, completion: @escaping ([String: Any]?) -> Void) {
          let apiKey = "cdccaa60c50b4423a2ec1dedd7946848"
          let baseURL = "https://api.spoonacular.com/recipes/\(mealId)/information"

        //Make the API request to get the meal details
          AF.request(baseURL, method: .get, parameters: ["apiKey": apiKey])
              .responseJSON { response in
                  switch response.result {
                  case .success(let value):
                      if let json = value as? [String: Any] {
                          completion(json)
                      } else {
                          completion(nil)
                      }
                  case .failure(let error):
                      print("Error: \(error.localizedDescription)")
                      completion(nil)
                  }
              }
      }
    }

    extension DailyList: UITableViewDataSource, UITableViewDelegate {
        
        //Return the number of sections, which is equal to the number of day names in the view model
        func numberOfSections(in tableView: UITableView) -> Int {
            return viewModel.model.dayNames.count
        }

        //Return the number of rows in each section based on whether the section is expanded or not
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.expandedSections.contains(section) ? 1 + 3 : 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath)
            cell.textLabel?.text = nil

            if indexPath.row == 0 { //Day name row
                
                //Configure the cell for day name row
                let dayName = viewModel.model.dayNames[indexPath.section]
                cell.textLabel?.text = dayName
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                cell.textLabel?.textColor = .white
                cell.backgroundColor = .systemGreen

                let accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
                accessoryView.tintColor = .white
                cell.accessoryView = accessoryView
                
            } else if viewModel.expandedSections.contains(indexPath.section) {
                
                //Configure the cell for expanded section rows (displaying meal titles)
                let mealIndex = indexPath.row - 1
                let meal = viewModel.model.weeklyMeals[indexPath.section * 3 + mealIndex]
                if let title = meal["title"] as? String {
                    cell.textLabel?.text = title
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    cell.textLabel?.textColor = .systemGreen
                    cell.backgroundColor = .white
                    cell.accessoryView = nil
                }
            } else {
                
                //Hide the cell for non-expanded sections
                cell.textLabel?.text = nil
                cell.backgroundColor = .white
                cell.accessoryView = nil
            }

            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if indexPath.row == 0 { //If it's a day name row
                
                //If the selected section is already expanded, collapse it
                if viewModel.expandedSections.contains(indexPath.section) {
                    viewModel.expandedSections.remove(indexPath.section)
                } else {
                    
                    //Otherwise, expand the selected section
                    viewModel.expandedSections.insert(indexPath.section)
                }

                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else if viewModel.expandedSections.contains(indexPath.section) {
                
                //If it's an expanded section, show the meal details for the selected meal
                let mealIndex = indexPath.row - 1
                let meal = viewModel.model.weeklyMeals[indexPath.section * 3 + mealIndex]
                if let mealId = meal["id"] as? Int {
                    
                    //Fetch the meal details for the selected meal using the Spoonacular API
                    fetchMealDetails(for: mealId) { [weak self] mealDetails in
                        guard let mealDetails = mealDetails else {
                            return
                        }

                        //Create and show the MealDetailViewController with the fetched details
                        let mealDetailViewModel = MealDetailViewModel(meal: mealDetails)
                        let mealDetailViewController = MealDetail(viewModel: mealDetailViewModel)
                        self?.navigationController?.pushViewController(mealDetailViewController, animated: true)
                    }
                }
            }
        }
    }
