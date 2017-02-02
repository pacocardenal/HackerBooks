//
//  TagName.swift
//  HackerBooks
//
//  Created by Paco Cardenal on 30/1/17.
//  Copyright © 2017 Paco Cardenal. All rights reserved.
//

import Foundation

enum TagName : String {
    
    case versionControl = "version control"
    case git = "git"
    case programming = "programming"
    case javascript = "javascript"
    case python = "python"
    case dataStructures = "data structures"
    case statistics = "statistics"
    case math = "math"
    case cs = "cs"
    case tutorials = "tutorials"
    case practical = "practical"
    case java = "java"
    case html5 = "html5"
    case android = "android"
    case informationTheory = "information theory"
    case learningAlgorithms = "learning algorithms"
    case vim = "vim"
    case machineLearning = "machine learning"
    case optimization = "optimization"
    case algorithms = "algorithms"
    case robotics = "robotics"
    case artificialIntelligence = "artificial intelligence"
    case controlTheory = "control theory"
    case planning = "planning"
    case gameTheory = "game theory"
    case gtd = "gtd"
    case distributedSystems = "distributed systems"
    case cryptography = "cryptography"
    case accessControls = "access controls"
    case security = "security"
    case js = "js"
    case graphics = "graphics"
    case haskell = "haskell"
    case subversion = "subversion"
    case dvcs = "dvcs"
    case veracity = "veracity"
    case mercurial = "mercurial"
    case distributedVersionControlSystem = "distributed version control system"
    case linearAlgebra = "linear algebra"
    case matrixComputations = "matrix computations"
    case dataMining = "data mining"
    case textProcessing = "text processing"
    
    case other = "other"
    
    static func by(name: String) -> TagName {
        
        let tag : TagName
        
        switch name {
            case TagName.versionControl.rawValue:
                tag = TagName.versionControl
            case TagName.git.rawValue:
                tag = TagName.git
            case TagName.programming.rawValue:
                tag = TagName.programming
            case TagName.javascript.rawValue:
                tag = TagName.javascript
        case TagName.python.rawValue:
                tag = TagName.python
            default:
                tag = TagName.other
        }
        
        return tag;
        
    }
    
}
