//
//  Utils.swift
//  ReadReceipts
//
//  Created by Nate Parrott on 11/1/16.
//  Copyright © 2016 Nate Parrott. All rights reserved.
//

import UIKit

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
{
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}
