//
//  Prospect.swift
//  HotProspects
//
//  Created by Arin Asawa on 12/19/20.
//

import Foundation
class Prospect:Identifiable, Codable{
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

class Prospects:ObservableObject{
     @Published private(set) var people:[Prospect]
    static let saveKey = "SavedData"
    init() {
        if let data = try? Data(contentsOf: Self.getDocumentsDirectory().appendingPathComponent(Self.saveKey)){
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([Prospect].self, from: data){
                self.people = decodedData
                return
            }
        }
        self.people = []
    }
    
    private func save(){
        if let encoded = try? JSONEncoder().encode(people){
            let url = Self.getDocumentsDirectory().appendingPathComponent(Self.saveKey)
            do{
                try encoded.write(to: url)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    static private func getDocumentsDirectory()->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func add(_ prospect:Prospect){
        self.people.append(prospect)
        save()
    }
    func deleteProspect(at indexSet:IndexSet){
        people.remove(atOffsets: indexSet)
        save()
    }
    func toggle(_ prospect:Prospect){
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
