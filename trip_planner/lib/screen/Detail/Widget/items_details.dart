import 'package:flutter/material.dart';

import '../../../model/Tours.dart';

class ItemsDetails extends StatelessWidget {
  final Tours tour;
  const ItemsDetails({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tour ${tour.nation} ${tour.time}: ${tour.tour_name}",
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${tour.tour_price} USD",
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 15,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      tour.nation,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 25),
                    const Icon(
                      Icons.watch_later_outlined,
                      color: Colors.grey,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      "${tour.time} Days",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 25),
                    Text(
                      "Vehicle: ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const Icon(
                      Icons.sailing,
                      color: Colors.grey,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    const Icon(
                      Icons.local_airport_sharp,
                      color: Colors.grey,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    const Icon(
                      Icons.car_repair,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
