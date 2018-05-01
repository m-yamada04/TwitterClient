//
//  LoadingTweetCell.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/05/02.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import UIKit

class LoadingTweetCell: UITableViewCell {

    @IBOutlet weak var _indicationView: UIActivityIndicatorView! {
        didSet {
            _indicationView.startAnimating()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
