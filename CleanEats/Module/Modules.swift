//
//  Modules.swift
//  CleanEats
//
//  Created by Öykü Hazer Ekinci on 27.07.2023.
//

import Foundation
import UIKit

struct DietTypesModel {
    let dietTypes: [String] = ["vegetarian", "ketogenic", "glutenFree", "balanced", "lowFODMAP", "lactoOvoVegetarian"]
}

struct DailyListModel {
    var selectedDiet: String?
    var weeklyMeals: [[String: Any]] = []
    let dayNames = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    init(selectedDiet: String) {
        self.selectedDiet = selectedDiet
    }
}

struct MealDetailModel {
    var meal: [String: Any]?
}
