import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/chat_screen.dart';
import 'package:social_media_app/screens/create_post_screen.dart';
import 'package:social_media_app/screens/posts_screen.dart';
import 'package:social_media_app/screens/sign_in_screen.dart';
import 'package:social_media_app/screens/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';

// This is a Social Media App. By me, Zahir
// Sign up in Firebase

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SentryFlutter.init(
        (options) {
      options.dsn = 'https://97ee6173b4c64dce913fdc7544edbecf@o1200589.ingest.sentry.io/6324653';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  //Checks AuthState
  Widget _buildHomeScreen(){
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
        builder: (context,snapshot){
        if(snapshot.hasData){

          if(snapshot.data!.emailVerified){
            return const PostsScreen();
          }
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verify your email")));
          return const SignInScreen();
        }else{
          return const SignInScreen();
        }
        },
    );

  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: _buildHomeScreen(),
        routes: {
          SignUpScreen.routeName : (context) => const SignUpScreen(),
          SignInScreen.routeName : (context) => const SignInScreen(),
          PostsScreen.routeName : (context) => const PostsScreen(),
          CreatePostScreen.routeName: (context) => const CreatePostScreen(),
          ChatScreen.routeName: (context) => const ChatScreen(),

        },
      ),
    );
  }
}

