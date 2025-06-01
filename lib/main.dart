import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'screens/pet_list_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const HotelParaPetsApp());
}

const mockUsers = {'admin@hotel.com': '123'};

class HotelParaPetsApp extends StatelessWidget {
  const HotelParaPetsApp({super.key});

  Future<String?> _authUser(LoginData data) async {
    debugPrint(
      'Tentativa de Login - Email: ${data.name}, Senha: ${data.password}',
    );
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mockUsers.containsKey(data.name)) {
      return 'Usuário não encontrado.';
    }
    if (mockUsers[data.name] != data.password) {
      return 'Senha incorreta';
    }
    return null;
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint(
      'Tentativa de Cadastro - Email: ${data.name}, Senha: ${data.password}',
    );
    await Future.delayed(const Duration(milliseconds: 1000));
    return null;
  }

  Future<String?> _recoverPassword(String name) async {
    debugPrint('Tentativa de Recuperação de Senha - Email: $name');
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mockUsers.containsKey(name)) {
      return 'Usuário não encontrado para recuperação.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel para Pets',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(244, 255, 222, 173),
          foregroundColor: Colors.brown,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(232, 124, 63, 19),
          foregroundColor: Colors.white,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,

      // Localização para pt-BR, incluindo calendário e textos
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      locale: const Locale('pt', 'BR'),

      home: Builder(
        builder: (context) => FlutterLogin(
          title: 'Hotel Pets',
          logo: const AssetImage('assets/logo.png'),
          onLogin: _authUser,
          onSignup: _signupUser,
          onRecoverPassword: _recoverPassword,
          theme: LoginTheme(
            primaryColor: const Color.fromARGB(244, 255, 222, 173),
            accentColor: const Color.fromARGB(240, 139, 69, 19),
            errorColor: Colors.black,
            titleStyle: const TextStyle(
              color: Color.fromARGB(232, 124, 63, 19),
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
            buttonStyle: const TextStyle(fontSize: 15, color: Colors.white),
            buttonTheme: LoginButtonTheme(
              backgroundColor: Color.fromARGB(232, 124, 63, 19),
            ),
            cardTheme: const CardTheme(
              color: Color.fromARGB(255, 210, 180, 140),
              margin: EdgeInsets.only(top: 10),
              elevation: 10,
            ),
          ),
          messages: LoginMessages(
            userHint: 'Email',
            passwordHint: 'Senha',
            confirmPasswordHint: 'Confirmar Senha',
            loginButton: 'ENTRAR',
            signupButton: 'CRIAR CONTA',
            forgotPasswordButton: 'Esqueceu a senha?',
            recoverPasswordButton: 'RECUPERAR',
            recoverPasswordIntro: 'Redefina sua senha',
            goBackButton: 'VOLTAR',
            confirmPasswordError: 'As senhas não coincidem!',
            recoverPasswordDescription:
                'Informe seu email para receber o link de recuperação.',
            recoverPasswordSuccess: 'Link de recuperação enviado!',
          ),
          onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const PetListScreen()),
            );
          },
        ),
      ),
    );
  }
}
