import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../model/Tours.dart';
import '../../../service/data.dart';
import '../../../service/tour_service.dart';

class EditTourFormScreen extends StatefulWidget {
  final int tourId;
  EditTourFormScreen(this.tourId);

  @override
  _EditTourFormScreenState createState() => _EditTourFormScreenState();
}

class _EditTourFormScreenState extends State<EditTourFormScreen> {
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
  String? _currentImagePath;

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
    Tours tour = await service.getById(widget.tourId);
    setState(() {
      _tourNameController.text = tour.tour_name;
      _timeController.text = tour.time.toString();
      _destinationController.text = tour.destination;
      _scheduleController.text = tour.schedule;
      _selectedNation = tour.nation;
      _tourPriceController.text = tour.tour_price.toString();
      _currentImagePath = tour.image;
    });
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
        _currentImagePath = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tour Page'),
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
                  decoration: InputDecoration(labelText: 'Tour name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Tour Name, cannot be left blank';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(labelText: 'Tour Time'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Tour Time, cannot be left blank';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _destinationController,
                  decoration: InputDecoration(labelText: 'Destination'),
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
                  decoration: InputDecoration(labelText: 'Schedule'),
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
                  decoration: InputDecoration(labelText: 'Tour Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Tour Price, cannot be left blank';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedNation,
                  decoration: InputDecoration(labelText: 'Nation'),
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
                ElevatedButton(
                  onPressed: getImage,
                  child: Text('Select tour photo'),
                ),
                _image != null
                    ? Image.file(_image!, height: 100)
                    : _currentImagePath != null
                        ? _buildTourImage(_currentImagePath!)
                        : Text('No photo selected'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String imagePath =
                            _image?.path ?? _currentImagePath ?? '';
                        Tours updatedTour = Tours(
                            widget.tourId,
                            _tourNameController.text,
                            imagePath,
                            int.parse(_timeController.text),
                            _destinationController.text,
                            _scheduleController.text,
                            _selectedNation!,
                            double.parse(_tourPriceController.text));

                        await service.update(updatedTour);

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Tour update successful!')));

                        Navigator.pop(context);
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

  Widget _buildTourImage(String imagePath) {
    if (imagePath.startsWith('/data/')) {
      return Image.file(
        File(imagePath),
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      );
    } else {
      return Image.asset(
        "assets/images/tours/$imagePath",
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }
}
