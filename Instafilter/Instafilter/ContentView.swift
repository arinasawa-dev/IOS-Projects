//
//  ContentView.swift
//  Instafilter
//
//  Created by Arin Asawa on 11/25/20.
//


import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image:Image?
    @State private var filterIntensity = 0.5
    @State private var inputImage:UIImage?
    @State private var showingFilterSheet = false
    @State private var showingImagePickerController = false
    @State private var processedImage:UIImage?
    @State private var showingErrorAlert = false
    @State private var currentFilter:CIFilter = CIFilter.sepiaTone()
    @State private var currentFilterName = "Sepia Tone"
    @State private var addingFilter = false
    @State private var degreesRotated = 0
    let context = CIContext()
    var body:some View{
        let intensity = Binding<Double>(
            get:{
                return filterIntensity
            },
            
            set: {
                self.filterIntensity = $0
                applyProcessing()
            }
        )
        
        return NavigationView{
            VStack{
                
                HStack{
                    Spacer()
                    Button(action: {self.degreesRotated -= 90}) {
                        Image(systemName: "rotate.left")
                            .font(.title)
                        
                        
                    }
                    .padding(.bottom)
                }
      
                    ZStack{
                        Rectangle()
                            .fill(Color.secondary)
                            .opacity(image == nil ? 1 : 0)
                        if let image = image{
                            image
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(Double(degreesRotated)))

                        }else{
                            Text("Tap To Select A Picture")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }

                    .onTapGesture {
                        showingImagePickerController = true
                        
                    }
                    
                    HStack{
                        Text("Intensity")
                        Slider(value: intensity)
                    }
                    .padding(.vertical)
                

                HStack{
                    Text("\(currentFilterName)")
                    Spacer()
                   
                    Button("Save"){
                        if let processedImage = processedImage{
                            let imageSaver = ImageSaver()
                            imageSaver.successHandler = {
                                print("Success!")
                            }
                            imageSaver.errorHandler = {
                                print("\($0.localizedDescription)")
                            }
                            ImageSaver().writeToPhotoAlbum(image: processedImage)
                            
                        }else{
                            self.showingErrorAlert = true
                        }
                    }
                    .alert(isPresented: $showingErrorAlert, content: {
                        Alert(title:Text("Oops!"), message: Text("Looks like there is no image to save"), dismissButton: .default(Text("OK")))
                    })
                    
                }
            }
            .padding([.horizontal,.bottom])
            .sheet(isPresented: $showingImagePickerController,onDismiss: loadImage, content: {
                ImagePicker(image: $inputImage)
            })
            .actionSheet(isPresented: $showingFilterSheet, content: {
                ActionSheet(title: Text("Choose A Filter"), message: nil, buttons: [
                    .default(Text("Crystalize"),action: {
                        setFilter(CIFilter.crystallize())
                        currentFilterName = "Crystalize"
                    }),
                    .default(Text("Edges"),action: {
                        setFilter(CIFilter.edges())
                        currentFilterName = "Edges"

                    }),
                    .default(Text("Gaussian Blur"),action: {
                        setFilter(CIFilter.gaussianBlur())
                        currentFilterName = "Gaussian Blur"

                    }),
                    .default(Text("Pixellate"),action: {
                        setFilter(CIFilter.pixellate())
                        currentFilterName = "Pixellate"
                    }),
                    .default(Text("Sepia Tone"),action: {
                        self.setFilter(CIFilter.sepiaTone())
                        currentFilterName = "Sepia Tone"
                    }),
                    .default(Text("Unsharp Mask"),action: {
                        self.setFilter(CIFilter.unsharpMask())
                        currentFilterName = "Unsharp Mask"

                    }),
                    .default(Text("Vignette"),action: {
                        setFilter(CIFilter.vignette())
                        currentFilterName = "Vignette"
                    }),
                    .cancel()
                
                
                ])
            })
            .navigationBarTitle("Instafilter")
            
            .navigationBarItems(leading:
                
                                    Button("Reset"){
                                        if let inputImage = inputImage{
                                            self.image = Image(uiImage: inputImage)
                                            self.processedImage = nil
                                            self.currentFilter.setValue(CIImage(image: inputImage), forKey: kCIInputImageKey)
                                        }
                                    }
                
                
                , trailing:
                                
                    Button("Add Filter", action: {
                        self.addingFilter = true
                        self.showingFilterSheet = true
                    })
                                
                                
                )
         
            
            
            
        }
    }
    
    func loadImage(){
        if let image = inputImage{
            let beginImage = CIImage(image:  image)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing(){
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey){
            currentFilter.setValue(filterIntensity*200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(filterIntensity*10, forKey: kCIInputScaleKey)
        }
        guard let outputImage = currentFilter.outputImage else {return}
        if let cgImg = context.createCGImage(outputImage, from: outputImage.extent){
            let uiImage = UIImage(cgImage: cgImg)
            self.image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter:CIFilter){
        self.currentFilter = filter
        if addingFilter{
            if let processedImage = processedImage{
                let beginImage = CIImage(image: processedImage)
                currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
                applyProcessing()
            }
        }else{
            loadImage()
        }
        addingFilter = false
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
