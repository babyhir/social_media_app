import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/posts_screen.dart';
import 'package:social_media_app/screens/sign_up_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {

  static const String routeName = "/sign_in_screen";


  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  String _email = "";
  String _password = "";

  late final FocusNode _passwordFocusNode;
  
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    FocusScope.of(context).unfocus();

    if(!_formKey.currentState!.validate()){
      // Invalid
      return;
    }

    _formKey.currentState!.save();

    context.read<AuthCubit>().signInWithEmail(
        email: _email, password: _password);
  }

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (prevState, currState) {

              if (currState is AuthError) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).errorColor,
                    content: Text(
                      currState.message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError
                      ),
                    ),
                duration: const Duration(seconds: 2),
                  ),
                );
              }

              if (currState is AuthSignIn) {

                if (!FirebaseAuth.instance.currentUser!.emailVerified){
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verify your email"),
                      ),
                  );
                }

                Navigator.of(context).pushReplacementNamed(PostsScreen.routeName);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading){
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(15),

                children: [
                  //email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      _email = value!.trim();
                    },
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                    decoration: const InputDecoration(

                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: "Enter email"
                    ) ,
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return "Please provide email";
                      }

                      if (value.length < 4) {
                        return "Please provide longer email";
                      }

                      return null;
                    },
                  ),

                  //password
                  TextFormField(
                    focusNode: _passwordFocusNode,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSaved: (value){
                      _password = value!.trim();
                    },
                    onFieldSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: "Enter password",
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please provide password ...";
                      }
                      if (value.length < 5){
                        return "Please provide longer password ...";
                      }
                    },
                  ),

                  const SizedBox(height: 8),


                  ElevatedButton(
                      onPressed: () => _submit(),
                      child: const Text("Log In")),

                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(SignUpScreen.routeName),
                    child: const Text("Sign Up Instead"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
