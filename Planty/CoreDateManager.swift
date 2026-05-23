//
//  CoreDataManager.swift
//  Planty
//
//  Created by choeun on 5/21/26.
//

import UIKit
import CoreData

class CoreDataManager {
    
    // MARK: - Singleton
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Planty")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData 로드 실패: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save
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
    
    // 식물 추가
    func createPlant(_ plant: Planty.Plant) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "PlantEntity", into: context)
        entity.setValue(plant.id, forKey: "id")
        entity.setValue(plant.name, forKey: "name")
        entity.setValue(plant.species, forKey: "species")
        entity.setValue(plant.startDate, forKey: "startDate")
        entity.setValue(plant.waterCycle, forKey: "waterCycle")
        
        // 사진 저장
        if let image = plant.photoImage,
           let data = image.jpegData(compressionQuality: 0.8) {
            entity.setValue(data, forKey: "photo")
        }
        
        saveContext()
    }
    
    // 식물 전체 조회
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
    
    // 식물 수정
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
                }
                saveContext()
            }
        } catch {
            print("수정 실패: \(error)")
        }
    }
    
    // 식물 삭제
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
    
    // 일지 추가
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
                
                // 사진 저장
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
                
                // PlantEntity와 연결
                let diaries = plantEntity.mutableSetValue(forKey: "diaries")
                diaries.add(diaryEntity)
                
                saveContext()
            }
        } catch {
            print("일지 추가 실패: \(error)")
        }
    }
    
    // 일지 수정
    func updateDiary(_ diary: Planty.DiaryEntry, for plant: Planty.Plant) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "DiaryEntity")
        request.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first {
                entity.setValue(diary.title, forKey: "title")
                entity.setValue(diary.content, forKey: "content")
                entity.setValue(diary.date, forKey: "date")
                
                // 사진 저장
                if !diary.photoImages.isEmpty {
                    let data = diary.photoImages.compactMap {
                        $0.jpegData(compressionQuality: 0.8)
                    }
                    let archivedData = try? NSKeyedArchiver.archivedData(
                        withRootObject: data,
                        requiringSecureCoding: false
                    )
                    entity.setValue(archivedData, forKey: "photos")
                }
                saveContext()
            }
        } catch {
            print("일지 수정 실패: \(error)")
        }
    }
    
    // 일지 삭제
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
    
    // NSManagedObject → Plant 변환
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
        
        // id 복원
        if let id = object.value(forKey: "id") as? UUID {
            plant.id = id
        }
        
        // 사진 복원
        if let photoData = object.value(forKey: "photo") as? Data {
            plant.photoImage = UIImage(data: photoData)
        }
        
        // 일지 복원
        if let diarySet = object.value(forKey: "diaries") as? Set<NSManagedObject> {
            plant.diaries = diarySet.compactMap { convertToDiary($0) }
                .sorted { $0.date > $1.date }
        }
        
        return plant
    }
    
    // NSManagedObject → DiaryEntry 변환
    private func convertToDiary(_ object: NSManagedObject) -> Planty.DiaryEntry? {
        guard let title = object.value(forKey: "title") as? String,
              let content = object.value(forKey: "content") as? String,
              let date = object.value(forKey: "date") as? Date else {
            return nil
        }
        
        var diary = Planty.DiaryEntry(title: title, content: content, date: date)
        
        // id 복원
        if let id = object.value(forKey: "id") as? UUID {
            diary.id = id
        }
        
        // 사진 복원
        if let photosData = object.value(forKey: "photos") as? Data,
           let dataArray = try? NSKeyedUnarchiver.unarchivedObject(
               ofClass: NSArray.self,
               from: photosData
           ) as? [Data] {
            diary.photoImages = dataArray.compactMap { UIImage(data: $0) }
        }
        
        return diary
    }
}
