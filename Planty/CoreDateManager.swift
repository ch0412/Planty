//
//  CoreDataManager.swift
//  Planty
//
//  Created by choeun on 5/21/26.
//

import UIKit
import CoreData

// CoreData CRUD 작업을 담당하는 싱글톤 매니저
class CoreDataManager {
    
    // MARK: - Singleton
    // 앱 전역에서 하나의 인스턴스만 사용
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - Core Data Stack
    // CoreData 영구 저장소 컨테이너 - 최초 접근 시 초기화
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Planty")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData 로드 실패: \(error)")
            }
        }
        return container
    }()
    
    // 메인 스레드에서 사용하는 컨텍스트
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save
    // 변경사항이 있을 때만 저장 - 성공 여부 반환
    @discardableResult
    func saveContext() -> Bool {
        guard context.hasChanges else { return true }
        
        do {
            try context.save()
            return true
        } catch {
            print("저장 실패: \(error)")
            return false
        }
    }
    
    // MARK: - Plant CRUD
    // 식물 추가 - Plant 모델을 PlantEntity로 변환 후 저장
    func createPlant(_ plant: Planty.Plant) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "PlantEntity", into: context)
        entity.setValue(plant.id, forKey: "id")
        entity.setValue(plant.name, forKey: "name")
        entity.setValue(plant.species, forKey: "species")
        entity.setValue(plant.startDate, forKey: "startDate")
        entity.setValue(plant.waterCycle, forKey: "waterCycle")
        
        if let image = plant.photoImage,
           let data = image.jpegData(compressionQuality: 0.8) {
            entity.setValue(data, forKey: "photo")
        }
        
        saveContext()
    }
    
    // 식물 전체 조회 - PlantEntity를 Plant 모델로 변환 후 반환
    func fetchPlants() -> [Planty.Plant] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "PlantEntity")
        
        do {
            let results = try context.fetch(request)
            return results.compactMap { convertToPlant($0) }
        } catch {
            print("조회 실패: \(error)")
            return []
        }
    }
    
    // 식물 수정 - id로 해당 엔티티 조회 후 업데이트
    func updatePlant(_ plant: Planty.Plant) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "PlantEntity")
        request.predicate = NSPredicate(format: "id == %@", plant.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first {
                entity.setValue(plant.name, forKey: "name")
                entity.setValue(plant.species, forKey: "species")
                entity.setValue(plant.startDate, forKey: "startDate")
                entity.setValue(plant.waterCycle, forKey: "waterCycle")
                
                if let image = plant.photoImage,
                   let data = image.jpegData(compressionQuality: 0.8) {
                    entity.setValue(data, forKey: "photo")
                } else {
                    entity.setValue(nil, forKey: "photo")
                }
                saveContext()
            }
        } catch {
            print("수정 실패: \(error)")
        }
    }
    
    // 식물 삭제 - id로 해당 엔티티 조회 후 삭제
    func deletePlant(_ plant: Planty.Plant) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "PlantEntity")
        request.predicate = NSPredicate(format: "id == %@", plant.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first {
                context.delete(entity)
                saveContext()
            }
        } catch {
            print("삭제 실패: \(error)")
        }
    }
    
    // MARK: - DiaryEntry CRUD
    // 일지 추가 - 해당 식물 엔티티를 찾아 DiaryEntity와 연결 후 저장
    func createDiary(_ diary: Planty.DiaryEntry, for plant: Planty.Plant) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "PlantEntity")
        request.predicate = NSPredicate(format: "id == %@", plant.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let plantEntity = results.first {
                let diaryEntity = NSEntityDescription.insertNewObject(forEntityName: "DiaryEntity", into: context)
                diaryEntity.setValue(diary.id, forKey: "id")
                diaryEntity.setValue(diary.title, forKey: "title")
                diaryEntity.setValue(diary.content, forKey: "content")
                diaryEntity.setValue(diary.date, forKey: "date")
                
                if !diary.photoImages.isEmpty {
                    let data = diary.photoImages.compactMap {
                        $0.jpegData(compressionQuality: 0.8)
                    }
                    let archivedData = try? NSKeyedArchiver.archivedData(
                        withRootObject: data,
                        requiringSecureCoding: false
                    )
                    diaryEntity.setValue(archivedData, forKey: "photos")
                }
                
                let diaries = plantEntity.mutableSetValue(forKey: "diaries")
                diaries.add(diaryEntity)
                
                saveContext()
            }
        } catch {
            print("일지 추가 실패: \(error)")
        }
    }
    
    // 일지 수정 - id로 해당 엔티티 조회 후 업데이트
    func updateDiary(_ diary: Planty.DiaryEntry, for plant: Planty.Plant) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "DiaryEntity")
        request.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first {
                entity.setValue(diary.title, forKey: "title")
                entity.setValue(diary.content, forKey: "content")
                entity.setValue(diary.date, forKey: "date")
                
                if !diary.photoImages.isEmpty {
                    let data = diary.photoImages.compactMap {
                        $0.jpegData(compressionQuality: 0.8)
                    }
                    let archivedData = try? NSKeyedArchiver.archivedData(
                        withRootObject: data,
                        requiringSecureCoding: false
                    )
                    entity.setValue(archivedData, forKey: "photos")
                } else {
                    entity.setValue(nil, forKey: "photos")
                }
                saveContext()
            }
        } catch {
            print("일지 수정 실패: \(error)")
        }
    }
    
    // 일지 삭제 - id로 해당 엔티티 조회 후 삭제
    func deleteDiary(_ diary: Planty.DiaryEntry) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "DiaryEntity")
        request.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first {
                context.delete(entity)
                saveContext()
            }
        } catch {
            print("일지 삭제 실패: \(error)")
        }
    }
    
    // MARK: - Convert
    // NSManagedObject → Plant 변환 - 필수 값 없으면 nil 반환
    private func convertToPlant(_ object: NSManagedObject) -> Planty.Plant? {
        guard let name = object.value(forKey: "name") as? String,
              let species = object.value(forKey: "species") as? String,
              let startDate = object.value(forKey: "startDate") as? Date,
              let waterCycle = object.value(forKey: "waterCycle") as? Int else {
            return nil
        }
        
        var plant = Planty.Plant(
            name: name,
            species: species,
            startDate: startDate,
            waterCycle: waterCycle
        )
        
        // 저장된 UUID로 id 복원
        if let id = object.value(forKey: "id") as? UUID {
            plant.id = id
        }
        
        // 저장된 Data로 사진 복원
        if let photoData = object.value(forKey: "photo") as? Data {
            plant.photoImage = UIImage(data: photoData)
        }
        
        // 연결된 일지 복원 - 날짜 내림차순 정렬
        if let diarySet = object.value(forKey: "diaries") as? Set<NSManagedObject> {
            plant.diaries = diarySet.compactMap { convertToDiary($0) }
                .sorted { $0.date > $1.date }
        }
        
        return plant
    }
    
    // NSManagedObject → DiaryEntry 변환 - 필수 값 없으면 nil 반환
    private func convertToDiary(_ object: NSManagedObject) -> Planty.DiaryEntry? {
        guard let title = object.value(forKey: "title") as? String,
              let content = object.value(forKey: "content") as? String,
              let date = object.value(forKey: "date") as? Date else {
            return nil
        }
        
        var diary = Planty.DiaryEntry(title: title, content: content, date: date)
        
        // 저장된 UUID로 id 복원
        if let id = object.value(forKey: "id") as? UUID {
            diary.id = id
        }
        
        // 아카이브된 Data 배열을 UIImage 배열로 복원
        if let photosData = object.value(forKey: "photos") as? Data,
           let dataArray = try? NSKeyedUnarchiver.unarchivedObject(
            ofClasses: [NSArray.self, NSData.self],
               from: photosData
           ) as? [Data] {
            diary.photoImages = dataArray.compactMap { UIImage(data: $0) }
        }
        
        return diary
    }
}
