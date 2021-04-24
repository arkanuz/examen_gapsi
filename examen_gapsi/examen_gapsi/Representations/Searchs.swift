//
//  Searchs.swift
//  examen_gapsi
//
//  Created by Adolfo Lozada Serena on 24/04/21.
//

import UIKit
import CoreData

open class Searchs: NSObject {
    open var title: String = ""
    
    // Obtiene un listado de todas las búsquedas del usuario
    open class func getSearchs()-> [Searchs]? {
        let appDelegate = UIApplication.shared.delegate
        let context = (appDelegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Searchs")
        do {
            let array = try context.fetch(request)
            var searchs = [Searchs]()
            for object:NSManagedObject in array {
                let search = Searchs()
                search.title = object.value(forKey: "title") as! String
                searchs.append(search)
            }
            if searchs.count > 0 {
                return searchs
            } else {
                return nil
            }
        }
        catch let error as NSError {
            print("Ocurrió un error al obtener datos de búsquedas: \(error)")
            return nil
        }
    }
    
    // Retorna un listado con las busquedas previas que completan la palabra indicada
    open class func completeSearch(title: String)-> [Searchs]? {
        let appDelegate = UIApplication.shared.delegate
        let context = (appDelegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Searchs")
        let predicate = NSPredicate(format: "title beginswith[c] %@", title)
        request.predicate = predicate
        do {
            let array = try context.fetch(request)
            var searchs = [Searchs]()
            for object:NSManagedObject in array {
                let search = Searchs()
                search.title = object.value(forKey: "title") as! String
                searchs.append(search)
            }
            if searchs.count > 0 {
                return searchs
            } else {
                return nil
            }
        }
        catch let error as NSError {
            print("Ocurrió un error al obtener datos de búsquedas: \(error)")
            return nil
        }
    }
    
    // Guarda la búsqueda en caso de no existir previamente
    open class func saveSearch(title: String){
        let appDelegate = UIApplication.shared.delegate
        let context = (appDelegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Searchs")
        let predicate = NSPredicate(format: "title = %@", title)
        request.predicate = predicate
        do {
            let array = try context.fetch(request)
            if array.count == 0 {
                let object = NSEntityDescription.insertNewObject(forEntityName: "Searchs", into: context)
                object.setValue(title, forKey: "title")
                try! context.save()
            }
        }
        catch let error as NSError {
            print("Ocurrió un error al obtener datos de búsquedas: \(error)")
            return
        }
    }
    
    // Borra todas las búsquedas
    open class func deleteAllSearchs(){
        let appDelegate = UIApplication.shared.delegate
        let context = (appDelegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Search")
        do {
            let array = try context.fetch(request)
            if array.count > 0 {
                for object : NSManagedObject in array {
                    context.delete(object)
                }
            }
            
            try! context.save()
        } catch let error as NSError {
            print("Ocurrió un error al borrar los datos de búsqueda: \(error)")
        }
    }
    
    // Borra únicamente la búsqueda seleccionada
    open class func deleteSearch(title: String){
        let appDelegate = UIApplication.shared.delegate
        let context = (appDelegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Search")
        do {
            let array = try context.fetch(request)
            if array.count > 0 {
                for object : NSManagedObject in array {
                    context.delete(object)
                }
            }
            
            try! context.save()
        } catch let error as NSError {
            print("Ocurrió un error al borrar el dato de búsqueda \(title): \(error)")
        }
    }
}
