import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:learning_management_system/Screens/basicInfoForm.dart';
import 'package:learning_management_system/Screens/qualificationAndExperince.dart';
import 'package:learning_management_system/Screens/uploadDocument.dart';

class TeacherOnboardingScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const TeacherOnboardingScreen({this.userData, super.key});

  @override
  State<TeacherOnboardingScreen> createState() =>
      _TeacherOnboardingScreenState();
}

class _TeacherOnboardingScreenState extends State<TeacherOnboardingScreen> {
  int _currentStep = 0;

  final List<GlobalKey<FormBuilderState>> keyList = [
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>()
  ];

  @override
  Widget build(BuildContext context) {
    print("in build onboard page ${widget.userData}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher Onboarding"),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            if (keyList[_currentStep].currentState?.saveAndValidate() ??
                false) {
              final data = keyList[_currentStep].currentState!.value;
              debugPrint("✅ Form data: $data");
              setState(() {
                _currentStep += 1;
              });
            } else {
              debugPrint("❌ Form validation failed.");
            }
          } else {
            // Final submit action here
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text("Basic Information"),
            content: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                BasicInfoForm(
                  userData: widget.userData,
                  formKey: keyList[0],
                ),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text("Qualifications and Experience"),
            content: Column(
              children: [
                Qualificationandexperince(
                  formKey: keyList[1],
                )
              ],
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text("Upload Documents"),
            content: Column(
              children: [UploadDocumentsSection(formKey: keyList[2])],
            ),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text("Final Confirmation"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("By proceeding, you agree to all terms and conditions."),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Submit logic here
                  },
                  child: Text("Submit Application"),
                ),
              ],
            ),
            isActive: _currentStep >= 3,
            state: StepState.indexed,
          ),
        ],
      ),
    );
  }
}
