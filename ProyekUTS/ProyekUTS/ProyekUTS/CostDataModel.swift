//
//  CostDataModel.swift
//  ProyekUTS
//
//  Created by Kelvin Sidharta Sie on 04/10/23.
//

struct CostDataModel: Decodable {
    let rajaongkir: RajaOngkir
}

struct RajaOngkir: Decodable {
    let query: Query
    let results: [Results]
}

struct Query: Decodable {
    let origin: String
    let destination: String
    let weight: Int
    let courier: String
}

struct Results: Decodable {
    let code: String
    let name: String
    let costs: [Costs]
}

struct Costs: Decodable {
    let service: String
    let cost: [Cost]
}

struct Cost: Decodable {
    let value: Int
    let etd: String
}
