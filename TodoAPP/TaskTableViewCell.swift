//
//  TaskTableViewCell.swift
//  TodoAPP
//
//  Created by David Auger on 11/20/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell
{
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var date_label: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected( _ selected: Bool, animated: Bool )
    {
        super.setSelected(selected, animated: animated)
    }
}
