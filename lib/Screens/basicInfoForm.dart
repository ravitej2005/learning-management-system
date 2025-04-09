import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:learning_management_system/Widgets/Button_Widget.dart';
import 'package:learning_management_system/Widgets/snackbar.dart';

class BasicInfoForm extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final GlobalKey<FormBuilderState>? formKey;
  const BasicInfoForm({super.key, this.userData, this.formKey});

  @override
  State<BasicInfoForm> createState() => _BasicInfoFormState();
}

class _BasicInfoFormState extends State<BasicInfoForm> {
  String? _verificationId;
  bool isPhoneVerified = false;
  bool isVerifying = false;
  bool isAutoFilledCity = false;
  bool isAutoFilledState = false;
  bool isAutoFilledCountry = false;

  Future<void> _sendOTP(String phoneNumber, BuildContext context) async {
    setState(() => isVerifying = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await FirebaseAuth.instance.currentUser!
              .linkWithCredential(credential);
          setState(() => isPhoneVerified = true);
          displaySnackBar(
              context, "Phone number auto-verified ", Icons.verified);
        } catch (e) {
          debugPrint("Auto-verification failed: $e");
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("Verification failed: ${e.message}");
        displaySnackBar(
            context, "Verification failed: ${e.message}", Icons.warning);
        setState(() => isVerifying = false);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          isVerifying = false;
        });
        displaySnackBar(context, "OTP has been sent to your phone.",
            Icons.messenger_outline_sharp);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _fetchCityState(String pincode) async {
    try {
      final url = 'https://api.postalpincode.in/pincode/$pincode';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data[0]['Status'] == 'Success') {
        final postOffice = data[0]['PostOffice'][0];
        widget.formKey!.currentState?.fields['city']
            ?.didChange(postOffice['District']);
        widget.formKey!.currentState?.fields['state']
            ?.didChange(postOffice['State']);
        widget.formKey!.currentState?.fields['country']
            ?.didChange(postOffice['Country']);

        setState(() {
          isAutoFilledCity = true;
          isAutoFilledState = true;
          isAutoFilledCountry = true;
        });
      }
    } catch (e) {
      debugPrint("Failed to fetch city/state: $e");
    }
  }

  void _verifyNumber(BuildContext context) async {
    final smsCode = widget.formKey!.currentState?.fields['otp']?.value;
    if (smsCode != null && smsCode.length == 6) {
      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: smsCode,
        );
        await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
        setState(() => isPhoneVerified = true);
        displaySnackBar(
            context, "Phone number verified and linked", Icons.verified);
      } catch (e) {
        displaySnackBar(
            context, "OTP verification failed: ${e.toString()}", Icons.error);
      }
    }
  }

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey!,
      child: Column(
        children: [
          // Name and Email (readonly)
          FormBuilderTextField(
            name: 'fullName',
            initialValue: widget.userData?['fullname'] ?? '',
            decoration: _inputDecoration('Full Name'),
            readOnly: true,
            enabled: false,
          ),
          const SizedBox(height: 16),

          FormBuilderTextField(
            name: 'email',
            initialValue: widget.userData?['email'] ?? '',
            decoration: _inputDecoration('Email Address'),
            readOnly: true,
            enabled: false,
          ),
          const SizedBox(height: 16),

          // DOB
          FormBuilderDateTimePicker(
            name: 'dob',
            format: DateFormat('yyyy-MM-dd'),
            inputType: InputType.date,
            decoration: _inputDecoration("Date of Birth",
                suffixIcon: const Icon(Icons.calendar_today)),
            firstDate: DateTime(1900),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              (value) {
                if (value == null) return null;
                final today = DateTime.now();
                final age = today.year -
                    value.year -
                    (today.month < value.month ||
                            (today.month == value.month &&
                                today.day < value.day)
                        ? 1
                        : 0);
                return age < 18 ? 'You must be at least 18 years old' : null;
              },
            ]),
          ),
          const SizedBox(height: 16),

          // Gender
          FormBuilderDropdown(
            name: 'gender',
            decoration: _inputDecoration('Gender'),
            items: ['Male', 'Female', 'Other']
                .map((gender) =>
                    DropdownMenuItem(value: gender, child: Text(gender)))
                .toList(),
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: 16),

          // Phone Field
          FormBuilderField<String>(
            enabled: !isPhoneVerified,
            name: 'phone',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              (value) {
                if (!isPhoneVerified) {
                  return 'Please verify your phone number';
                }
                return null;
              },
            ]),
            builder: (FormFieldState<String?> field) {
              return IntlPhoneField(
                initialCountryCode: 'IN',
                decoration: _inputDecoration('Phone Number').copyWith(
                  errorText: field.errorText,
                  suffixIcon: isPhoneVerified
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : SizedBox(
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ButtonWidget(
                              bgcolor: Colors.black,
                              textcolor: Colors.white,
                              onPressed: isVerifying
                                  ? null
                                  : () {
                                      final phone = field.value;
                                      if (phone != null && phone.isNotEmpty) {
                                        _sendOTP(phone, context);
                                      }
                                    },
                              text: "Send OTP",
                              fontSize: 15,
                            ),
                          ),
                        ),
                ),
                onChanged: (phone) {
                  field.didChange(phone.completeNumber);
                  setState(() => isPhoneVerified = false);
                },
              );
            },
          ),
          const SizedBox(height: 5),

          // OTP input if verificationId exists and not yet verified
          if (!isPhoneVerified && _verificationId != null)
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      keyboardType: TextInputType.number,
                      name: 'otp',
                      decoration: _inputDecoration('Enter OTP'),
                      // validator: FormBuilderValidators.required(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: ButtonWidget(
                        bgcolor: Colors.transparent,
                        textcolor: Colors.black,
                        onPressed: () => _verifyNumber(context),
                        text: "Verify",
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: ButtonWidget(
                        bgcolor: Colors.black,
                        textcolor: Colors.white,
                        onPressed: () {
                          final number = widget
                              .formKey!.currentState?.fields['phone']?.value;
                          _sendOTP(number, context);
                        },
                        text: "Resend OTP",
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // Address
          FormBuilderTextField(
            name: 'address',
            decoration: _inputDecoration('Address'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(10),
            ]),
          ),
          const SizedBox(height: 16),

          FormBuilderTextField(
            name: 'pincode',
            decoration: _inputDecoration('Pincode'),
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.numeric(),
              FormBuilderValidators.equalLength(6),
            ]),
            onChanged: (value) {
              if (value != null && value.length == 6) {
                _fetchCityState(value);
              } else {
                setState(() {
                  isAutoFilledCity = false;
                  isAutoFilledState = false;
                  isAutoFilledCountry = false;
                });
              }
            },
          ),
          const SizedBox(height: 16),

          FormBuilderTextField(
            name: 'city',
            enabled: isAutoFilledCity,
            readOnly: true,
            decoration: _inputDecoration('City'),
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: 16),

          FormBuilderTextField(
            name: 'state',
            enabled: isAutoFilledState,
            readOnly: true,
            decoration: _inputDecoration('State'),
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: 16),

          FormBuilderTextField(
            name: 'country',
            enabled: isAutoFilledCountry,
            readOnly: true,
            decoration: _inputDecoration('Country'),
            validator: FormBuilderValidators.required(),
          ),
        ],
      ),
    );
  }
}
