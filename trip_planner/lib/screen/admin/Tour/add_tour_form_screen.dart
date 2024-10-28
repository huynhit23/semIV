import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../model/Tours.dart';
import '../../../service/data.dart';
import '../../../service/tour_service.dart';

class AddTourFormScreen extends StatefulWidget {
  @override
  _AddTourFormScreenState createState() => _AddTourFormScreenState();
}

class _AddTourFormScreenState extends State<AddTourFormScreen> {
  late TourService service;
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  TextEditingController _tourNameController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _scheduleController = TextEditingController();
  TextEditingController _tourPriceController = TextEditingController();

  // For image selection
  File? _image;
  final picker = ImagePicker();

  // For nation selection
  String? _selectedNation;
  final List<String> _nations = [
    "VietNam",
    "China",
    "Singapore",
    "Japan",
    "Korea"
  ];

  connectDatabase() async {
    service = TourService(await getDatabase());
  }

  @override
  void initState() {
    connectDatabase();
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New page Tour'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _tourNameController,
                  decoration:
                      InputDecoration(labelText: 'Enter Tour Name here'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Tour Name, cannot be left blank';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _timeController,
                  decoration:
                      InputDecoration(labelText: 'Enter Tour Time here'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Tour Time, cannot be left blank';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _destinationController,
                  decoration:
                      InputDecoration(labelText: 'Enter Destination here'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Destination, cannot be left blank';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: _scheduleController,
                  decoration: InputDecoration(labelText: 'Enter Schedule here'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Schedule, cannot be left blank';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _tourPriceController,
                  decoration:
                      InputDecoration(labelText: 'Enter Tour Price here'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Tour Price, cannot be left blank';
                    }
                    return null;
                  },
                ),
                // Nation selection
                DropdownButtonFormField<String>(
                  value: _selectedNation,
                  decoration: InputDecoration(labelText: 'Select Nation'),
                  items: _nations.map((String nation) {
                    return DropdownMenuItem<String>(
                      value: nation,
                      child: Text(nation),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedNation = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select Nation, cannot be left blank';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // Image selection
                ElevatedButton(
                  onPressed: getImage,
                  child: Text('Select Tour photo'),
                ),
                _image == null
                    ? Text('No photo selected')
                    : Image.file(_image!, height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && _image != null) {
                        // Create a new Tours object with a temporary ID
                        Tours newTour = Tours(
                            -1, // Temporary ID
                            _tourNameController.text,
                            _image!.path,
                            int.parse(_timeController.text),
                            _destinationController.text,
                            _scheduleController.text,
                            _selectedNation!,
                            double.parse(_tourPriceController.text));

                        // Insert the new tour and get the generated ID
                        int generatedId = await service.insert(newTour);

                        // Fetch the inserted tour to confirm
                        Tours insertedTour = await service.getById(generatedId);

                        // Show confirmation message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Add Tour successfully! ID: ${insertedTour.tour_id}')));

                        // Clear the form
                        _tourNameController.clear();
                        _timeController.clear();
                        _destinationController.clear();
                        _scheduleController.clear();
                        _tourPriceController.clear();
                        setState(() {
                          _image = null;
                          _selectedNation = null;
                        });
                      } else if (_image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Please select tour photo, cannot be left blank')));
                      }
                    },
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
