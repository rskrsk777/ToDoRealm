
import Foundation
import RealmSwift

@objcMembers class ToDoItem: Object {
    enum Property: String {
        case id, text, isCompleted
    }
    
    dynamic var id = UUID().uuidString
    dynamic var text = ""
    dynamic var isCompeleted = false
    
    override static func primaryKey() -> String? {
        return ToDoItem.Property.id.rawValue
    }
    
    convenience init (_ text: String) {
        self.init()
        self.text = text
    }
}

extension ToDoItem {
    
    @discardableResult
    static func add (text: String, in realm: Realm = try! Realm()) -> ToDoItem {
        let item = ToDoItem(text)
        try! realm.write {
            realm.add(item)
        }
        return item
    }
    
    static func all(in realm: Realm = try! Realm()) -> Results<ToDoItem> {
        return realm.objects(ToDoItem.self)
    }
    
    func delete () {
        guard let realm = realm else {
            return
        }
        try! realm.write {
            realm.delete(self)
        }
    }
    
    static func toggleIsCompleted(_ item: ToDoItem, in realm: Realm = try! Realm()) {
        try! realm.write {
            item.isCompeleted = !(item.isCompeleted)
        }
    }
}


