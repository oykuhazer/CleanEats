//
//  MealCell.swift
//  CleanEats
//
//  Created by Öykü Hazer Ekinci on 30.07.2023.
//

import UIKit

class MealCell: UITableViewCell {

    var titleLabel: UILabel!
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            titleLabel = UILabel(frame: CGRect(x: 15, y: 5, width: contentView.bounds.width - 30, height: 30))
            titleLabel.textColor = UIColor.black
            contentView.addSubview(titleLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }


