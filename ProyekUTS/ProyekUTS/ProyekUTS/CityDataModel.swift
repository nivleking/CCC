//
//  CityDataModel.swift
//  ProyekUTS
//
//  Created by Kelvin Sidharta Sie on 04/10/23.
//

struct CityDataModel: Decodable {
    let rajaongkir: RajaOngkir2
}

struct RajaOngkir2: Decodable {
//    let query: Query2
    let results: [Results2]?
}

//struct Query2: Decodable {
////    let province: String
//    let id: String
//}

struct Results2: Decodable {
    let province_id: String
    let city_id: String
    let city_name: String
}
