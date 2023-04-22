import SwiftUI
import AuthenticationServices


struct ContentView: View {
    @State private var userName = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var IncorrectuserName : Float = 0
    @State private var IncorrectPassword: Float = 0
    @State private var showingLoginScreen = false
    var body: some View {
        NavigationView{
            ZStack{
                Image("Image")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)

                VStack{
                    Text("LOG IN")
                    
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    TextField("UserName", text: $userName)
                        .padding()
                        .frame(width: 300,height: 50)
                        .background(Color.pink.opacity(0.2))
                        .cornerRadius(30)
                        .border(.red,width: CGFloat(IncorrectuserName))
                    HStack {
                        if showPassword {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye" : "eye.slash")
                                .foregroundColor(Color.black)
                        }
                    }
                    .padding()
                    .frame(width: 300,height: 50)
                    .background(Color.pink.opacity(0.2))
                    .cornerRadius(30)
                    .border(.red,width: CGFloat(IncorrectPassword))
                    
                 


                    Button ("Sign in") {
                        authorisedUser(userName: userName, password:  password)
                        print ("\(userName) = \(password)")
                    }
                    
                    .foregroundColor(. white)
                    .frame(width: 300, height: 50) .background (Color.pink)
                    .cornerRadius(20)
                    

                    NavigationLink(destination: Text("🐸You are logged in @\(userName)🐸").bold().background(Color.pink.opacity(0.2)).cornerRadius(20).frame(width: 300,height: 100), isActive:
                                    $showingLoginScreen) {
                        EmptyView ()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    func authorisedUser(userName:String,password:String){
        if userName.uppercased() == "IP-22" {
            IncorrectuserName = 0;
            if password.lowercased() == "20221909"{
                IncorrectPassword = 0
                showingLoginScreen = true
            }else{
                IncorrectPassword = 2
            }
        }else{
                IncorrectuserName = 2
            }
        }
    }




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
