import 'package:flutter/material.dart';
import 'package:myapp/constants/colors.dart';
import 'package:country_code_picker/country_code_picker.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  String countryCode = "+91";

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
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to FstChat",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Enter your phone number to continue",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.length != 10)
                              return "Invalid phone number";
                            return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: CountryCodePicker(
                                onChanged: (value) {
                                  print(value.dialCode);
                                  countryCode = value.dialCode!;
                                },
                                initialSelection: "IN",
                              ),
                              labelText: "Enter your phone number",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text('Send OTP'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("OTP Verification"),
                                ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white),
                      ),
                    )
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
