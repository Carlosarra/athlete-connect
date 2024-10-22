import SwiftUI
import Combine

struct ContentView: View {
    @State private var isFirstLaunch: Bool = true
    @State private var isProfileComplete: Bool = false
    
    var body: some View {
        if isFirstLaunch {
            RegistrationView(isFirstLaunch: $isFirstLaunch, isProfileComplete: $isProfileComplete)
        } else if !isProfileComplete {
            CompleteProfileView(isProfileComplete: $isProfileComplete)
        } else {
            MainTabView()
        }
    }
}

struct RegistrationView: View {
    @Binding var isFirstLaunch: Bool
    @Binding var isProfileComplete: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                if email.isEmpty || password.isEmpty {
                    showAlert = true
                } else {
                    sendRegistrationEmail()
                    isFirstLaunch = false
                }
            }) {
                Text("Register")
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.green)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Please complete all fields"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func sendRegistrationEmail() {
        // Logic to send registration email to carrazola24@gmail.com
    }
}

struct CompleteProfileView: View {
    @Binding var isProfileComplete: Bool
    @State private var name: String = ""
    @State private var city: String = ""
    @State private var team: String = ""
    @State private var age: String = ""
    @State private var gender: String = "Masculino"
    @State private var profileImage: UIImage?
    @State private var isImagePickerPresented = false
    let genders = ["Masculino", "Femenino", "Otro"]
    let ages = Array(1...150).map { "\($0)" }
    
    var body: some View {
        VStack {
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
            } else {
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                }
                .padding()
            }
            
            Form {
                Section(header: Text("Información Personal")) {
                    TextField("Nombre", text: $name)
                    TextField("Ciudad", text: $city)
                    TextField("Equipo", text: $team)
                    
                    Picker("Edad", selection: $age) {
                        ForEach(ages, id: \.self) { age in
                            Text(age)
                        }
                    }
                    
                    Picker("Género", selection: $gender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender)
                        }
                    }
                }
            }
            .padding()
            
            Button(action: {
                isProfileComplete = true
            }) {
                Text("Complete Profile")
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.green)
            }
            .padding()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $profileImage)
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    HeaderView()
                    SearchBarView()
                    AthleteListView()
                }
                .navigationTitle("Athlete Connect")
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Buscar Atletas")
            }
            
            NavigationView {
                PostListView()
            }
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Posts")
            }
            
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Perfil")
            }
            
            NavigationView {
                ChatListView()
            }
            .tabItem {
                Image(systemName: "message")
                Text("Chat")
            }
        }
        .accentColor(.green)
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("Welcome to Athlete Connect")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.green)
            Spacer()
        }
        .padding()
    }
}

struct SearchBarView: View {
    @State private var searchText: String = ""
    @State private var selectedDistance: String = "All"
    let distances = ["All", "5K", "10K", "Half Marathon", "Marathon"]
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search athletes or teams", text: $searchText)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                Button(action: {
                    // Search action
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal)
            
            Picker("Filter by Distance", selection: $selectedDistance) {
                ForEach(distances, id: \.self) { distance in
                    Text(distance)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
        }
    }
}

struct AthleteListView: View {
    var body: some View {
        List {
            ForEach(0..<10) { index in
                NavigationLink(destination: AthleteDetailView()) {
                    AthleteRowView()
                }
            }
        }
    }
}

struct AthleteRowView: View {
    var body: some View {
        HStack {
            ImagePlaceholderView(url: "https://source.unsplash.com/random/100x100")
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text("Athlete Name")
                    .font(.headline)
                    .foregroundColor(.green)
                Text("Sus mejores archivements")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

struct AthleteDetailView: View {
    @State private var selectedDistance: String = "5K"
    @State private var bestTime: String = "00:00:00"
    @State private var achievements: String = "Logros Destacados"
    @State private var sports: String = ""
    @State private var age: String = "25"
    @State private var gender: String = "Masculino"
    @State private var city: String = "Ciudad"
    let distances = ["5K", "10K", "Half Marathon", "Marathon"]
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ImagePlaceholderView(url: "https://source.unsplash.com/random/100x100")
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("Athlete Name")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Best Times and Achievements")
                        .font(.title2)
                        .padding(.top)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            
            Picker("Select Distance", selection: $selectedDistance) {
                ForEach(distances, id: \.self) { distance in
                    Text(distance)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Form {
                Section(header: Text("Best Time")) {
                    Text(bestTime)
                }
                Section(header: Text("Achievements")) {
                    Text(achievements)
                }
                Section(header: Text("Deportes")) {
                    Text(sports)
                }
                Section(header: Text("Información Personal")) {
                    Text("Edad: \(age)")
                    Text("Género: \(gender)")
                    Text("Ciudad: \(city)")
                }
            }
            .padding()
            
            Spacer()
            
            NavigationLink(destination: MessageView()) {
                Text("Enviar Mensaje")
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.green)
            }
            .padding()
        }
        .padding()
    }
}

struct ImagePlaceholderView: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            @unknown default:
                EmptyView()
            }
        }
    }
}

struct PostListView: View {
    var body: some View {
        VStack {
            List {
                ForEach(0..<10) { index in
                    Text("Post \(index + 1)")
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
            PostButtonView()
        }
        .navigationTitle("Posts")
    }
}

struct PostButtonView: View {
    @State private var isPresentingCreatePost = false
    
    var body: some View {
        Button(action: {
            isPresentingCreatePost = true
        }) {
            HStack {
                Image(systemName: "square.and.pencil")
                Text("Create Post")
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
            .foregroundColor(.green)
        }
        .padding()
        .sheet(isPresented: $isPresentingCreatePost) {
            CreatePostView()
        }
    }
}

struct CreatePostView: View {
    @State private var postText: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $postText)
                    .frame(height: 200)
                    .border(Color.gray, width: 1)
                    .padding()
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()
                }
                
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Text("Select Image")
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.green)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Create Post")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        sendPost()
                    }
                    .foregroundColor(.green)
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    private func sendPost() {
        // Logic to send the post to relevant users
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
    }
}

struct ProfileView: View {
    @State private var name: String = ""
    @State private var city: String = ""
    @State private var team: String = ""
    @State private var age: String = ""
    @State private var gender: String = "Masculino"
    @State private var profileImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var selectedDistance: String = "5K"
    @State private var bestTime: String = "00:00:00"
    @State private var achievements: String = "Logros Destacados"
    @State private var sports: String = ""
    let distances = ["5K", "10K", "Half Marathon", "Marathon"]
    let genders = ["Masculino", "Femenino", "Otro"]
    let ages = Array(1...150).map { "\($0)" }
    
    var body: some View {
        VStack {
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
            } else {
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                }
                .padding()
            }
            
            Form {
                Section(header: Text("Información Personal")) {
                    TextField("Nombre", text: $name)
                    TextField("Ciudad", text: $city)
                    TextField("Equipo", text: $team)
                    
                    Picker("Edad", selection: $age) {
                        ForEach(ages, id: \.self) { age in
                            Text(age)
                        }
                    }
                    
                    Picker("Género", selection: $gender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender)
                        }
                    }
                }
                Section(header: Text("Mejores Resultados")) {
                    Picker("Select Distance", selection: $selectedDistance) {
                        ForEach(distances, id: \.self) { distance in
                            Text(distance)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        TextField("Mejor Tiempo", text: $bestTime)
                        Button(action: {
                            // Logic to edit best time
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.green)
                        }
                    }
                    
                    TextField("Logros Destacados", text: $achievements)
                }
                Section(header: Text("Deporte")) {
                    TextField("Deportes", text: $sports)
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Perfil")
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $profileImage)
        }
    }
}

struct ChatListView: View {
    var body: some View {
        List {
            ForEach(0..<10) { index in
                NavigationLink(destination: ChatDetailView()) {
                    Text("Chat with Athlete \(index + 1)")
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
        }
        .navigationTitle("Chat")
    }
}

struct ChatDetailView: View {
    @State private var messageText: String = ""
    @State private var messages: [String] = []
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(messages, id: \.self) { message in
                        Text(message)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.vertical, 2)
                    }
                }
            }
            
            HStack {
                TextField("Escribe un mensaje", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
        }
        .navigationTitle("Chat")
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        messages.append(messageText)
        messageText = ""
    }
}

struct MessageView: View {
    @State private var messageText: String = ""
    
    var body: some View {
        VStack {
            TextField("Escribe un mensaje", text: $messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                // Logic to send message
            }) {
                Text("Enviar")
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.green)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Enviar Mensaje")
    }
}

struct LogoView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black)
                .frame(width: 200, height: 200)
            ForEach(0..<8) { index in
                Circle()
                    .stroke(Color.green, lineWidth: 10)
                    .frame(width: CGFloat(200 - index * 20), height: CGFloat(200 - index * 20))
            }
        }
    }
}