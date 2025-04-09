import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:file_picker/file_picker.dart';

class UploadDocumentsSection extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const UploadDocumentsSection({super.key, required this.formKey});

  @override
  State<UploadDocumentsSection> createState() => _UploadDocumentsSectionState();
}

class _UploadDocumentsSectionState extends State<UploadDocumentsSection> {
  String? selectedQualification;

  final Map<String, String?> _uploadedFiles = {
    'profilePic': null,
    'govId': null,
    '10th': null,
    '12th': null,
    'graduation': null,
    'postGraduation': null,
  };

  Future<void> _pickFile(String labelKey) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _uploadedFiles[labelKey] = result.files.single.name;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('${result.files.single.name} selected for $labelKey')),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _fileUploadTile(String key, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => _pickFile(key),
          child: Text('Upload $label'),
        ),
        if (_uploadedFiles[key] != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('Selected: ${_uploadedFiles[key]}',
                style:
                    const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
          ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Upload Documents",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

          // Profile Picture
          _fileUploadTile('profilePic', 'Profile Picture'),

          // Gov ID Type
          FormBuilderDropdown<String>(
            name: 'govIdType',
            decoration: _inputDecoration("Government ID Proof Type"),
            items: const [
              DropdownMenuItem(value: 'Aadhar', child: Text('Aadhar Card')),
              DropdownMenuItem(value: 'PAN', child: Text('PAN Card')),
              DropdownMenuItem(value: 'Voter ID', child: Text('Voter ID')),
              DropdownMenuItem(value: 'Passport', child: Text('Passport')),
              DropdownMenuItem(
                  value: 'Driving License', child: Text('Driving License')),
            ],
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: 12),

          _fileUploadTile('govId', 'Government ID Proof'),

          const SizedBox(height: 16),

          // Qualification
          FormBuilderDropdown<String>(
            name: 'qualificationForDoc',
            decoration: _inputDecoration("Highest Qualification"),
            items: const [
              DropdownMenuItem(value: '10th', child: Text('10th')),
              DropdownMenuItem(value: '12th', child: Text('12th')),
              DropdownMenuItem(value: 'Diploma', child: Text('Diploma')),
              DropdownMenuItem(value: 'Graduation', child: Text('Graduation')),
              DropdownMenuItem(
                  value: 'Post-Graduation', child: Text('Post-Graduation')),
              DropdownMenuItem(value: 'PhD', child: Text('PhD')),
            ],
            onChanged: (val) {
              setState(() {
                selectedQualification = val;
              });
            },
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: 20),

          // Conditional Academic Uploads
          if (selectedQualification != null)
            _fileUploadTile('10th', '10th Marksheet'),

          if (selectedQualification == '12th' ||
              selectedQualification == 'Diploma' ||
              selectedQualification == 'Graduation' ||
              selectedQualification == 'Post-Graduation' ||
              selectedQualification == 'PhD')
            _fileUploadTile('12th', '12th Marksheet'),

          if (selectedQualification == 'Graduation' ||
              selectedQualification == 'Post-Graduation' ||
              selectedQualification == 'PhD')
            _fileUploadTile('graduation', 'Graduation Certificate'),

          if (selectedQualification == 'Post-Graduation' ||
              selectedQualification == 'PhD')
            _fileUploadTile('postGraduation', 'Post-Graduation Certificate'),
        ],
      ),
    );
  }
}
