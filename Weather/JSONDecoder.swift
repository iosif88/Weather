//
//  JSONDecoder.swift
//  Weather
//
//  Created by Iosif Dubikovski on 4/14/23.
//

import Foundation

struct Location: Decodable {
    let latitude: Double
    let longitude: Double
    let generationtime_ms: Double
    let utc_offset_seconds: Int
    let timezone: String
    let timezone_abbreviation: String
    let elevation: Double
    let current_weather: Weather
}

struct Weather: Decodable {
    let temperature: Double
    let windspeed: Double
    let winddirection: Double
    let weathercode: Int
    let is_day: Int
    let time: String
} 
