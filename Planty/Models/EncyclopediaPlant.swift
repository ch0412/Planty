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
        ),
        
        // 7 ~ 20: 새로 추가된 14종의 식물 데이터
        EncyclopediaPlant(
            name: "유칼립투스",
            scientificName: "Eucalyptus globulus",
            imageName: "eucalyptus",
            difficulty: "어려움",
            waterCycle: "3~4일에 한 번",
            light: "강한 직사광선",
            temperature: "15~25°C",
            description: "특유의 향이 비염과 스트레스 완화에 좋지만, 과습과 통풍에 매우 예민합니다.",
            toxicity: true
        ),
        EncyclopediaPlant(
            name: "홍콩야자",
            scientificName: "Schefflera arboricola",
            imageName: "schefflera",
            difficulty: "쉬움",
            waterCycle: "1주에 한 번",
            light: "반그늘 ~ 간접광",
            temperature: "16~26°C",
            description: "우산 모양의 잎이 귀여운 식물로, 담배 연기나 새집증후군 물질 제거에 탁월합니다.",
            toxicity: true
        ),
        EncyclopediaPlant(
            name: "호접란",
            scientificName: "Phalaenopsis amabilis",
            imageName: "orchid",
            difficulty: "보통",
            waterCycle: "10~12일에 한 번",
            light: "부드러운 간접광",
            temperature: "18~24°C",
            description: "나비 모양을 닮은 아름다운 꽃이 피며, 실내 습도 조절에 도움을 줍니다.",
            toxicity: false
        ),
        EncyclopediaPlant(
            name: "선인장(마밀라리아)",
            scientificName: "Mammillaria",
            imageName: "cactus",
            difficulty: "매우 쉬움",
            waterCycle: "4주에 한 번",
            light: "강한 직사광선",
            temperature: "18~35°C",
            description: "몸통 전체가 가시로 둘러싸인 다육식물로, 물을 거의 주지 않아도 잘 자랍니다.",
            toxicity: false
        ),
        EncyclopediaPlant(
            name: "아레카야자",
            scientificName: "Dypsis lutescens",
            imageName: "arecapalm",
            difficulty: "보통",
            waterCycle: "1주에 한 번",
            light: "밝은 간접광",
            temperature: "18~24°C",
            description: "NASA가 선정한 최고의 공기정화 식물로, 천연 가습기 역할을 톡톡히 합니다.",
            toxicity: false
        ),
        EncyclopediaPlant(
            name: "스투키",
            scientificName: "Sansevieria stuckyi",
            imageName: "stuckyi",
            difficulty: "매우 쉬움",
            waterCycle: "1달에 한 번",
            light: "그늘 ~ 간접광",
            temperature: "15~30°C",
            description: "음이온 방출 효과가 산세베리아보다 뛰어나며, 관리가 거의 필요 없습니다.",
            toxicity: true
        ),
        EncyclopediaPlant(
            name: "여인초",
            scientificName: "Strelitzia nicolai",
            imageName: "birdofparadise",
            difficulty: "쉬움",
            waterCycle: "1~2주에 한 번",
            light: "밝은 간접광",
            temperature: "15~25°C",
            description: "시원하게 뻗은 큰 잎이 매력적이며 플랜테리어에 가장 어울리는 식물입니다.",
            toxicity: false
        ),
        EncyclopediaPlant(
            name: "필로덴드론 핑크프린세스",
            scientificName: "Philodendron Erubescens",
            imageName: "pinkprincess",
            difficulty: "보통",
            waterCycle: "1주에 한 번",
            light: "밝은 간접광",
            temperature: "18~27°C",
            description: "초록색 잎에 핑크색 무늬가 불규칙하게 섞여 있어 희귀 식물 집사들에게 인기가 많습니다.",
            toxicity: true
        ),
        EncyclopediaPlant(
            name: "고무나무",
            scientificName: "Ficus elastica",
            imageName: "rubberplant",
            difficulty: "쉬움",
            waterCycle: "10~14일에 한 번",
            light: "반양지 ~ 간접광",
            temperature: "16~27°C",
            description: "넓고 두꺼운 잎을 가졌으며 빛이 다소 부족한 실내에서도 튼튼하게 버텨줍니다.",
            toxicity: true
        ),
        EncyclopediaPlant(
            name: "로즈마리",
            scientificName: "Salvia rosmarinus",
            imageName: "rosemary",
            difficulty: "어려움",
            waterCycle: "3~4일에 한 번",
            light: "강한 직사광선",
            temperature: "15~25°C",
            description: "향긋한 허브 향이 집중력 향상에 도움을 주지만, 햇빛과 환기가 불충분하면 쉽게 죽습니다.",
            toxicity: false
        ),
        EncyclopediaPlant(
            name: "보스턴고사리",
            scientificName: "Nephrolepis exalta",
            imageName: "bostonfern",
            difficulty: "보통",
            waterCycle: "4~5일에 한 번",
            light: "반그늘 ~ 간접광",
            temperature: "18~24°C",
            description: "습한 환경을 좋아하는 식물로, 잎에 분무를 자주 해주면 풍성하게 자랍니다.",
            toxicity: false
        ),
        EncyclopediaPlant(
            name: "마란타",
            scientificName: "Maranta leucooneura",
            imageName: "maranta",
            difficulty: "보통",
            waterCycle: "1주에 한 번",
            light: "반그늘 ~ 밝은 그늘",
            temperature: "18~25°C",
            description: "밤이 되면 잎을 위로 오므려 기도하는 듯한 모습을 보여주는 신기한 식물입니다.",
            toxicity: false
        ),
        EncyclopediaPlant(
            name: "제라늄",
            scientificName: "Pelargonium",
            imageName: "geranium",
            difficulty: "쉬움",
            waterCycle: "1~2주에 한 번",
            light: "밝은 직사광선",
            temperature: "15~25°C",
            description: "사계절 내내 다채롭고 화려한 꽃을 피우며 건조함에 강한 편입니다.",
            toxicity: true
        ),
        EncyclopediaPlant(
            name: "싱고니움",
            scientificName: "Syngonium podophyllum",
            imageName: "syngonium",
            difficulty: "매우 쉬움",
            waterCycle: "1주에 한 번",
            light: "반그늘 ~ 간접광",
            temperature: "16~24°C",
            description: "화살촉 모양의 잎이 특징이며 수경재배로도 아주 잘 자라 초보 집사에게 추천합니다.",
            toxicity: true
        )
    ]
}
