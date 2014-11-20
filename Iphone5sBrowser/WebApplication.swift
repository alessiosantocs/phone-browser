//
//  WebApplication.swift
//  Phone Browser
//
//  Created by Alessio Santo on 19/11/14.
//  Copyright (c) 2014 alessiosanto. All rights reserved.
//

import Foundation
import CoreData

@objc(WebApplication)
class WebApplication: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var url: String

}
