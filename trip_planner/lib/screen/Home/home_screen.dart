import 'package:flutter/material.dart';
import '../../model/Tours.dart';
import '../../model/Users.dart';
import '../../model/category.dart';
import '../../service/data.dart';
import '../../service/tour_service.dart';
import 'Widget/image_slider.dart';
import 'Widget/product_cart.dart';
import 'Widget/search_bar.dart';

class HomeScreen extends StatefulWidget {
  final Users user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlider = 0;
  int selectedIndex = 0;
  List<Tours> toursList = [];
  late TourService tourService;
  String searchQuery = '';

  // List of nations to query from
  final List<Category> nations = [
    Category(
      title: "All",
      image: "assets/images/all.png",
    ),
    Category(
      title: "VietNam",
      image: "assets/images/vn.png",
    ),
    Category(
      title: "China",
      image: "assets/images/china.png",
    ),
    Category(
      title: "Singapore",
      image: "assets/images/sing.png",
    ),
    Category(
      title: "Japan",
      image: "assets/images/japan.jpg",
    ),
    Category(
      title: "Korea",
      image: "assets/images/korea.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeTourService();
    _fetchTours(nations[selectedIndex].title);
  }

  Future<void> _initializeTourService() async {
    final database = await getDatabase();
    tourService = TourService(database);
    _fetchTours(nations[selectedIndex].title);
  }

  Future<void> _fetchTours(String nation) async {
    List<Tours> tours;
    if (nation == "All") {
      tours = await tourService.search(searchQuery);
    } else {
      tours = await tourService.search_by_nation(nation);
    }
    setState(() {
      toursList = tours;
    });
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
      selectedIndex = 0; // Reset to "All" category
    });
    _fetchTours("All");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // for search bar
              MySearchBAR(onSearch: _onSearch),
              const SizedBox(height: 20),
              ImageSlider(
                currentSlide: currentSlider,
                onChange: (value) {
                  setState(() {
                    currentSlider = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              // for category selection
              categoryItems(),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Special For You",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Display tours
              toursList.isEmpty
                  ? const Center(
                      child: Text("There were no matching results",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          )))
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: toursList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ProductCard(
                              tour: toursList[index], user: widget.user),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox categoryItems() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: nations.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                _fetchTours(
                    nations[index].title); // Fetch tours for selected nation
              });
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: selectedIndex == index
                    ? Colors.blue[200]
                    : Colors.transparent,
              ),
              child: Column(
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(nations[index].image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    nations[index].title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
