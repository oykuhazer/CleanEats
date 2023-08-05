//
//  ViewModules.swift
//  CleanEats
//
//  Created by Öykü Hazer Ekinci on 27.07.2023.
//

import Foundation
import UIKit

class DietTypesViewModel {
    let model = DietTypesModel()
}

class DailyListViewModel {
    var model: DailyListModel
    var expandedSections: Set<Int> = []
    init(selectedDiet: String) {
        self.model = DailyListModel(selectedDiet: selectedDiet)
    }
}

class MealDetailViewModel {
    var model: [String: Any]

    init(meal: [String: Any]) {
        self.model = meal
    }

    var meal: [String: Any]? {
        return model
    }
    }
