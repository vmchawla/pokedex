//
//  Pokemon.swift
//  pokedex
//
//  Created by Varun Chawla on 12/07/17.
//  Copyright © 2017 Varun Chawla. All rights reserved.
//

import Foundation

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
    
    public var name:String {
        get {
            return _name
        }
    }
    
    public var pokedexId: Int {
        get {
            return _pokedexId
        }
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
    
}
