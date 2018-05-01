//
//  CircleImageView.swift
//  TwitterClient
//
//  Created by Maika Yamada on 2018/04/28.
//  Copyright © 2018年 Maika Yamada. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width * 0.5
    }
}
