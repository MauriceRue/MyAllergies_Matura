//
//  ContentView.swift
//  MyAllergies_Matura
//
//  Created by Maurice Ruefenacht on 12.12.2023.
//
//  Code stammt teils vom Entwickler Paul Hudson (CodeScanner) und von der Entwicklerin Ale Patron (für den QR-Code Generator)


import SwiftUI
import CodeScanner




let itemsKey = "personalAllergyCode_Key"
var personalAllergyCode = [111]







// Diese Funktion ist dafür zustänig, dass die gespeicherten Daten, welche dem Key "itemsKey" zugeschrieben wurden, abgerufen werden.

func getAllergyCode () -> [Int]? {
    guard let data = UserDefaults.standard.data(forKey: itemsKey) else { return nil}
    
    //Falls die abgerufenen Daten "encodet" werden können und in einen Array mit Integers verwandelt werden können, so werden diese Daten als Resulat der Funktion "ausgespuckt".

    if let decodedData = try? JSONDecoder().decode([Int].self, from: data) {
            return decodedData
        } else {
            return nil
        }
    
}



//Struct ContentView erstellt eine Ansicht, mit welcher der benutzer schlussendlich interagieren kann. Diese besteht in diesem Fall aus einer Kombination verschiedener Views, welche mithif einer Tabvview verbunden werden. (Es gibt unten eine Auswahlleiste, mit der man zwischen den einzelnen Views wechseln kann.)

struct ContentView: View {
    var body: some View {
        
            
            
            TabView {
                View_QRCode_Scanner()
                    .tabItem() {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scanner")
                    }
                
                View_PersonalAllergies()
                    .tabItem() {
                        Image(systemName: "person")
                        Text(NSLocalizedString("Meine Allergien", comment:""))
                    }
                
                View_Generator()
                    .tabItem() {
                        Image(systemName: "paintbrush")
                        Text("Generator")
                    }
                
                
            
        }
        
        
        
        
    }
}


// Die View_PersonalAllergies ist die erste der obigen 3 Views, aus welcher die Contentview (Sie wird dem Nutzer angezeigt) besteht. Ihr Aufbau besteht aus einem Statustext, einem "Check"-Button und einem Scan "QR-Code" button.

struct View_PersonalAllergies: View {
    
// Der Array ArrayOfAllergens enthält die 21 wichtigsten Allergene. Das NSLocalized ist jeweils dafür da, dass die einzelnen Strings übersetzt werden können -> die localizable Datei kann so auf diese Strings "zugreifen".
    
    let arrayOfAllergens: [String] = [
        NSLocalizedString("Cashewnüsse", comment: ""),
            NSLocalizedString("Eier", comment: ""),
            NSLocalizedString("Erdnüsse", comment: ""),
            NSLocalizedString("Fisch", comment: ""),
            NSLocalizedString("Glutenhaltiges Getreide", comment: ""),
            NSLocalizedString("Haselnüsse", comment: ""),
            NSLocalizedString("Krebstiere", comment: ""),
            NSLocalizedString("Laktose", comment: ""),
            NSLocalizedString("Lupinen", comment: ""),
            NSLocalizedString("Macadamianüsse", comment: ""),
            NSLocalizedString("Mandeln", comment: ""),
            NSLocalizedString("Paranüsse", comment: ""),
            NSLocalizedString("Pekannüsse", comment: ""),
            NSLocalizedString("Pistazien", comment: ""),
            NSLocalizedString("Schwefeldioxid und Sulfite", comment: ""),
            NSLocalizedString("Sellerie", comment: ""),
            NSLocalizedString("Senf", comment: ""),
            NSLocalizedString("Sesamsamen", comment: ""),
            NSLocalizedString("Sojabohnen", comment: ""),
            NSLocalizedString("Walnüsse", comment: ""),
            NSLocalizedString("Weichtiere", comment: "")
    ]



    

    
    @State private var ArrayOfAllergenIndexState = Array(repeating: false, count: 23)
    //Das ist der ein Array, welcher angibt, welche Allergene gewählt wurden.
    
    
    
    // Der personalAllergyCode Array wird aus einem leeren preCode gebildet, welcher für jedes Element im Array ArrayOfAllergenIndexState, welches true ist, den entsprechenden Index als Array-Element "anhängt".
    
    @State var savedPersonalAllergyCode:Array = UserDefaults.standard.array(forKey: "SavingKeyForArrayOfAllergenIndexState") ?? []
    // Dieser savedPersonalAllergyCode ist ein gespeicherter Array, welcher den anderen Array PersonalAllergyCode später "aufnehmen" wird. Der Key wird später als Verweis dazu verwendet, damit das Programm weiss in welchem Array (hier: savedPersonalAllergyCode) etwas gespeichert werden soll.
    
    
    @State private var searchText = ""
    //Anfangszustand für Suchtext
    
    let localizedAlternativeTerms: [[String]] = [
        
            [NSLocalizedString("Cashewnüsse", comment: ""), NSLocalizedString("Cashewnuss", comment: ""),NSLocalizedString("Kaschunuss", comment: ""),NSLocalizedString("Kaschunüsse", comment: "")],
            [NSLocalizedString("Eier", comment: "")],
            [NSLocalizedString("Erdnüsse", comment: "")],
            [NSLocalizedString("Fisch", comment: ""), NSLocalizedString("Fische", comment: ""), ],
            [NSLocalizedString("Glutenhaltiges Getreide", comment: ""),NSLocalizedString("Weizen", comment: ""), NSLocalizedString("Roggen", comment: ""), NSLocalizedString("Gerste", comment: ""),NSLocalizedString("Dinkel", comment: ""),NSLocalizedString("Hafer", comment: "")],
            [NSLocalizedString("Haselnüsse", comment: ""),NSLocalizedString("Haselnuss", comment: "")],
            [NSLocalizedString("Krebstiere", comment: "")],
            [NSLocalizedString("Laktose", comment: ""), NSLocalizedString("Milch", comment: "")],
            [NSLocalizedString("Lupinen", comment: "")],
            [NSLocalizedString("Macadamianüsse", comment: ""),NSLocalizedString("Macadamianuss", comment: ""),NSLocalizedString("Queenslandnüsse", comment: ""), NSLocalizedString("Queenslandnuss", comment: "")],
            [NSLocalizedString("Mandeln", comment: "")],
            [NSLocalizedString("Paranüsse", comment: ""), NSLocalizedString("Paranuss", comment: "")],
            [NSLocalizedString("Pekannüsse", comment: ""), NSLocalizedString("Pekannuss", comment: "")],
            [NSLocalizedString("Pistazien", comment: "")],
            [NSLocalizedString("Schwefeldioxid und Sulfite", comment: "")],
            [NSLocalizedString("Sellerie", comment: "")],
            [NSLocalizedString("Senf", comment: "")],
            [NSLocalizedString("Sesamsamen", comment: "")],
            [NSLocalizedString("Sojabohnen", comment: ""), NSLocalizedString("Edamame", comment: "")],
            [NSLocalizedString("Walnüsse", comment: ""), NSLocalizedString("Walnuss", comment: "")],
            [NSLocalizedString("Weichtiere", comment: ""), NSLocalizedString("Tintenfische", comment: ""), NSLocalizedString("Oktopus", comment: "")]
    ]

// Das sind alternative Begriffe, welche auch mit der Suche funktionieren. Dieser Array (localizedAlternativeTerms) besteht aus weiteren Arrays, welche jeweils einen Index haben. Diese Indexe stimmen mit denen des Arrays arrayOfAllergens überein, so dass die Synonyme als auch die "Originalbegriffe" denselben Index haben.


    
   var filteredAllergens: [String] {
           if searchText.isEmpty {
               return arrayOfAllergens
           } else {
               return arrayOfAllergens.filter { allergen in
                   
                   // Nun wird für jedes einzelne Allergen getestet ob auch andere mögliche Synonyme mit der Liste übereinstimmen. Zuerst wird von jedem Allergen der Index abgerufen. Für diesen jeweiligen Index, wird dann der Array mit den Synonymen aus dem "übergeordneten" Array (localizedAlternativeTerms) bestimmt. Dieser wird für jedes Synonym (term) anschliessend darauf geprüft, ob er das Suchresultat enthält. Dieser Vergleich geschieht ohne auf Gross- oder Kleinschreibung zu achten. (localizedCaseInsensitive)
                   let allergenIndex = arrayOfAllergens.firstIndex(of: allergen) ?? 0
                   let allergenAlternatives = localizedAlternativeTerms[allergenIndex]
                   return allergenAlternatives.contains { term in
                       term.localizedCaseInsensitiveContains(searchText)
                   }
               }
           }
       }
    
    var savingButtonText = NSLocalizedString("Speichern", comment: "")
    //Dieser Text steht auf dem Button für das Speichern. Auch er ist localized, das heisst: er "greift" zur Übersetzung auf die localizable Datei zu.


    

    
    var body: some View {
        NavigationView(){

            
            VStack {
                // Mithilfe eines V Stacks innerhalb einer Navigationview kann man trotzdem noch die Liste durchsuchen, hat jedoch stets einen Button zum Speichern, welchen man betätigen kann.
               
                List(filteredAllergens, id: \.self){
                    allergen in Toggle(allergen, isOn: $ArrayOfAllergenIndexState[arrayOfAllergens.firstIndex(of: allergen) ?? 0])
                }.navigationTitle("Meine Allergien")
                    .searchable(text: $searchText)
                
                //Die Liste kann so durchsucht werden mithilfe des ".searchable" Anhängsels. Dazu wird nun der Array filteredAllergens als Liste dargestellt. Dieser wiederum ändert sich durch die Suche wie oben beschrieben
                
                
                // Mithilfe einer Liste können wir die einzelnen Allergene als Buttons darstellen. Durch ArrayOfAllergenIndexState gibt es für jeden Toggle einen eigenen Wert, welcher bestimmt ob der Button "on" (true) oder "off" (false) ist. -> Für jedes allergen (Element in filteredAllergens) wird ein Toggle erstellt, welcher den Wert des jeweiligen Index von "ArrayOfAllergenIndexState" (ein Array bestehend aus True und false) hat. Falls er keinen Index findet, wird der Toggle auf den Standardwert (welcher in Swift "false" ist) gesetzt. (?? 0) Falls der Toggle betätigt wird ändert sich ausserdem der ArrayOfAllergenIndexState
                




                Button(savingButtonText) {
                                    UserDefaults.standard.set(ArrayOfAllergenIndexState, forKey: "SavingKeyForArrayOfAllergenIndexState")
                                    saveAllergyCode()

                                    //Der ArrayOfAllergenIndexState "schreibt" die Daten mithilfe von UserDefaults auf den Key "SavingKeyForArrayOfAllergenIndexState". Auf diese Daten werden wiederum zugegriffen, sobald die View wieder erscheint (.onAppear) und sorgt dafür, dass die Toggles stets das anzeigen, was gespeichert wurde.
                                }
                                .padding()
                                .bold()
                            }
                            .onAppear {
                                
                                //.onAppear sorgt dafür, dass die ausgewählten Allergene angezeigt werden, sobald die View "appeared" (erscheint). Alles in den {}-Klamern von ".onAppear" wird ausgeführt, sobald die View erscheint.

                                if let savedData = UserDefaults.standard.array(forKey: "SavingKeyForArrayOfAllergenIndexState") as? [Bool] {
                                    ArrayOfAllergenIndexState = savedData
                                }
                                //Die savedData ruft die zuvor in Userdefaults gespeicherten Daten unter dem Key "SavingKeyForArrayOfAllergenIndexState" ab und setzt den ArrayOfAllergenIndexState auf diesen.
                            }
                        }
                    }
    
    
    

            func saveAllergyCode() {
                     

                var personalAllergyCode: [Int] = []

                for (index, value) in ArrayOfAllergenIndexState.enumerated() {
                    if value {
                        personalAllergyCode.append(index)
                        
                        //  Falls ein Allergen den Status "true" trägt, wird der jeweilige Index an den personalAllergyCode angehängt.(Für jeden "Index", der "Value" hat, wird das entsprechende Element angehängt.) Resultat ist ein Array, bestehend aus den Indexen der ausgewählten Allergene.
                    }
                }
                        if let encodedData = try? JSONEncoder().encode(personalAllergyCode) {
                            UserDefaults.standard.set(encodedData, forKey: itemsKey)
                            //  Die Daten werden zuerst encoded (kodiert) und dann mithilfe von UserDefaults gespeichert.
                            //  Dies ist hier notwendig, da dies hierbei für die spätere Verwendung beim Scannen des Codes Bedeutung hat.
                        }
                    }
    
    
    
    
    
    
                }











struct View_QRCode_Scanner: View {
    
 
    

    

    
    @State var productArray = [11111]
    //Dieser wird beim Scan durch die Daten vom QR-Code ersetzt.
    
    
  
    
 
    
    
    @State private var isShowingScanner = false
    @State private var QRCodeHasBeenSuccessful = false
    @State private var QRCodeHasNotBeenDone = true
    //Wir brauchen diese Variabeln für den vom Entwickler Paul Hudson vorgelegten Code:

    
    //Die folgende Funktion sorgt dafür, was nachdem Scannen mit dem Scanresultat geschieht.
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        QRCodeHasNotBeenDone = false
       
        switch result {
        case .success(let result):
            let details = result.string
            // details ist der String, welcher sich aus dem Resultat ergibt. (Inhalt des QR-Codes.)
            
            if let data = details.data(using: .utf8) {
                    do {
                        productArray = try JSONDecoder().decode([Int].self, from: data)
                        // der Product Array wird auf die Daten aus dem Scanresultat gesetzt. Diese werden zuerst decoded, dass daraus ein Array aus Integers entsteht.
                        print(productArray)
                        QRCodeHasBeenSuccessful = true
                        statusStatement = NSLocalizedString("Drücke nun auf Check.", comment: "")

                        

                        colorOfStatusStatement = .gray

                        
                        
                        
                        
                        
                        
                    } catch let decodingError as DecodingError {
                        // JSON Decoding Errors:
                        print("JSON Decoding Error: \(decodingError.localizedDescription)")
                        QRCodeHasBeenSuccessful = false
                        statusStatement = NSLocalizedString("Scan hat nicht funktioniert.", comment: "")
                        colorOfStatusStatement = .gray


                    } catch {
                        // Andere Fehler:
                        print("Error: \(error.localizedDescription)")
                        QRCodeHasBeenSuccessful = false
                        statusStatement = NSLocalizedString("Scan hat nicht funktioniert.", comment: "")
                        colorOfStatusStatement = .gray

                    }
                }
            //Falls das Decoden nicht funktionieren sollte oder andere Probleme auftreten, würde der Statustext anzeigen, dass der Scan nicht funktioniert hat.
  
          
        case .failure(let error):
            print("scanning failed \(error.localizedDescription)")
            QRCodeHasBeenSuccessful = false
        }
      
    }
    
    
    
    
    //Der obige Code ist von dem Entwickler Paul Hudson , welcher das Package programmiert hat. Die Funktion HandleScan macht im Grundsatz folgendes: Es versteckt den Scanner und sagt dem Package, dass der Scan fertig ist. Danach wird der productArray dem Scanresultat gleichgesetzt. Dies geschieht durch die von mir angewendete Methode, mit welcher man aus den Zahlenwerten in der Variable "data", einen array erstellt. Besser gesagt den "productArray" mit diesen gleichstellt. So kann dieser zum späteren Vergleich verwendet werden, wenn wir den productArray mit dem personalAllergyCode vergleichen.
    // Tutorial dazu: https://www.youtube.com/watch?v=j3MODOPZINs&t=698s und das Package "CodeScanner" von Paul Hudson (twostraws auf GitHub: https://github.com/twostraws)
    
    
    @State var statusStatement = NSLocalizedString("Drücke Check nach dem Scan", comment: "")
    
    
    
    @State var colorOfStatusStatement: Color = .gray
    // diese Variablen verändern den Status, welcher nach dem Scan angezeigt wird.
    
    
    @State private var savedPersonalAllergyCode = [1111]
    //Anfangszustand für den savedPersonalAllergyCode. Dieser ändert sich, sobald mithilfe der Funtion getAllergyCode(). Diese wiederum ruft die Daten mithilfe von Userdefaults unter dem Key "itemsKey = "personalAllergyCode_Key"" ab.
    
    var body: some View {
        
        
        
        NavigationView {
            
            
            List {
                
                
                Section(header: Text("Status")) {
                    Text("\(statusStatement)")
                }.foregroundColor(colorOfStatusStatement)
                
                //Der Statustext gibt an, ob man allergisch ist oder nicht, ob das Scannen funktioniert hat oder auch ob man noch auf "check" drücken muss.
                
                Section {
                    Button("Scan QR-Code"){
                        isShowingScanner = true
                        
                        
                        //Der Scanner wird aktiviert. Der Code aus dem Package von Paul Hudson wird dadurch ausgeführt.
                        
                    }.fontWeight(.bold).foregroundColor(.blue)
                    
                    
                    Button("Check"){
                        
                        if let resultOfGetAllergyCode = getAllergyCode() {
                            print("success")
                            savedPersonalAllergyCode = resultOfGetAllergyCode

                            //der savedPersonalAllergyCode wird mithilfe der Funktion "getAllergyCode" mit den abgespeicherten Daten unter dem Key "itemsKey" "überschrieben".
                                                
                        } else {
                            print("failed")
                        }
                        
                       
                        
                        print("savedPersonalAllergyCode lautet laut ScannerCheck: \(savedPersonalAllergyCode)")
                        
                        let intersection = Set(savedPersonalAllergyCode).intersection(productArray)
                        //dies vergleicht die beiden arrays, indem es schaut ob sie gemeinsame Elemente haben, welche dann in dem Array "intersection" kurzzeitig gespeichert werden.

                        
                        if QRCodeHasNotBeenDone == false {
                            //falls der QrCode Scan stattgefunden hat, tritt folgender code ein:
                            
                            if QRCodeHasBeenSuccessful == true {
                                //falls der QrCode Scan erfolgreich war, tritt folgender code ein:

                                if intersection.count > 0 {
                                    //Falls es eine Übereinstimmung gibt. Das heisst es gibt einen Array, welcher nicht leer ist, dann tritt folgender Code ein:
                                    
                                    print("Du bist allergisch.")
                                    statusStatement = NSLocalizedString("Du bist allergisch.", comment: "")
                                    colorOfStatusStatement = .red
                                    print(Array(intersection))
                                    
                                } else {
                                    //Falls der Array intersection keine Elemente enthält, gibt es keine Übereinstimmung und folgender Code tritt ein:
                                    print("Du bist nicht allergisch.")
                                    statusStatement = NSLocalizedString("Du bist nicht allergisch.", comment: "")
                                    colorOfStatusStatement = .green
                                }
                                
                                 //falls der QrCode Scan nicht erfolgreich war, tritt folgender code ein:
                            } else {
                                print("Scan hat nicht funktioniert.")
                                statusStatement = NSLocalizedString("Scan hat nicht funktioniert.", comment: "")
                                colorOfStatusStatement = .gray
                            }
                            
                            //falls der QrCode Scan nicht stattgefunden hat, tritt folgender code ein:
                        } else {
                            print("Scan wurde noch nicht gemacht.")
                            statusStatement = NSLocalizedString("Scan wurde noch nicht gemacht.", comment: "")
                            colorOfStatusStatement = .gray
                        }
                        
                     
                 
                    }.foregroundColor(.blue)
                    
                  
                    
    
                    
                }
          
                
                
            }.navigationTitle("MyAllergies Scanner")
        }
        .sheet(isPresented: $isShowingScanner) { CodeScannerView(codeTypes: [.qr], simulatedData: "SimulatedData", completion: handleScan)
        }
        //Wenn "isShowingScanner" true ist, wird ein Sheet, eine Art Overlay angezeigt. In diesem Overlay befindet sich die View "CodeScannerView", welche im Package von Paul Hudson definiert ist. Es wird ausserdem angegeben, dass es sich nur um qr Codes handelt. Bei der Compleation des Scans soll die Funktion "handleScan" ausgeführt werden. Diese verwendet das Scanresultat für weiter Zwecke --> siehe oben.
        
        
    }
}
















struct View_Generator: View {
    
    @State private var urlInput: Array = [2222]
    @State private var qrCode: QRCode?
    
    private let qrCodeGenerator = QRCodeGenerator()
    @StateObject private var imageSaver = ImageSaver()
    

    
    let arrayOfAllergens: [String] = [
            NSLocalizedString("Cashewnüsse", comment: ""),
            NSLocalizedString("Eier", comment: ""),
            NSLocalizedString("Erdnüsse", comment: ""),
            NSLocalizedString("Fisch", comment: ""),
            NSLocalizedString("Glutenhaltiges Getreide", comment: ""),
            NSLocalizedString("Haselnüsse", comment: ""),
            NSLocalizedString("Krebstiere", comment: ""),
            NSLocalizedString("Laktose", comment: ""),
            NSLocalizedString("Lupinen", comment: ""),
            NSLocalizedString("Macadamianüsse", comment: ""),
            NSLocalizedString("Mandeln", comment: ""),
            NSLocalizedString("Paranüsse", comment: ""),
            NSLocalizedString("Pekannüsse", comment: ""),
            NSLocalizedString("Pistazien", comment: ""),
            NSLocalizedString("Schwefeldioxid und Sulfite", comment: ""),
            NSLocalizedString("Sellerie", comment: ""),
            NSLocalizedString("Senf", comment: ""),
            NSLocalizedString("Sesamsamen", comment: ""),
            NSLocalizedString("Sojabohnen", comment: ""),
            NSLocalizedString("Walnüsse", comment: ""),
            NSLocalizedString("Weichtiere", comment: "")
    ]


   // Der Array ArrayOfAllergens enthält die 21 wichtigsten Allergene. Das NSLocalized ist jeweils dafür da, dass die einzelnen Strings übersetzt werden können -> die localizable Datei kann so auf diese Strings "zugreifen"
    
    @State private var ArrayOfAllergenIndexState = Array(repeating: false, count: 23)
    //Das ist der ein Array, welcher angibt, welche Allergene gewählt wurden.
    
    
    
    @State private var searchText = ""
    //Anfangszustand für Suchtext
   
    
    let localizedAlternativeTerms: [[String]] = [
        
    
        
        
            [NSLocalizedString("Cashewnüsse", comment: ""), NSLocalizedString("Cashewnuss", comment: ""),NSLocalizedString("Kaschunuss", comment: ""),NSLocalizedString("Kaschunüsse", comment: "")],
            [NSLocalizedString("Eier", comment: "")],
            [NSLocalizedString("Erdnüsse", comment: "")],
            [NSLocalizedString("Fisch", comment: ""), NSLocalizedString("Fische", comment: ""), ],
            [NSLocalizedString("Glutenhaltiges Getreide", comment: ""),NSLocalizedString("Weizen", comment: ""), NSLocalizedString("Roggen", comment: ""), NSLocalizedString("Gerste", comment: ""),NSLocalizedString("Dinkel", comment: ""),NSLocalizedString("Hafer", comment: "")],
            [NSLocalizedString("Haselnüsse", comment: ""),NSLocalizedString("Haselnuss", comment: "")],
            [NSLocalizedString("Krebstiere", comment: "")],
            [NSLocalizedString("Laktose", comment: ""), NSLocalizedString("Milch", comment: "")],
            [NSLocalizedString("Lupinen", comment: "")],
            [NSLocalizedString("Macadamianüsse", comment: ""),NSLocalizedString("Macadamianuss", comment: ""),NSLocalizedString("Queenslandnüsse", comment: ""), NSLocalizedString("Queenslandnuss", comment: "")],
            [NSLocalizedString("Mandeln", comment: "")],
            [NSLocalizedString("Paranüsse", comment: ""), NSLocalizedString("Paranuss", comment: "")],
            [NSLocalizedString("Pekannüsse", comment: ""), NSLocalizedString("Pekannuss", comment: "")],
            [NSLocalizedString("Pistazien", comment: "")],
            [NSLocalizedString("Schwefeldioxid und Sulfite", comment: "")],
            [NSLocalizedString("Sellerie", comment: "")],
            [NSLocalizedString("Senf", comment: "")],
            [NSLocalizedString("Sesamsamen", comment: "")],
            [NSLocalizedString("Sojabohnen", comment: ""), NSLocalizedString("Edamame", comment: "")],
            [NSLocalizedString("Walnüsse", comment: ""), NSLocalizedString("Walnuss", comment: "")],
            [NSLocalizedString("Weichtiere", comment: ""), NSLocalizedString("Tintenfische", comment: ""), NSLocalizedString("Oktopus", comment: "")]
        
    ]

    
    
 // Das sind alternative Begriffe, welche auch mit der Suche funktionieren. Dieser Array (localizedAlternativeTerms) besteht aus weiteren Arrays, welche jeweils einen Index haben. Diese Indexe stimmen mit denen des Arrays arrayOfAllergens überein, so dass die Synonyme als auch die "Originalbegriffe" denselben Index haben.


    
   var filteredAllergens: [String] {
           if searchText.isEmpty {
               return arrayOfAllergens
           } else {
               return arrayOfAllergens.filter { allergen in
                   
                   //  Nun wird für jedes einzelne Allergen getestet, ob auch andere mögliche Synonyme mit der Liste übereinstimmen. Zuerst wird von jedem Allergen der Index abgerufen. Für diesen jeweiligen Index wird dann der Array mit den Synonymen aus dem "übergeordneten" Array (localizedAlternativeTerms) bestimmt. Dieser wird für jedes Synonym (term) anschliessend darauf geprüft, ob er das Suchresultat enthält. Dieser Vergleich geschieht ohne auf Gross- oder Kleinschreibung zu achten. (localizedCaseInsensitive)
                   
                   let allergenIndex = arrayOfAllergens.firstIndex(of: allergen) ?? 0
                   let allergenAlternatives = localizedAlternativeTerms[allergenIndex]
                   return allergenAlternatives.contains { term in
                       term.localizedCaseInsensitiveContains(searchText)
                   }
               }
           }
       }
    
    
    
    
    var generatingButtonText = NSLocalizedString("Generieren", comment: "")
    //Dieser Text steht auf dem Button für das Generieren.
    
    
    
    var body: some View {
        
        
        
        NavigationView {
            
            VStack {
                List(filteredAllergens, id: \.self){
                    allergen in Toggle(allergen, isOn: $ArrayOfAllergenIndexState[arrayOfAllergens.firstIndex(of: allergen) ?? 0])
                } .listStyle(.plain)
                .searchable(text: $searchText)
                
                //Die Liste kann so durchsucht werden mithilfe des ".searchable" Anhängsels. Dazu wird nun der Array filteredAllergens als Liste dargestellt. Dieser wiederum ändert sich durch die Suche wie oben beschrieben
                
                
                // Mithilfe einer Liste können wir die einzelnen Allergene als Toggles darstellen. Durch ArrayOfAllergenIndexState gibt es für jeden Toggle einen eigenen Wert, welcher bestimmt ob der Toggle "on" (true) oder "off" (false) ist. -> Für jedes allergen (Element in filteredAllergens) wird ein Toggle erstellt, welcher den Wert des jeweiligen Index von "ArrayOfAllergenIndexState" (ein Array bestehend aus True und false) hat. Falls er keinen Index findet, wird der Toggle auf den Standardwert (welcher in Swift "false" ist) gesetzt. (?? 0) Falls der Toggle betätigt wird ändert sich ausserdem der ArrayOfAllergenIndexState

               
          
                
                
                //Der folgende Code stammt zum Teil von Ale Patron: https://github.com/apatronl (Youtube Tutorial dazu: https://www.youtube.com/watch?v=HD_Fobpwt4M)
                
                GeometryReader { geometry in
                    VStack {
                        HStack {
                           
                            
                        
                            
                            Button(generatingButtonText) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                //FirstResponder ist hier die Tastatur. Es handelt sich um das "Objekt" in der View, welches als erstes reagiert. Diese wird nun durch obigen Code verschwinden. Es wird nun die Aktion aufgerufen, welche dazu führt, dass dieser First Responder "resigned". (.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil))
                                
                                var allergyQRCodeSetter: [Int] {
                                    var preCode: [Int] = []
                                    for (index, value) in ArrayOfAllergenIndexState.enumerated() {
                                        if value {
                                            preCode.append(index)
                                        }
                                    }
                                    return preCode
                                }
                                // Die Variable allergyQRCodeSetter besteht anfangs nur aus dem Precode. Für jedes angewählt Objekt (Für jeden Index, dessen Element auf true gestellt ist), wird dessen index an in Form eines Elements an den Array "Precode" angehängt. So entsteht für die angewählten Allergen jeweils ein Code bestehend aus einem Array mit Zahlen. Diese Zahlen sind jeweils die Indexe der Allergene im Array "arrayOfAllergens".
                                
                                urlInput = allergyQRCodeSetter

                                
                                qrCode = qrCodeGenerator.generateQRCode(forUrlString: "\(urlInput)")
                                urlInput = [2222]
                            }
                            .disabled(urlInput.isEmpty)
                            
                        }
                        .padding()
                        
                        if qrCode == nil {
                            EmptyStateView(width: geometry.size.width)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            QRCodeView(qrCode: qrCode!, width: geometry.size.width)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
            }
            .padding()
            .navigationBarTitle("QR Code Generator")
            .navigationBarItems(trailing: Button(action: {
                assert(qrCode != nil, "Cannot save nil QR code image")
                imageSaver.saveImage(qrCode!.uiImage)
            }) {
                Image(systemName: "square.and.arrow.down")
            }
            .disabled(qrCode == nil))
            .alert(item: $imageSaver.saveResult) { saveResult in
                return alert(forSaveStatus: saveResult.saveStatus)
            }
        }
        
        


}
    private func alert(forSaveStatus saveStatus: ImageSaveStatus) -> Alert {
        switch saveStatus {
        case .success:
            return Alert(
                title: Text(NSLocalizedString("Geschafft!", comment: "")),
                message: Text(NSLocalizedString("Der QR-Code wurde in deiner Foto Mediathek gespeichert.", comment: ""))
            )
        case .error:
            return Alert(
                title: Text("Oops!"),
                message: Text("Es ist ein Fehler aufgetreten.")
            )
        case .libraryPermissionDenied:
            return Alert(
                title: Text("Oops!"),
                message: Text(NSLocalizedString("Diese App braucht Zugriff auf das Hinzufügen von Bildern in die Mediathek.", comment: "")),
                primaryButton: .cancel(Text("Ok")),
                secondaryButton: .default(Text(NSLocalizedString("Öffne Einstellungen", comment: ""))) {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(settingsUrl)
                }
            )
        }
    }
    }

struct QRCodeView: View {
    let qrCode: QRCode
    let width: CGFloat
    
    var body: some View {
        VStack {
        
            Image(uiImage: qrCode.uiImage)
                .resizable()
                .frame(width: width * 2 / 4, height: width * 2 / 4)
            
        }
    }
    
}


struct EmptyStateView: View {
    let width: CGFloat
    
    private var imageLength: CGFloat {
        width / 2.5
    }
    
    var body: some View {
        
        VStack {
            Image(systemName: "qrcode")
                .resizable()
                .frame(width: imageLength, height: imageLength)
            
            
            Text("Generiere einen eigenen QR-Code")
                .padding(.top)
            
        }
        .foregroundColor(.gray)
        
    }
    
    
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
        
    }
}

