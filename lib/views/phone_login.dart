import 'package:flutter/material.dart';
import 'package:myapp/constants/colors.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:myapp/controllers/appwrite_controllers.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String countryCode = "+84";

  void handleOtpSubmit(String userId, BuildContext context) {
    if (_formKey1.currentState!.validate()) {
      // Xử lý OTP ở đây
      loginWithOtp(otp: _otpController.text, userId: userId).then((value) {
        if (value) {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Failed")),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  "assets/chat.png",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome to FstChat",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                    const Text("Enter your phone number to continue"),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.length != 10) {
                            return "Invalid phone number";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: CountryCodePicker(
                            onChanged: (value) {
                              print(value.dialCode);
                              countryCode = value.dialCode!;
                            },
                            initialSelection: "VN",
                          ),
                          labelText: "Enter your phone number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            createPhoneSession(
                                    phone: countryCode +
                                        _phoneNumberController.text)
                                .then((value) {
                              if (value != "login_error") {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("OTP Verification"),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text("Enter the 6 digit OTP"),
                                        const SizedBox(height: 12),
                                        Form(
                                          key: _formKey1,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: _otpController,
                                            validator: (value) {
                                              if (value!.length != 6)
                                                return "Invalid OTP";
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText:
                                                  "Enter the OTP received",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          handleOtpSubmit(value, context);
                                        },
                                        child: const Text("Submit"),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Failed to send OTP")),
                                );
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text("Send OTP"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
