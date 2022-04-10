import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_vote/Pages/Auth/Register.dart';
import 'package:secure_vote/Services/authServices.dart';
import 'package:secure_vote/Utils/constantStrings.dart';
import 'package:secure_vote/Utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController privateKeyController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassText = true;
  bool _obscurePrivateKey = true;

  bool isEmailLoading = false;
  bool isGoogleLoading = false;

  void _togglePassText() =>
      setState(() => _obscurePassText = !_obscurePassText);

  void _togglePrivateKeyText() =>
      setState(() => _obscurePrivateKey = !_obscurePrivateKey);

  startEmailLoading() => setState(() => isEmailLoading = true);
  stopEmailLoading() => setState(() => isEmailLoading = false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 5, 18, 5),
            child: Column(
              children: [
                const Spacer(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //TODO: Add app icon here
                        const Icon(Icons.person, size: 90),
                        const SizedBox(width: 10),
                        Text(
                          'Welcome To \nSecure Vote',
                          softWrap: true,
                          style: GoogleFonts.getFont("Lato",
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide:
                                  const BorderSide(color: Colors.blueGrey),
                            ),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Invalid email !';
                            }
                            if (value.isEmpty) {
                              return 'Email ID cannot be empty !';
                            }
                            if (!RegExp(EMAIL_REGEX).hasMatch(value)) {
                              return 'Invalid email !';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassText,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide:
                                  const BorderSide(color: Colors.blueGrey),
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _obscurePassText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  _togglePassText();
                                }),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Enter valid characters!";
                            }
                            if (value.isEmpty) {
                              return 'Password cannot be empty !';
                            } else if (value.length < 6) {
                              return 'Password must contain atleast 6 characters!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          controller: privateKeyController,
                          obscureText: _obscurePrivateKey,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Private Key",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide:
                                  const BorderSide(color: Colors.blueGrey),
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _obscurePrivateKey
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  _togglePrivateKeyText();
                                }),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Enter valid characters!";
                            }
                            if (value.isEmpty) {
                              return 'Private Key cannot be empty !';
                            } else if (value.length < 6) {
                              return 'Private Key must contain 64 Hex characters!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                isEmailLoading
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const CircularProgressIndicator())
                    : buildLoginWithEmailButton(context),
                    
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                  // ignore: prefer_const_literals_to_create_immutables
                  child: Row(children: <Widget>[
                    const Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    const Text(" OR "),
                    const Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 25),
                // isGoogleLoading
                //     ? Container(
                //         padding: const EdgeInsets.symmetric(vertical: 10),
                //         child: const CircularProgressIndicator())
                //     : buildLoginWithGoogleButton(context),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).textTheme.bodyText1!.color),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Sign up',
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 15,
                              fontFamily: "Times New Roman",
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()),
                                );
                              })
                      ]),
                ),
                const Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Builder buildLoginWithEmailButton(BuildContext context) {
    return Builder(
      builder: (BuildContext _) {
        return Container(
          padding: const EdgeInsets.all(4),
          child: MaterialButton(
              child: const Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xffd68598)),
              ),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              highlightElevation: 1.5,
              highlightColor: const Color(0xDAFFD1DC),
              color: const Color(0xffFFD1DC),
              textColor: Colors.black,
              onPressed: () async {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();

                  FocusScope.of(context).unfocus();
                  startEmailLoading();
                  await AuthServices.login(
                      email: email,
                      password: password,
                      successCallback: () async{
                        stopEmailLoading();
                        //TODO: Verify public/private keys

                        //TODO: Store private key in shared pref
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString(PRIVATEKEYSHAREDPREFNAME, privateKeyController.text.trim());
                        
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const Register(),
                        //   ),
                        // );
                      },
                      errorCallback: (error) {
                        print(error);
                        stopEmailLoading();
                      });
                }
              }),
        );
      },
    );
  }
}
