// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:secure_vote/Services/authServices.dart';
import 'package:secure_vote/Utils/constantStrings.dart';
import 'package:secure_vote/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController privateKeyController = TextEditingController();
  TextEditingController publicKeyController = TextEditingController();

  bool _obscurePassText = true;
  bool _obscureCnfPassText = true;
  bool _obscurePrivateKeyText = true;
  bool isEmailLoading = false;
  bool isGoogleLoading = false;

  startEmailLoading() => setState(() => isEmailLoading = true);
  stopEmailLoading() => setState(() => isEmailLoading = false);

  void _togglePassText() =>
      setState(() => _obscurePassText = !_obscurePassText);
  void _toggleCnfPassText() =>
      setState(() => _obscureCnfPassText = !_obscureCnfPassText);
  void _togglePrivateKeyText() =>
      setState(() => _obscurePrivateKeyText = !_obscurePrivateKeyText);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.book, size: 50),
                        SizedBox(width: 10),
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        controller: nameController,
                        decoration: textFormFieldDecoration(
                            "Name", Icons.person_outline),
                        autofocus: false,
                        style: const TextStyle(color: Colors.blueGrey),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name cannot be empty !';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: textFormFieldDecoration(
                            "Email", Icons.email_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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
                        decoration:
                            passwordFormFieldDecoration(context, "Password", 0),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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
                        controller: confirmPasswordController,
                        // keyboardType: TextInputType.number,
                        obscureText: _obscureCnfPassText,
                        decoration: passwordFormFieldDecoration(
                            context, "Confirm Password", 1),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty !';
                          } else if (value.length < 6) {
                            return 'Password must contain atleast 6 characters!';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match !';
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
                        obscureText: _obscurePrivateKeyText,
                        decoration: passwordFormFieldDecoration(
                            context, "Private Key", 2),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Private Key cannot be empty !';
                          } else if (value.length < 64) {
                            return 'Private Key must contain 64 Hex characters!';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        controller: publicKeyController,
                        decoration: textFormFieldDecoration(
                          "Public Key",
                          Icons.vpn_key_sharp,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Public Key cannot be empty !';
                          } else if (value.length < 6) {
                            return 'Public key must contain 128 characters!';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    isEmailLoading
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: const CircularProgressIndicator())
                        : buildRegisterWithEmailButton(context),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  InputDecoration passwordFormFieldDecoration(
      BuildContext context, String lbl, int? flag) {
    return InputDecoration(
      labelText: lbl,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.blueGrey)),
      suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _obscurePassText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            if (flag == null) return;
            if (flag == 0) {
              _togglePassText();
            } else if (flag == 1) {
              _toggleCnfPassText();
            } else if (flag == 2) {
              _togglePrivateKeyText();
            }
          }),
    );
  }

  InputDecoration textFormFieldDecoration(String lbl, IconData? icon) {
    return InputDecoration(
      labelText: lbl,
      suffixIcon: icon != null ? Icon(icon) : null,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.blueGrey),
      ),
    );
  }

  Container buildRegisterWithEmailButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: MaterialButton(
          child: const Text(
            "Register",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xffd68598),
            ),
          ),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          textColor: Colors.black,
          highlightElevation: 1.5,
          highlightColor: const Color(0xDAFFD1DC),
          color: const Color(0xffFFD1DC),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (passwordController.text == confirmPasswordController.text) {
                FocusScope.of(context).unfocus();
                startEmailLoading();
                await AuthServices.register(
                    name: nameController.text.trim(),
                    email: emailController.text.trim().toLowerCase(),
                    password: passwordController.text.trim(),
                    publicKey: publicKeyController.text.trim(),
                    successCallback: () async{
                      stopEmailLoading();
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString(PRIVATEKEYSHAREDPREFNAME, privateKeyController.text.trim());
                    },
                    errorCallback: (error) {
                      print("Error");
                      print(error);
                      stopEmailLoading();
                    });
                stopEmailLoading();
                // await registerWithEmail(cntxt);
              } else {
                // showSnackBar("Passwords don\'t match!");
              }
            }
          }),
    );
  }
}
