//
//  Search.swift
//  MusicPlayer
//
//  Created by 123 on 18.01.24.
//

import SwiftUI

struct Search: View {
    
    @State var searchText: String = ""
    @State var sampleSortList = [SongModel]()
    
    @EnvironmentObject var songManager: SongManager
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search", text: $searchText)
                    .padding(.horizontal)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .clipShape(Capsule())
            .padding(.horizontal)
            
            ScrollView {
                ForEach(sampleSortList) { item in
                    HStack {
                        AsyncImage(url: URL(string: item.cover)) { img in
                            img.resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)
                        
                        VStack(alignment:.leading){
                            Text("\(item.title)")
                                .font(.headline)
                            
                            Text("\(item.artist)")
                                .font(.caption)
                            
                        }
                        Spacer()
                    }
                    .onTapGesture {
                        songManager.playSong(song: item)
                    }
                }
                
            }
            .padding()
        }
        .onChange(of: searchText, perform: { value in
            let searchString = searchText.lowercased() // Приводим строку поиска к нижнему регистру
            sampleSortList = sampleSongModel.filter { item in
                let title = item.title.lowercased() // Приводим заголовок к нижнему регистру
                let artist = item.artist.lowercased() // Приводим артиста к нижнему регистру
                return title.contains(searchString) || artist.contains(searchString)
            }
        })
        .onTapGesture { // Добавляем Gesture для скрытия клавиатуры
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
    }
}



#Preview {
    Search()
        .preferredColorScheme(.dark)
}
