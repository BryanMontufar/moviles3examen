import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<dynamic> signUp({required String email, required String password}) async{
    try {

    UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return credential.user;


    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint("La contrasenia es muy debil");
      } else if (e.code == 'email-already-in-use') {
        debugPrint ("El correo ya existe");
    }
    return e.code;
  } catch(e) {
    debugPrint("Error al registrar: $e");
    return e.toString();
  }

}

Future<dynamic?> signIn({required String email, required String password}) async{
    try {

    UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint("Usuario no encontrado");
      } else if (e.code == 'wrog-password') {
        debugPrint ("Contrasenia incorrecta");
    }
  } catch(e) {
    debugPrint("Error al iniciar sesion: $e");
    return e.toString();
  }

}

  Future<void> signOut() async {
    await _auth.signOut();
  }
}