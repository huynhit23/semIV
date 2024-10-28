
import 'package:flutter/material.dart';

import '../../../model/Tours.dart';

class DetailAppBar extends StatelessWidget {
  final Tours tour;
  const DetailAppBar({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          const Spacer(),

        ],
      ),
    );
  }
}
