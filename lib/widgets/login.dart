import 'package:flutter/material.dart';
import '../services/auth_service.dart';
 
class Login extends StatefulWidget {
  const Login({super.key});
 
  @override
  State<StatefulWidget> createState() => _LoginState();
}
 
class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Autenticación"),
              bottom: const TabBar(tabs: [
                Tab(
                  icon: Icon(Icons.account_circle),
                  text: "Iniciar sesión",
                ),
                Tab(
                  icon: Icon(Icons.chevron_right),
                  text: "Registrarse",
                ),
              ]),
            ),
            body: const TabBarView(children: [
              SignInForm(),
              SignUpForm(),
            ]),
          )),
    );
  }
}
 
class SignUpForm extends StatefulWidget{
  const SignUpForm({super.key});
 
  @override
  State<StatefulWidget> createState() => _SignUpFormState();
 
}
 
class _SignUpFormState extends State<SignUpForm>{
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String? errorMessage;
  bool isLoading = false;

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if(form != null && form.validate()){
      form.save();
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final result = await AuthService().signUp(email: email, password: password);
        setState(() {
          errorMessage = result.runtimeType == String ? result: null;
          isLoading = false;
        });
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: isLoading ? const Center (child: CircularProgressIndicator()) : Form(
        key: _formKey,
        child: Column(
          children: [
            if(errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red),),
            TextFormField(
              decoration: const InputDecoration(labelText: "Correo"),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Por favor ingrese su correo";    
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Contraseña"),
              obscureText: true,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Por favor ingrese su contraseña";    
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),  
            TextFormField(
              decoration: const InputDecoration(labelText: "Confirme su contraseña"),
              obscureText: true,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Por favor confirme su contraseña";    
                }
                if(value != password){
                  return "Las contraseñas no coinciden";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  confirmPassword = value;
                    errorMessage = value != password ? "Las contrasenias no coiciden": null;
                  
                });
              },
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("Registrarme"),
            ),                      
          ],
        )
      ),
    );
  }
 
}

class SignInForm extends StatefulWidget{
  const SignInForm({super.key});
 
  @override
  State<StatefulWidget> createState() => _SignInFormState();
 
}
 
class _SignInFormState extends State<SignInForm>{
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String? errorMessage;
  bool isLoading = false;

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if(form != null && form.validate()){
      form.save();
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final result = await AuthService().signIn(email: email, password: password);
        setState(() {
          errorMessage = result.runtimeType == String ? result: null;
          isLoading = false;
        });
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: isLoading ? const Center (child: CircularProgressIndicator()) : Form(
        key: _formKey,
        child: Column(
          children: [
            if(errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red),),
            TextFormField(
              decoration: const InputDecoration(labelText: "Correo"),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Por favor ingrese su correo";    
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Contraseña"),
              obscureText: true,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Por favor ingrese su contraseña";    
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),  
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("Iniciar Sesion"),
            ),                      
          ],
        )
      ),
    );
  }
 
}