//
//  Pokemon.swift
//  pokedex
//
//  Created by Varun Chawla on 12/07/17.
//  Copyright © 2017 Varun Chawla. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvolutionTxt :String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonURL: String!
    
    
    public var nextEvolutionName: String {
        get {
            if _nextEvolutionName == nil {
                return ""
            }
            return _nextEvolutionName
        }
    }
    
    public var nextEvolutionID: String {
        get {
            if _nextEvolutionID == nil {
                return ""
            }
            return _nextEvolutionID
        }
    }
    
    public var nextEvolutionLvl: String {
        get {
            if _nextEvolutionLvl == nil {
                return ""
            }
            return _nextEvolutionLvl
        }
    }
    
    public var description: String {
        get {
            if _description == nil {
                return "its nil"
            }
            return _description
        }
    }
    
    public var type: String {
        get {
            if _type == nil {
                return ""
            }
            return _type
        }
    }
    
    public var defense: String {
        get {
            if _defense == nil {
                return ""
            }
            return _defense
        }
    }
    
    public var height: String {
        get {
            if _height == nil {
                return ""
            }
            return _height
        }
    }
    
    public var weight: String {
        get {
            if _weight == nil {
                return ""
            }
            return _weight
        }
    }
    
    public var attack: String {
        get {
            if _attack == nil {
                return ""
            }
            return _attack
        }
    }
    
    public var nextEvolutionTxt: String {
        get {
            if _nextEvolutionTxt == nil {
                return ""
            }
            return _nextEvolutionTxt
        }
    }
    
    public var name:String {
        get {
            if _name == nil {
                return ""
            }
            return _name
        }
    }
    
    public var pokedexId: Int {
        get {
            if _pokedexId == nil {
                return 0
            }
            return _pokedexId
        }
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        
                        for x in 1..<types.count {
                            
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        Alamofire.request("\(URL_BASE)\(url)").responseJSON(completionHandler: { (response) in
                            
                            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = dict["description"] as? String {
                                    let newDesc = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDesc
                                }
                            }
                            
                            completed()
                        })
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvo
                        }
                    }
                    
                    if let evoIDURL = evolutions[0]["resource_uri"] as? String {
                        print(evoIDURL)
                        let incompleteID = evoIDURL.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                        let evoID = incompleteID.replacingOccurrences(of: "/", with: "")
                        self._nextEvolutionID = evoID
                    }
                    
                    if let level = evolutions[0]["level"] as? Int {
                        self._nextEvolutionLvl = "\(level)"
                    } else {
                        self._nextEvolutionLvl = ""
                    }
                }
            }
            completed()
            
        }
        
    }
    
}
