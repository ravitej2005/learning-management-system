import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class Qualificationandexperince extends StatefulWidget {
  final GlobalKey<FormBuilderState>? formKey;

  const Qualificationandexperince({super.key, this.formKey});

  @override
  State<Qualificationandexperince> createState() =>
      _QualificationandexperinceState();
}

class _QualificationandexperinceState extends State<Qualificationandexperince> {
  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  final List<String> qualifications = [
    'B.Sc. in Computer Science',
    'B.Tech in Computer Science/IT',
    'BCA (Bachelor of Computer Applications)',
    'M.Sc. in Computer Science',
    'MCA (Master of Computer Applications)',
    'M.Tech in Computer Science/IT',
    'Ph.D. in Computer Science/Engineering',
    'Diploma in Software Engineering',
    'Self-Taught with Verified Portfolio',
  ];

  final Map<String, List<String>> specializationMap = {
    'B.Sc. in Computer Science': [
      'Data Structures & Algorithms',
      'Python Development',
      'Web Development',
      'Object-Oriented Programming (OOP)',
    ],
    'B.Tech in Computer Science/IT': [
      'Full Stack Development',
      'Cloud Computing',
      'DevOps',
      'Cybersecurity',
      'System Design',
    ],
    'BCA (Bachelor of Computer Applications)': [
      'Mobile App Development (Flutter, Android)',
      'Frontend Technologies',
      'Java Programming',
      'SQL & Databases',
    ],
    'M.Sc. in Computer Science': [
      'Machine Learning',
      'AI & Deep Learning',
      'Data Science',
      'Big Data Analytics',
    ],
    'MCA (Master of Computer Applications)': [
      'Software Architecture',
      'Backend Development',
      'Database Management Systems',
      'Cloud Integration',
    ],
    'M.Tech in Computer Science/IT': [
      'Research & Advanced Algorithms',
      'AI & Robotics',
      'Blockchain Development',
      'Parallel Computing',
    ],
    'Ph.D. in Computer Science/Engineering': [
      'Advanced AI Research',
      'Natural Language Processing',
      'Quantum Computing (Beginner Level)',
      'Computational Theory',
    ],
    'Diploma in Software Engineering': [
      'Web Development',
      'Desktop App Development',
      'Game Development',
    ],
    'Self-Taught with Verified Portfolio': [
      'Freelance Full Stack',
      'Open Source Contribution',
      'Portfolio-Based Teaching',
    ],
  };

  final List<String> codingTeachingFields = [
    'Web Development (HTML, CSS, JS)',
    'Full Stack Development (MERN, MEAN)',
    'Mobile App Development (Flutter, React Native)',
    'Python Programming',
    'Java Programming',
    'C/C++ Programming',
    'Data Structures and Algorithms (DSA)',
    'Competitive Programming',
    'Machine Learning',
    'Artificial Intelligence',
    'Cybersecurity Basics',
    'Cloud Computing (AWS, Azure, GCP)',
    'Blockchain Basics',
    'Git & GitHub for Beginners',
    'SQL & NoSQL Databases',
    'DevOps Fundamentals',
    'APIs and RESTful Services',
    'Software Engineering Principles',
    'UI/UX for Developers',
    'Linux for Developers',
    'System Design',
  ];

  final List<String> certifications = [
    'Google Associate Android Developer',
    'AWS Certified Developer – Associate',
    'Microsoft Certified: Azure Developer Associate',
    'Oracle Certified Java Programmer',
    'Meta Front-End Developer Certificate',
    'IBM Data Science Professional Certificate',
    'FreeCodeCamp Certifications (Verified)',
    'Coursera Specialization (Completed)',
    'Udemy Instructor Verified Certification',
    'Coding Ninjas/Scaler Verified Program',
    'Codeforces/Leetcode Verified Contest History',
    'GitHub Open Source Contribution Badge',
  ];

  String? selectedQualification;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey!,
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text("Professional Details",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),

          // Highest Qualification
          FormBuilderDropdown<String>(
            name: 'qualification',
            decoration: _inputDecoration('Highest Qualification'),
            items: qualifications
                .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedQualification = val;
              });
            },
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: 16),

          // Specialization
          if (selectedQualification != null)
            FormBuilderDropdown<String>(
              name: 'specialization',
              decoration: _inputDecoration('Specialization'),
              items: specializationMap[selectedQualification]!
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              validator: FormBuilderValidators.required(),
            ),
          const SizedBox(height: 16),

          // Experience
          FormBuilderTextField(
            name: 'experience',
            decoration: _inputDecoration('Years of Teaching Experience'),
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.numeric(),
              FormBuilderValidators.min(0),
              FormBuilderValidators.max(60),
            ]),
          ),
          const SizedBox(height: 16),

          // Certifications Dropdown with "Other" option
          FormBuilderDropdown<String>(
            name: 'certification',
            decoration: _inputDecoration('Certifications'),
            items: const [
              DropdownMenuItem(value: 'UGC-NET', child: Text('UGC-NET')),
              DropdownMenuItem(value: 'B.Ed.', child: Text('B.Ed.')),
              DropdownMenuItem(value: 'M.Ed.', child: Text('M.Ed.')),
              DropdownMenuItem(value: 'Ph.D.', child: Text('Ph.D.')),
              DropdownMenuItem(value: 'GATE', child: Text('GATE')),
              DropdownMenuItem(value: 'CDAC', child: Text('CDAC')),
              DropdownMenuItem(
                  value: 'Coursera Verified Certificate',
                  child: Text('Coursera Verified')),
              DropdownMenuItem(
                  value: 'NPTEL Certification', child: Text('NPTEL')),
              DropdownMenuItem(
                  value: 'Google Certified Educator',
                  child: Text('Google Certified Educator')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            validator: FormBuilderValidators.required(),
            onChanged: (_) {
              setState(
                  () {}); // To rebuild and show/hide "Other" input dynamically
            },
          ),
          const SizedBox(height: 16),

          // Show this only if 'Other' is selected in certifications
          if (widget.formKey!.currentState?.fields['certification']?.value ==
              'Other')
            FormBuilderTextField(
              name: 'certification_other',
              decoration: _inputDecoration('Please specify your certification'),
              validator: FormBuilderValidators.required(),
            ),

          const SizedBox(height: 16),

          // Institutions Previously Worked At (Dropdown)
          FormBuilderDropdown<String>(
            name: 'institutions',
            decoration: _inputDecoration('Institutions Previously Worked At'),
            items: const [
              DropdownMenuItem(
                  value: 'Shivaji University',
                  child: Text('Shivaji University')),
              DropdownMenuItem(
                  value: 'Savitribai Phule Pune University',
                  child: Text('Savitribai Phule Pune University')),
              DropdownMenuItem(
                  value: 'University of Mumbai',
                  child: Text('University of Mumbai')),
              DropdownMenuItem(value: 'IIT Bombay', child: Text('IIT Bombay')),
              DropdownMenuItem(value: 'NIT Nagpur', child: Text('NIT Nagpur')),
              DropdownMenuItem(
                  value: 'VIT Vellore', child: Text('VIT Vellore')),
              DropdownMenuItem(
                  value: 'BITS Pilani', child: Text('BITS Pilani')),
              DropdownMenuItem(
                  value: 'MIT World Peace University',
                  child: Text('MIT WPU, Pune')),
              DropdownMenuItem(
                  value: 'COEP Technological University',
                  child: Text('COEP Technological University')),
              DropdownMenuItem(
                  value: 'Symbiosis Institute of Technology',
                  child: Text('Symbiosis Institute of Technology')),
              DropdownMenuItem(
                  value: 'Private Coaching Institute',
                  child: Text('Private Coaching Institute')),
              DropdownMenuItem(
                  value: 'EdTech Platform (e.g., Unacademy, PW)',
                  child: Text('EdTech Platform')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: 16),

          // Interested Teaching Fields
          FormBuilderFilterChip<String>(
            name: 'interestedFields',
            decoration: _inputDecoration('Interested Teaching Fields'),
            options: codingTeachingFields
                .map((c) => FormBuilderChipOption(value: c, child: Text(c)))
                .toList(),
            validator: FormBuilderValidators.minLength(1),
          ),
        ],
      ),
    );
  }
}
