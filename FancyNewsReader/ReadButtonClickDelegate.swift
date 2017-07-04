//
//  ReadButtonClickDelegate.swift
//  FancyNewsReader
//
//  Created by Abdul-Mujib Aliu on 6/19/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import Foundation

protocol ReadButtonClickDelegate : class {
    
    func readButtonClicked(newsItem: NewsItem)
    
}
