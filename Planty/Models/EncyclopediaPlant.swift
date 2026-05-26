//
//  EncyclopediaPlant.swift
//  Planty
//
//  Created by choeun on 5/23/26.
//

import Foundation

struct EncyclopediaPlant {
    let name: String
    let scientificName: String
    let imageName: String
    let difficulty: String
    let waterCycle: String
    let light: String
    let temperature: String
    let description: String
    let toxicity: Bool
}

extension EncyclopediaPlant {
    static let sampleData: [EncyclopediaPlant] = [
        EncyclopediaPlant(
            name: "산세베리아",
            scientificName: "Sansevieria trifasciata",
            imageName: "sansevieria",
            difficulty: "매우 쉬움",
            waterCycle: "2~3주에 한 번",
            light: "간접광 ~ 저광",
            temperature: "15~35°C",
            description: "공기정화 능력이 뛰어나며 관리가 매우 쉬운 다육식물입니다.",
            toxicity: true
        ),
        EncyclopediaPlant(
            name: "몬스테라",
            scientificName: "Monstera deliciosa",
            imageName: "monstera",
            difficulty: "쉬움",
            waterCycle: "1~2주에 한 번",
            light: "밝은 간접광",
            temperature: "18~30°C",
            description: "독특한 잎 모양으로 인테리어 식물로 인기가 많습니다.",
            toxicity: true
        ),
        EncyclopediaPlant(
            name: "스킨답서스",
            scientificName: "Epipremnum aureum",
            imageName: "pothos",
            difficulty: "매우 쉬움",
            waterCycle: "1~2주에 한 번",
            light: "저광 가능",
            temperature: "15~30°C",
            description: "공기정화 식물로 유명하며 어두운 곳에서도 잘 자랍니다.",
            toxicity: true
        ),
        EncyclopediaPlant(
            name: "올리브나무",
            scientificName: "Olea europaea",
            imageName: "olive",
            difficulty: "보통",
            waterCycle: "1주에 한 번",
            light: "직사광선",
            temperature: "10~35°C",
            description: "지중해 분위기를 연출하는 인기 식물입니다.",
            toxicity: false
        ),
        EncyclopediaPlant(
            name: "테이블야자",
            scientificName: "Chamaedorea elegans",
            imageName: "tablepam",
            difficulty: "쉬움",
            waterCycle: "1주에 한 번",
            light: "밝은 간접광",
            temperature: "18~27°C",
            description: "실내에서 잘 자라는 소형 야자나무입니다.",
            toxicity: false
        ),
        EncyclopediaPlant(
            name: "염좌",
            scientificName: "Crassula ovata",
            imageName: "jadeplant",
            difficulty: "쉬움",
            waterCycle: "2주에 한 번",
            light: "밝은 직사광선",
            temperature: "13~35°C",
            description: "행운을 가져다준다고 알려진 다육식물입니다.",
            toxicity: true
        )
    ]
}
