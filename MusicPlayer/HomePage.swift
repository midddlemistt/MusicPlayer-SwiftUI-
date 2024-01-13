//
//  HomePage.swift
//  MusicPlayer
//
//  Created by 123 on 14.01.24.
//

import SwiftUI

struct HomePage: View {
    @State private var expandSheet = false
    @Namespace private var animation
    
    @EnvironmentObject var songManager: SongManager
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                Header
                    .frame(height: geometry.safeAreaInsets.top + 50)
                    .padding(.top, geometry.safeAreaInsets.top)

                TagsView()
                
                QuickPlay()
                
                LargeCards()
            }
            .ignoresSafeArea(edges: .top)
        }
    }
        
        // Header
    var Header: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading)
            {
                HStack(spacing:15)
                {
                    Text("Welcome!😇")
                        .font(.title2)
                    
                    Spacer()
                    
                    Image(systemName: "bell")
                        .imageScale(.large)
                        .padding(5)
                    
                    Image("User")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                .padding(.horizontal)
                .padding(.top, geometry.safeAreaInsets.top + 120)
                .background(LinearGradient(colors: [.red.opacity(0.5), .clear], startPoint: .top, endPoint: .bottom))
                .frame(width: .infinity, height: geometry.safeAreaInsets.top )
            }
        }
    }

    
    //TagsView
    @ViewBuilder func TagsView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(sampleTagList, id: \.id) { item in
                    Text(item.tag)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 12).fill(.white.opacity(0.15)) )
                    
                }
            }
            .padding()
        }
    }
    
    
    //Quick Play Songs
    @ViewBuilder func QuickPlay() -> some View {
        VStack {
            HStack {
               Text ("Quick play")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(60)), GridItem(.fixed(60)), GridItem(.fixed(60)), GridItem(.fixed(60))], content: {
                    ForEach(sampleSongModel,id: \.id) { item in
                        HStack(spacing: 20, content: {
                            AsyncImage(url: URL(string: item.cover)) {img in
                                img.resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                                    .background(.white.opacity(0.1))
                                    .clipShape(.rect(cornerRadius:5))
                            }
                            .frame(width: 60, height: 60)
                                .clipShape(.rect(cornerRadius:5))
                            
                            VStack(alignment: .leading) {
                                Text("\(item.title)")
                                    .font(.headline)
                                
                                Text("\(item.artist)")
                                    .font(.caption)
                            }
                            
                            Spacer()
                        })
                        .onTapGesture {
                            songManager.playSong(song: item)
                        }
                        
                        
                        
                    }
                })
                .padding(.horizontal)
            }
        }
    }
    
    
    //Large Cards View -> New Releases
    @ViewBuilder func LargeCards() -> some View {
        VStack {
            HStack {
                Text("New Releases")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing:15) {
                    ForEach(sampleSongModel, id: \.id) { item in
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: item.cover)) {img in
                                img.resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 150, height: 150)
                            
                                Text("\(item.title)")
                                    .font(.headline)
                                
                                Text("\(item.artist)")
                                    .font(.caption)
                        }
                        .onTapGesture {
                            songManager.playSong(song: item)
                        }
                    }
                }
                .padding(.horizontal)
                
            }
            
        }
    }
    
    
    
    // Здесь мы создаем функцию для получения размера верхней безопасной области
    
//    func getSafeAreaTop() -> CGFloat {
//        guard let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive })
//            .map({ $0 as? UIWindowScene })
//            .compactMap({$0})
//            .first?.windows
//            .filter({$0.isKeyWindow}).first else {
//                return 0
//        }
//        return keyWindow.safeAreaInsets.top
//    }

    
    
    
    
    

}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
