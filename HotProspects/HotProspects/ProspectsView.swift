//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Arin Asawa on 12/19/20.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum FilterType{
        case none, contacted, uncontacted
    }
    @EnvironmentObject var prospects:Prospects
    @State private var isShowingScanner = false
    let filter:FilterType
    var title:String{
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        
    }
    }
    
    var filteredProspects:[Prospect]{
        switch filter{
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { (prospect) -> Bool in
                prospect.isContacted
            }
        case .uncontacted:
            return prospects.people.filter { (prospect) -> Bool in
                !prospect.isContacted
            }
            
        }
    }
    var body: some View{
        NavigationView{
            List{
                ForEach(filteredProspects){prospect in
                    HStack{
                        VStack(alignment: .leading){
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if prospect.isContacted{
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .font(.title)
                        }
                        
                    }
                    .contextMenu{
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted"){
                            prospects.toggle(prospect)
                        }
                        if !prospect.isContacted{
                            Button("Remind Me"){
                                addNotification(for: prospect)
                            }
                        }
                    }
                }
                .onDelete { (IndexSet) in
                    prospects.deleteProspect(at: IndexSet)
                }
            }
                .navigationBarTitle(title)
                .navigationBarItems(trailing:
                                        Button(action: {
                                            self.isShowingScanner = true
                                        } ){
                                            Image(systemName: "qrcode.viewfinder")
                                            Text("Scan")
                                        }
                
                )
            .sheet(isPresented: $isShowingScanner){
                CodeScannerView(codeTypes:[.qr], simulatedData: "Arin Asawa\n arin.asawa@icloud.com",completion: self.handleScan)
            }
        }
    }
    
    func handleScan(result:Result<String,CodeScannerView.ScanError>){
        self.isShowingScanner = false
        switch result{
        case .success(let code):
            let components = code.split(separator: "\n").map(String.init)
            guard components.count == 2 else {return}
            let prospect = Prospect()
            prospect.name = components[0]
            prospect.emailAddress = components[1]
            self.prospects.add(prospect)
        case .failure( _):
            print("Scanning Failed")
        }
    }
    
    func addNotification(for prospect:Prospect){
            let center = UNUserNotificationCenter.current()
            let addRequest = {
                let content = UNMutableNotificationContent()
                content.title = "Contact \(prospect.name)"
                content.subtitle = prospect.emailAddress
                content.sound = UNNotificationSound.default
                
                var dateComponents = DateComponents()
                dateComponents.hour = 9
               // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
        }
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized{
                addRequest()
            }else{
                center.requestAuthorization(options: [.alert,.badge,.sound,.provisional]) { (success, error) in
                    if success{
                        addRequest()
                    }
                }
            }
        }
        
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
