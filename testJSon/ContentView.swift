//
//  ContentView.swift
//  testJSon
//
//  Created by Стас Жингель on 02.09.2021.
//

import SwiftUI

struct ContentView: View {
    // 1.
    @State var key = ""
    @ObservedObject var fetch = FetchToDo()
    var body: some View {
        VStack {
            // 2.
            List(fetch.todos) { todo in
                HStack {
                    
                    URLImage(urlString: todo.photo, data: nil)
                        
                    
                    VStack(alignment: .leading) {
                        // 3.
                        Text(todo.name)
                        TextField("\(todo.photo)", text: $key)
                        
                        Text("\(todo.description)")
                            .font(.system(size: 11))
                            .foregroundColor(Color.gray)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PostsData: Codable {
    
    let posts: [Post]
}


struct Post: Codable, Identifiable {
    public var id: Int
    public var name: String
    public var description: String
    public var photo: String
}


class FetchToDo: ObservableObject {
  // 1.
  @Published var todos = [Post]()
     
    init() {
        let url = URL(string: "https://scripts.qexsystems.ru/test_ios/public/api/posts")!
        // 2.
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                if let todoData = data {
                    // 3.
                    let decodedData = try JSONDecoder().decode(PostsData.self, from: todoData)
                    DispatchQueue.main.async {
                        self.todos = decodedData.posts
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Error", error)
            }
        }.resume()
    }
}



struct URLImage: View {
    let urlString: String
    @State var data: Data?
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data.base64EncodedData()) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130, height: 70)
                .background(Color.gray)
        }
        else {
            Image(systemName: "video")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 130, height: 70)
                .background(Color.gray)
                .onAppear{
                    fetchData()
                }
        }
    }
    
    
    
    private func fetchData() {
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        task.resume()
    }
}






extension String {
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
