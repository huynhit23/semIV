import 'package:flutter/material.dart';
import '../../../constants.dart';

class MySearchBAR extends StatelessWidget {
  final Function(String) onSearch;

  const MySearchBAR({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kcontentColor,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.grey,
            size: 30,
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 4,
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by Tour or Nation....",
                border: InputBorder.none,
              ),
              onChanged: (value) => onSearch(value),
            ),
          ),
        ],
      ),
    );
  }
}
