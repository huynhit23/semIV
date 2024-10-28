import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Database setup for the Tours and Trips models
Future<Database> getDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'trip_planner.db'),
    onCreate: (db, version) async {
//
      await db.execute('CREATE TABLE IF NOT EXISTS tours ('
          'tour_id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'tour_name TEXT NOT NULL, '
          'image TEXT, '
          'time INTEGER, '
          'destination TEXT, '
          'schedule TEXT, '
          'nation TEXT, '
          'tour_price REAL NOT NULL '
          ')');
//
      await db.execute('CREATE TABLE IF NOT EXISTS users ('
          'user_id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'avatar TEXT, '
          'user_name TEXT UNIQUE NOT NULL, '
          'email TEXT UNIQUE NOT NULL, '
          'password_hash TEXT NOT NULL, '
          'full_name TEXT, '
          'role TEXT DEFAULT "user", '
          'status TEXT DEFAULT "validity" '
          ')');
//
      await db.execute('CREATE TABLE IF NOT EXISTS comments ('
          'comment_id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'content TEXT,'
          'tour_id INTEGER,'
          'user_id INTEGER,'
          'FOREIGN KEY(tour_id) REFERENCES tours(tour_id) ON DELETE CASCADE,'
          'FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE '
          ')');
//
      await db.execute('CREATE TABLE IF NOT EXISTS trips ('
          'trip_id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'trip_name TEXT,'
          'start_date TEXT,'
          'end_date TEXT,'
          'destination TEXT,'
          'total_price REAL,'
          'status TEXT DEFAULT "Waiting for confirmation",'
          'tour_id INTEGER,'
          'user_id INTEGER,'
          'FOREIGN KEY(tour_id) REFERENCES tours(tour_id) ON DELETE CASCADE,'
          'FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE '
          ')');
//
      await db.execute('CREATE TABLE IF NOT EXISTS expenses ('
          'expense_id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'trip_id INTEGER NOT NULL, '
          'user_id INTEGER NOT NULL, '
          'amount INTEGER NOT NULL, '
          'expense_date TEXT NOT NULL, '
          'notes TEXT, '
          'FOREIGN KEY(trip_id) REFERENCES trips(trip_id) ON DELETE CASCADE, '
          'FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE '
          ')');
//
      await db.execute('CREATE TABLE IF NOT EXISTS favorites ('
          'tour_id INTEGER, '
          'user_id INTEGER NOT NULL, '
          'FOREIGN KEY(tour_id) REFERENCES tours(tour_id) ON DELETE CASCADE,'
          'FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE '
          ')');
//
      await db.insert('users', {
        'user_id': 1,
        'user_name': 'admin',
        'avatar': 'admin.jpg',
        'email': 'manhk5528@gmail.com',
        'password_hash': '123456',
        'full_name': 'Quản trị viên',
        'role': 'admin',
        'status': 'validity',
      });
      await db.insert('users', {
        'user_id': 2,
        'user_name': 'user1',
        'avatar': 'user1.jpg',
        'email': 'user1@gmail.com',
        'password_hash': '123456',
        'full_name': 'Người dùng 1',
        'role': 'user',
        'status': 'validity',
      });
      await db.insert('users', {
        'user_id': 3,
        'user_name': 'user2',
        'avatar': 'user2.jpg',
        'email': 'user2@gmail.com',
        'password_hash': '123456',
        'full_name': 'Người dùng 2',
        'role': 'user',
        'status': 'locked',
      });
// insert tours
      await db.insert('tours', {
        'tour_id': 6,
        'tour_name': 'Shanghai - Suzhou - Wuzhen - Hangzhou',
        'image': 'china2.jpg',
        'time': 4,
        'destination':
        'Discover the poetic beauty and rich history of the Jiangnan region with a 4-day, 3-night tour through the famous cities of Shanghai, Suzhou, Hangzhou and the ancient town of Wuzhen. Enjoy the perfect combination of modern and ancient beauty of Shanghai, stroll along the cobblestone streets and explore traditional gardens in Suzhou, admire the poetic beauty of West Lake in Hangzhou and experience the peaceful, ancient space of Wuzhen. Explore with iVIVU today!',
        'schedule': 'DAY 1: HO CHI MINH CITY - SHANGHAI (Light dinner on the plane) \n'
            '16:45: Gather at Tan Son Nhat Airport, flight VJ3900 SGN - PVG 19:45 - 00:55  to Shanghai. \n'
            'You will have a light dinner on the plane. Upon arrival in Shanghai, the car will take you to the hotel to rest.\n '
            'DAY 2: SHANGHAI - SUZHOU (Breakfast, lunch, dinner) \n'
            'Check out and enjoy buffet breakfast at the hotel. Start the exciting and fascinating journey of Giang Nam Hanh . \n'
            'Suzhou Silk Store - Learn about the ancient Mulberry Cultivation and Sericulture Process that dates back over 3000 years. \n'
            'The group has lunch at a local restaurant. The group moves to Suzhou, visiting: \n'
            'Han Son Tu - An ancient temple located in the west of Phong Kieu town.Ao Yuan or  Ngau Yuan  - Built during the reign of Emperor Qianlong of the Qing Dynasty in Suzhou City. This place was recognized as a world heritage site in 2000 and is also a national tourist destination of China. (Cost of boat ride is self-sufficient) \n'
            'Dinner at local restaurant. Check in hotel and rest. \n'
            'The group is free to explore the Qili Shantang Canal Scenery  (Shantang Street) - a pedestrian street with a history of nearly 1,200 years in Suzhou. \n'
            'DAY 3: SUZHOU - WUZHEN - HANGZHOU (BREAKFAST, LUNCH, DINNER) \n'
            'Check out and have buffet breakfast at the hotel. The group moves to Wuzhen - One of the Four Great Ancient Towns. Visit: \n'
            'Cao Lau O Quan Ancient Town : In the style of Tieu Kieu - Luu Thuy - Nhan Gia. \n'
            'East - South - West - North Book : Structure of a Wu Town. Each place has its own characteristics and functions. \n'
            'Thach Kieu : Consists of a system of dozens of stone bridges linked together into a maze.The group has lunch at a local restaurant. Move to Hangzhou. The group visits one of the Four Great Lakes - West Lake . \n'
            'Doan Tam Kieu - Truong Kieu -  Stroll along the two largest and most famous bridges here. Experience the Four Great Folk Legends through the love stories of Luong - Chuc, Hua Tien - Bach Nuong at the place where love is proven. \n'
            'West Lake Boat Ride - Drifting on the waves of West Lake like the great poets: Bai Juyi - Su Dongpo once did. \n'
            'See the Three Altar and Moon - an ancient stone structure used to measure the ebb and flow of the tides here and the tallest and oldest Leifeng Pagoda in Hangzhou.To De Walking Street - A road with cool, lush willow trees for visitors who love to enjoy the scenery along the lake. \n'
            'Visit Long Tinh Tea Garden - One of the four famous royal teas in the world, known as the Four Great Teas. \n'
            'The group has dinner at a local restaurant. Check in at the hotel. Overnight in Hangzhou. \n'
            'Free to visit Hangzhou Old Town , or enjoy the show Songcheng Ancient Love  (at your own expense) \n'
            'DAY 4: HANGZHOU - SHANGHAI - HO CHI MINH CITY (Breakfast, lunch, dinner) \n'
            'Check out and have buffet breakfast at the hotel. The group car will transfer to Shanghai to visit: \n'
            'Trung Nguyen Legend Shanghai Coffee World - Enjoy Coffee (at your own expense)The group had lunch at a local restaurant. \n'
            'Thanh Hoang Temple Walking Street - Visit and shop at the brown wooden houses, black tiles, white walls with curved roofs carved with elaborate dragons and phoenixes. \n'
            'Shanghai Jadeite - Learn about precious jade and own beautiful pieces of jade for your jewelry. \n'
            'Shanghai Bund - Famous for many TV dramas.The group had dinner at a local restaurant. \n'
            'Car and guide pick up the group to the airport, check in for flight VJ3901 PVG - SGN 01:55 - 05:40  to Ho Chi Minh City.',
        'nation': 'China',
        'tour_price': 1056.0, // Updated to use double
      });
      await db.insert('tours', {
        'tour_id': 7,
        'tour_name': 'HCM - Seoul - Everland Park - Nami Island in Autumn',
        'image': 'hanquoc2.jpg',
        'time': 5,
        'destination':
        'Discover Korea starting from Seoul with a visit to Nami Island, famous for the movie "Winter Sonata", and continuing to Gwanghwamun Square and the poetic Cheonggyecheon Stream. Visitors will experience an exciting day at Everland Park, one of the largest amusement parks in Asia. Continue with a visit to Namsan Tower, Gyeongbok Palace, and the Blue House, which preserves many cultural and historical values ​​of Korea. In particular, you will participate in a Kimchi making class, wear traditional Hanbok costumes, and enjoy the unique art performance Paintner Show. The journey ends with a visit to the traditional craft village of Bukchon Hanok and shopping in Seoul before returning to Vietnam.',
        'schedule': 'Day 01: HCMC - SEOUL (Overnight on plane) \n'
            '19:00: You will arrive at Tan Son Nhat airport, international departure terminal. The tour leader will guide you through the check-in procedures for flight VJ864 SGN-ICN 22:40 - 05:45 to Korea (overnight on the plane). \n'
            'DAY 2: NAMI ISLAND - SQUARE - Cheonggyecheon STREAM (Breakfast, Lunch, Dinner) \n'
            'In the morning, the group arrives at Incheon airport. The car and tour guide pick up the group for breakfast and then begin the tour of the beautiful country of Korea, "Land of Kim Chi". \n'
            'Nami Island - The island has a peaceful beauty thanks to its charming natural scenery. This is the place chosen as the filming location for the famous TV series "Winter Sonata".Gwanghwamun Square is the largest and most beautiful square in the capital, the pride of Seoul people.Cheonggyecheon Stream flows through the center of Seoul city with a length of about 5.8 km, the rows of green trees along the length of the stream will bring a cool, peaceful feeling to you.The group had dinner at the restaurant, returned to the hotel to check in, rest and freely explore Seoul at night. \n'
            'DAY 3: SEOUL - EVERLAND Park (Breakfast, Lunch, Dinner) \n'
            'The group has breakfast at the hotel, the car takes the group to visit and shop at domestic cosmetics stores and the Government Ginseng Center . \n'
            'The group had lunch at a local restaurant: \n'
            'Everland Park - One of the largest amusement parks in Asia and offers a variety of entertainment for all ages. You will have memorable experiences at the park, especially the very popular Panda family .The group had dinner at a local restaurant and was free to explore Seoul at night. \n'
            'DAY 04: CITY SEOUL (Breakfast, lunch, dinner) \n'
            'The group has breakfast at the hotel, then moves to visit and shop: \n'
            'Red pine essential oil shop - Red pine essential oil helps rejuvenate aging cells, making visitors always feel healthy and full of energy. \n'
            'Korean domestic agricultural products store . \n'
            'The group had lunch at a local restaurant. \n'
            'Namsan TV Tower - The 239m high tower, built in 1975, is one of the famous places in Korea. The way up the tower allows visitors to admire the brilliant scenery of Seoul and visit the Love Lock Corridor, a romantic symbol here (not including going up the tower).Gyeongbok Palace (Gyeongbokgung) - Royal palace located in the north of Seoul, built in 1395 under the reign of King Taejo of the Joseon Dynasty.National Folk Museum of Korea - Preserves and exhibits Korean folk cultural artifacts. \n'
            'The Blue House - Workplace of the Korean presidents (take photos outside). \n'
            'You can shop at duty free stores with high-end brands from around the world. \n'
            'The group had dinner at a local restaurant. \n'
            'Free tickets to Paintner Show - Fun and humorous art performance by talented and handsome guys in Korean style.The group is free to explore and shop at Seoul is busiest night market, then return to the hotel to rest. \n'
            'DAY 5: SEOUL - NAMSAN TOWER - BUKCHON HANOK - HO CHI MINH CITY (Breakfast, Lunch, Dinner) \n'
            'The group has breakfast at the hotel and checks out. \n'
            'Bukchon Hanok Village - A traditional craft village that has been preserved intact in a 600-year-old urban area, including many alleys, hanok houses, and ancient temple roofs.Join a Kimchi making class and wear traditional Korean Hanbok. \n'
            'The group had lunch at a local restaurant. \n'
            'The group moved to the airport, stopped to shop at the department store and packed free luggage for bulky packages. \n'
            'The car will take you to the airport to catch flight  VJ861 20:55 - 00:10 back to Vietnam. Upon arrival at Tan Son Nhat airport, the group will complete immigration procedures.Say goodbye to you and end of tour.',
        'nation': 'Korea',
        'tour_price': 1136.35, // Updated to use double
      });
      await db.insert('tours', {
        'tour_id': 8,
        'tour_name': 'Korea Tour 5N5D: Busan - Daegu - Seoul',
        'image': 'hanquoc3.jpg',
        'time': 5,
        'destination':
        'Explore the 5-day, 4-night tour program in Korea that takes you to the highlights of Busan, Daegu, Seoul, and Nami Island. Explore theme parks, cultural villages, royal palaces, and beautiful natural landscapes. Visitors will have the opportunity to experience Korean culture through activities such as making kimchi, wearing traditional Hanbok, and enjoying rich local cuisine. The program also includes shopping experiences and enjoying the vibrant nightlife.',
        'schedule': 'Day 01: HO CHI MINH CITY - BUSAN (OVERNIGHT ON PLANE) \n'
            'You gather at Tan Son Nhat airport, international departure terminal, the tour leader will do the airline procedures for you to board the flight to Korea. \n'
            'DAY 1: BUSAN - GAYA THEME PARK (Light BREAKFAST, LUNCH, DINNER) \n'
            'Upon arrival at Gimhae International Airport, the tour guide will welcome the group to the port city of Busan. To recharge after the night flight, the group will have breakfast with fast food. Visit: \n'
            'Wine Tunnel - The road is nearly 1km long, including 3D paintings, miniature landscapes combined with light for visitors to take pictures. Here, visitors can also experience cycling on the railway tracks to enjoy the Nakdong River flowing through Gimhae city.Gaya Theme Park  - Where people can enjoy the culture and life of the ancient Kaya Kingdom. Besides, visitors can watch a historical play there along with many adventure activities. \n'
            'Free tickets to Hero Painter Show -  Fun and humorous art performance by talented guys in Korean style.Experience the Haeundae Coastal Train - Where tourists can enjoy a panoramic view of Haeundae Beach from above, a super beautiful place in Busan.The group has dinner (Stir-fried meat), returns to the hotel to check in, rest and freely explore Busan night market at night. \n'
            'DAY 2: BUSAN - DAEGU (Breakfast, lunch, dinner) \n'
            'The group has breakfast at the hotel and begins the tour: \n'
            'Gamcheon Mural Village - Restored by artists with artistic colors, it is known as the Santorini of Korea.The group moved to the beautiful city of Deagu. \n'
            'HyangChon Cultural Village - A place that recreates memories of Daegu in the years 1900 - 1950. \n'
            'Songhae Park  - The most beautiful riverside park for cherry blossom viewing in Daegu. \n'
            'The group had lunch with Rib Soup. The group continued to visit: \n'
            'Visit Keimyung University  - The school is considered one of the most beautiful in the land of Kim Chi, known as the filming location of famous Korean movies (Boys Over Flowers).The group has dinner (chicken stew with ginseng), then you return to the hotel to rest. \n'
            'DAY 3: DAEGU - SEOUL - Gyeongbokgung Palace (Breakfast, Lunch, Dinner) \n'
            'The group has breakfast at the hotel, checks out and moves to Daegu station to experience the KTX high-speed train to Seoul. After arriving in Seoul, the group continues to visit: \n'
            'Gyeongbok Palace (Gyeongbokgung) - Royal palace located in the north of Seoul, built in 1395 under the reign of King Taejo of the Joseon Dynasty.National Folk Museum of Korea - A museum with deep cultural value, and only this museum is the place to preserve, display and introduce documents and artifacts related to Korean folk culture. \n'
            'The Blue House - Presidential Palace "The Blue House": This is where the current President of South Korea lives and works.The group had lunch with grilled fish. The group continued to visit: \n'
            'Visit famous Korean cosmetics stores and enjoy Korean makeup style. \n'
            'Explore the Government Ginseng Center - A place sponsored by the Korean government and Samsung Group committed to product quality. \n'
            'The group had dinner (mushroom hotpot) at a local restaurant. \n'
            'You can shop at Lotte /Shilla/Hyundai  duty free stores with high-end brands around the world. \n'
            'At the end of the program, you will return to the hotel to check in and relax. \n'
            'DAY 4: SEOUL - NAMI ISLAND (Breakfast, lunch, dinner) \n'
            'After breakfast, the group begins the tour with a shopping program: \n'
            'Red pine essential oil shop : Red pine essential oil helps rejuvenate aging cells, making visitors always feel healthy and full of energy. \n'
            'Local Farm Shop. \n'
            'Join a Kimchi making class and wear traditional Korean Hanbok.The group had lunch (mixed rice) at a local restaurant. The group continued to visit: \n'
            'Nami Island - The island has a peaceful beauty thanks to its charming and poetic natural scenery. This is the place chosen as the filming location for the famous TV series "Winter Sonata", as well as many other famous Korean films.The group has dinner (Grilled Chicken) at a local restaurant. You return to the hotel and are free to relax. \n'
            'DAY 5: SEOUL - HO CHI MINH CITY (Breakfast, lunch) \n'
            'Check out and go to the restaurant for breakfast. Then free time to shop at the department store and pack your luggage. \n'
            'The group had lunch (mixed rice) at a local restaurant. \n'
            'Car picks you up at Incheon airport to check in for flight to Tan Son Nhat airport. \n'
            'Arriving at Tan Son Nhat airport, the group completes Vietnam immigration procedures and receives personal luggage. The tour leader says goodbye and hopes to see you again.',
        'nation': 'Korea',
        'tour_price': 1381.02, // Updated to use double
      });
      await db.insert('tours', {
        'tour_id': 9,
        'tour_name':
        'Yichang - Zhangjiajie - Tianmen Mountain - Phoenix Ancient Town',
        'image': 'china3.jpg',
        'time': 5,
        'destination':
        "Explore China 6 days 5 nights with a journey through the Three Gorges Dam, Phoenix Ancient Town, Zhangjiajie and Yichang. Visit the Three Gorges Dam, the world's largest hydroelectric project, and admire the majestic landscape. Explore Phoenix Ancient Town with its ancient streets, poetic Tuojiang River and traditional architecture. Continue to Zhangjiajie, explore the national park with towering stone pillars and beautiful nature, famous through the movie Avatar. Visit Yichang, enjoy the scenery of the Yangtze River and experience rich local cuisine. Ideal tour for families and travelers who want to enjoy the beauty of China's nature and culture.",
        'schedule': 'DAY 1: HO CHI MINH CITY - YI CHANG, HUBAE (Meals on the plane) \n'
            '11:05: You gather at Tan Son Nhat International Airport, tour guide guides you through check-in procedures for flight QW6190 at 14:05 to Tam Hiep Airport, Yichang City, Hubei Province. \n'
            '19:05: Arrive at Tam Hiep International Airport - Yichang, the group completes immigration procedures. \n'
            'After immigration, the car and tour guide prepare to take the group to the hotel to check in. \n'
            'Overnight at 4 star Chinese standard hotel in Yichang. \n'
            'DAY 2: YICHANG - THREE GORGES DAM CRUISE - QUYUAN CITY - ZHANGJIAJIE (Breakfast, lunch, dinner) \n'
            'Morning: You will have breakfast at the hotel. Tour guide and car will take you to visit: \n'
            '- “ Three Gorges ”: are three canyons with rivers flowing through them. The three canyons are “Qu Tang Gorge”, “Wu Gorge”, and “Xiling Gorge”. Visitors will take a cruise (cost included) to admire the longest river in Asia, the number one dam of Three Gorges - Ge Zhou Ba and enjoy the beautiful landscape here. \n'
            '-" " Three Gorges Dam "": is currently the largest hydroelectric dam in the world and the second largest project in China, after the Great Wall. Lunch: You will have lunch at the restaurant. \n'
            'Afternoon: Visit: \n'
            'Hometown of Qu Yuan  - A famous politician and poet during the Warring States period in the Chu state in Chinese history. Admire the beautiful scenery at Hiep Tay Lang The Ngoai Dao Nguyen . \n'
            'After the tour, the car took the group to the town of" "Zhangjiajie"". \n'
            '- "" Zhangjiajie "": When mentioning this place, people will immediately think of stone pillars thousands of meters high, glass bridges suspended in the air, enough to make you feel scared even if you have never walked on them. Evening: Dinner at the restaurant. \n'
            'After dinner, you can freely choose to visit, shop or register to watch famous shows in Truong Gia Gioi such as My Luc Suong Tay, Truong Gia Gioi Thien Co Tinh, Thien Mon Ho Tien (you pay for yourself). \n'
            'Overnight at 4 star Chinese standard hotel in Zhangjiajie. \n'
            'DAY 3: ZHANGJIAJIE - TIANMEN MOUNTAIN - WULINGYUAN (Breakfast, lunch, dinner) \n'
            'Morning: You have breakfast at the hotel. Then the group departs for: \n'
            '- “Traditional Chinese Medicine Culture Center”: Focus on promoting China"s national intangible cultural heritage, feeling the charm of traditional Chinese medicine. \n'
            'Lunch: You will have lunch at the restaurant. \n'
            'Afternoon: The group continues to depart to visit the leading national park - world natural heritage ""Tianmen Mountain National Tropical Park"": \n'
            'Tianmen Mountain (including cable car) - Known as the ""Soul of Wuling"" Xiangxi Mountain. You will experience the longest mountain cable car in the world, enjoying the beautiful scenery like a poetic natural painting. \n'
            'Special: You will conquer the mountain by the longest, most majestic and modern cable car system in Asia (98-cabin cable car with a length of 7,455m) At the top of the mountain, the group visited Lang Tieu Dai - Thien Mon Son Square , where the widest view can be seen for thousands of miles, covering the entire beautiful scenery of this area. \n'
            'Quỷ Cốc San Dao  - The road along the unique steep cliff, associated with the legend of the creation of Quỷ Cốc Thần Công by Quỷ Cốc Tử. The group passed through ancient spaces of chivalry with Thiên Sơn Phái, Tiêu Ngạo Giang Hồ,... - You will go through the ""world is longest escalator"" system (cost included), massive inside the mountain to reach Heaven"s Gate - Thien Mon Son, where heaven and earth meet. \n'
            'After the tour, the car and tour guide will take the group to ""Phoenix Ancient Town"". \n'
            'Evening: Dinner at the restaurant. Free time to visit: \n'
            '- “ Night view of Phoenix Ancient Town ”: you can stroll along the Da Jiang River, release flower lanterns, or you can go with friends to the riverside bar to enjoy the specialty of beard wine, taste the unique customs of the Miao people, relieve pressure and stress, enjoy the night view of the ancient town, let all the worries disappear with the wind. Overnight at 4-star Chinese standard hotel in Phoenix Ancient Town. \n'
            'DAY 4: PHOENIX ANCIENT TOWN - ZHANGJIAJIE (Breakfast, Lunch, Dinner) \n'
            'Morning: Have breakfast at the hotel. Tour guide and car will take you to: \n'
            '- “Phoenix Ancient Town” - famous historical and cultural city of China (including shuttle bus): \n'
            '+ Enjoy the captivating scenery of Da Giang and the stone jumping bridge. \n'
            '+ Linger in Shawan Scenic Area, visit the world intangible cultural heritage “Miao People"s Silver Jewelry Forging Skills Exhibition” and understand the spirit of Chinese craftsmen. \n'
            '+ Stroll around Thac Ban street, Hong Kieu art building,.....Lunch: You will have lunch at the restaurant. \n'
            'Afternoon: After the tour, the car will take you back to "Zhangjiajie" \n'
            '- “Chinese Tea Shop”: Where visitors can learn about the process of making local tea specialties, taste them, and buy them as gifts for relatives and friends. \n'
            'Evening: You will have dinner at the restaurant, then return to the hotel to rest. You can pay for yourself to participate in famous shows of Zhangjiajie such as the ethnic art show, Mi luc Suong Tay, Truong Gia Gioi Thien Co Tinh \n'
            'Overnight at 4 star Chinese standard hotel in Zhangjiajie. \n'
            'DAY 5: PHOENIX ANCIENT TOWN - BAO FENG LAKE (BREAKFAST, LUNCH, DINNER) \n'
            'Morning: You will have breakfast at the hotel. Tour guide and car will take you to visit: \n'
            '- “China Silk Exhibition Center”: Explore the history of silk development in ancient China and learn about the maritime silk road. \n'
            '- “Jade Shop”: Displaying hundreds of handmade items made from Jade, demonstrating the talent and pinnacle of Chinese hand-carving. \n'
            '- Baofeng Lake - A freshwater lake located in the Wulingyuan Scenic Area, Hunan Province, China, surrounded by towering limestone mountains. (including VIP electric car + cruise)Lunch: You will have lunch at the restaurant. \n'
            'Afternoon: You can participate in self-paid activities such as: \n'
            '- Explore the national 4A tourist area ""Zhangjiajie Daxiaogu"" and experience "" Daxiaogu Glass Bridge "": This is the world"s tallest and longest glass bridge, standing on the bridge you can see the whole view of the 400m deep valley bottom; the super long bridge with wind-resistant cables allows you to fully enjoy the exciting feeling. The place is said to have inspired the fairyland scene in the famous movie Avatar.After the tour, the car will take you to Nghi Xuong to visit the beautiful scenery of the Three Gorges. \n'
            'Evening: Dinner at the restaurant. \n'
            'Overnight at 4 star Chinese standard hotel in Yichang. \n'
            'DAY 6: NGHI XUONG - THE NGOAI DAO NGUYEN - HCM (Breakfast, Lunch on plane) \n'
            'Morning: You have breakfast at the hotel. Tour guide and car will take you to visit: \n'
            '- “ The Outsider"s Paradise ”: Inspired by a Chinese legend, it refers to a place with beautiful, poetic scenery isolated from the outside world, where there is no competition or jealousy, only nature and hospitable people. \n'
            'Then the car and tour guide will take the group to Tam Hiep airport to check in for flight QW6189 at 10:30 to Tan Son Nhat. \n'
            '12:55 Arrive at Tan Son Nhat airport. End of program, say goodbye and see you again in the next journeys."',
        'nation': 'Korea',
        'tour_price': 2000.0, // Updated to use double
      });

      await db.insert('tours', {
        'tour_id': 10,
        'tour_name': 'HCM - Da Nang - Hoi An - Hue - Quang Binh',
        'image': 'vietnam2.jpg',
        'time': 4,
        'destination':
        'Discover Da Nang 4D3N takes visitors to explore the quintessence of Central Vietnam through attractive destinations such as Da Nang, Hoi An, Hue and Quang Binh. The journey promises an unforgettable experience with the majestic scenery of Son Tra Peninsula, the ancient beauty of Hoi An ancient town, the majesty of Hue citadel and the magnificence of Phong Nha cave. This is the perfect choice to explore cultural heritage while enjoying the beautiful nature and unique cuisine of this land.',
        'schedule': 'DAY 1: Da Nang - SON TRA PENINSULA - HOI AN ANCIENT TOWN (Lunch) \n'
            'Morning: Depart from Tan Son Nhat airport on flight  VJ622 07:25  to Da Nang. \n'
            'Arriving in Da Nang, car and tour guide take the group to visit \n'
            'Son Tra Peninsula  - A natural gift for Da Nang, featuring clear beaches and cool green forests, is a peaceful and beautiful tourist destination.Linh Ung Pagoda  - Considered a Buddhist paradise on earth. Home to the tallest statue of Bodhisattva Avalokitesvara in Vietnam, considered one of the "Four Towns of Da Thanh".The group had lunch with specialties "Rice Paper Rolls with Pork", Quang Noodles, and Banh Beo. \n'
            'Then the group departed for the hotel to check in and rest. \n'
            'Afternoon free swimming at My Khe beach . \n'
            '16:00: The group visits Ngu Hanh Son - Non Nuoc Stone Carving Village with stone statues carved by the talented hands of artisans here.The car takes you to Hoi An - where life is peaceful, where the indifferent flow of time seems unable to bury the ancient atmosphere. Tourists walk to visit Hoi An Ancient Town with Japanese Covered Bridge, Ancient House, Phuc Kien Assembly Hall and handicraft workshops.The group is free to enjoy specialties in Hoi An such as: Cao Lau, Quang Noodles,... \n'
            '20:00: The group departs back to Da Nang for the night. Free to enjoy the night view of Da Nang, free to stroll along the beach. \n'
            'DAY 2: BA NA TOURIST AREA - LANG CO BAY - HUE ANCIENT CAPITAL (Breakfast, dinner) \n'
            'You have breakfast at the restaurant, check out. The group departs to visit: \n'
            'Love Bridge - This is a place of proof and promise for couples. The meaning of the love lock represents a strong, eternal love. \n'
            'The Carp Transforming into Dragon Statue is a spiritual symbol of the Vietnamese people, representing luck and success.Then the car will take the group to visit the  Ba Na Hills Discovery program . Experience the Ba Na cable car, admire the mountain and forest landscape covered in clouds, and visit (at your own expense).Linh Ung Pagoda on Ba Na Hills with a 27m high statue of Buddha Shakyamuni. 27m high, visit the temple of the Mother Goddess of the Upper Realm.Fantasy Park  offers exciting entertainment games and a Wax Museum with wax statues of famous people. \n'
            'The wax museum  is one of the highlights at Ba Na tourist area, where wax statues of famous people in the world are carved, very interesting. (self-sufficient from 100,000 VND) The group has lunch at the restaurant of Ba Na tourist area with Vietnamese rice buffet menu (if you join the Ba Na tour package). \n'
            '15:30: The group departs for Hue Ancient Capital  - World Cultural Heritage, through Hai Van tunnel, stops to take photos of Lang Co Bay . \n'
            'Arrive in Hue, check in 4* hotel and rest. \n'
            'The group has dinner at the restaurant. After dinner, you are free to walk around the city at night. \n'
            'Overnight in Hue. \n'
            'DAY 3: LA VANG HOLY LAND - HIEN LUONG BRIDGE - PHONG NHA CAVE (Breakfast, lunch, dinner) \n'
            'The group has buffet breakfast at the hotel. The group departs for Phong Nha - Ke Bang World Natural Heritage. \n'
            'On the way, the delegation visited La Vang Holy Land -  one of the important pilgrimage sites not only for Catholics, but also for non-Catholics and international tourists.Next, the group stopped to admire the 17th Parallel - Hien Luong Bridge - Ben Hai River . \n'
            'The group had lunch at a restaurant in Phong Nha and rested at the restaurant. \n'
            'Visit Phong Nha Cave by boat on the Son River, explore the majestic caves in the tropical limestone area, with more than 300 diverse caves. Bi Ky, Co Tien and Cung Dinh caves are the highlights, where the underground river from Laos creates a magical landscape.15:30: The group departs back to the Ancient Capital of Hue via the legendary Truong Son - Ho Chi Minh road. \n'
            'The group had dinner at Dong Ha restaurant, Quang Tri. \n'
            'Arrive in Hue, return to hotel to rest, freely enjoy specialties and visit Hue city at night. \n'
            'DAY 4: IMPERIAL CITY - THIEN MU PAGODA (Breakfast, lunch) \n'
            'Have buffet breakfast at the hotel, check out. Tour group: \n'
            'Imperial City - Associated with the Nguyen Dynasty with Ngo Mon Gate, Thai Hoa Palace, Forbidden City, The Mieu, Hien Lam Cac, and Cuu Dinh - This is also one of Vietnam is heritages recognized by UNESCO as a World Cultural Heritage.Thien Mu Pagoda - The sacred symbol of Hue, located on Ha Khe hill, next to the Perfume River. Praised in poetry and music, the pagoda is a must-see destination, with unique historical and cultural beauty.The group arrives at the restaurant for lunch. The group departs to visit: \n'
            'Incense and conical hat making village - A long-standing traditional craft village in Hue, this place attracts many tourists who like to take virtual photos because of the brilliant scenery of multi-colored incense bundles of green, red, purple, yellow...The group stopped at a rest stop to buy specialties as gifts for relatives. \n'
            'The group goes to Hue Airport, checks in for flight back to Ho Chi Minh City on flight  VJ307 at 17:35 . \n'
            'The tour guide says goodbye to visitors, ending the interesting tour here and see you again in the next tours.',
        'nation': 'Vietnam',
        'tour_price': 2000.0, // Updated to use double
      });
      await db.insert('tours', {
        'tour_id': 11,
        'tour_name': 'HCM - Hanoi - Sapa - Lao Cai - Ninh Binh - Ha Long',
        'image': 'vietnam3.jpg',
        'time': 5,
        'destination':
        'Discover the beauty of Northern Vietnam on a 5-day, 4-night journey, departing from Ho Chi Minh City. Starting in Hanoi, visitors will visit the Temple of Literature, Hoan Kiem Lake and the Old Quarter. Continue to Sapa, admire the Northwest mountains and forests, visit Cat Cat village and conquer Fansipan peak. Then, the journey takes visitors to Lao Cai, explore the beauty of the border and local culture. Next, to Ninh Binh, visitors visit Trang An and Bai Dinh Pagoda, enjoy the majestic natural scenery. Finally, the journey ends in Ha Long with a cruise to see thousands of beautiful rocky islands in the bay. This trip brings unforgettable experiences and memories.',
        'schedule': 'Day 1: Ho Chi Minh - Hanoi - Sapa (Lunch, dinner) \n'
            '04:30: Pick up the group at Tan Son Nhat airport, check in for flight to Hanoi (expected time 06:30). \n'
            '09:00: Arrive at Noi Bai airport, depart for Sapa. \n'
            '12:00: Lunch in Lao Cai. \n'
            'Visit and take photos at the Vietnam-China Friendship Landmark - a 1-ton landmark, marking a historical location where our ancestors sacrificed their blood and bones from the 19th century to the present to preserve for future generations.Shopping at Coc Leu market  (if there is time) - The market imports goods directly at the border gate, so the goods here are extremely diverse, rich,... \n'
            'Arrive in Sapa, check in and rest. \n'
            'The group has dinner at the restaurant. Free to explore the small streets of Sapa. \n'
            'Overnight in Sapa. \n'
            'Day 2: Sapa - Fansipan - Cat Cat Village (Breakfast, lunch) \n'
            'The group has breakfast at the hotel. Depart to conquer the roof of Indochina, Fansipan peak. \n'
            'You will experience the cable car to the top of Fansipan at an altitude of 2,900m. Then, continue walking to Thanh Van Dac Lo and Bich Van Thien Tu to offer incense at an altitude of 3,037m. (Self-funded)The group moves down to the cable car station, the tour guide takes the group to the restaurant for lunch. \n'
            'Cat Cat Village - Hmong Village, learn about the unique, simple and rustic customs and practices of the local people in the highlands.The group enjoys food at Sapa night market on their own. \n'
            'Overnight in Sapa. \n'
            'Day 3: Sapa - Hanoi (breakfast, lunch, dinner) \n'
            'The group has breakfast and checks out of the hotel. Depart for Hanoi. \n'
            'The group had lunch in Phu Tho. \n'
            'Visit Tran Quoc Pagoda -  the oldest Tran Bac Pagoda in Vietnam with 1,500 years old located on the sacred Quy island peninsula with legends and myths about West Lake and Truc Bach Lake.Hoan Kiem Lake - Known as the heart of Hanoi capital, is a favorite destination for tourists from all over the world with valuable historical and cultural values. Then visit Ngoc Son Temple, The Huc Bridge.Visit the Presidential Palace historical relic complex: \n'
            'Ba Dinh Square - A special relic, this place also records many important milestones in Vietnamese history. Where Uncle Ho Chi Minh declared independence (visit outside).Ho Chi Minh Museum - Focuses mainly on displaying artifacts and documents about the life and personality of Ho Chi Minh.Uncle Ho is Stilt House - Simple located in the middle of Hanoi capital is where Uncle Ho lived and worked the longest during his revolutionary life.One Pillar Pagoda - The pagoda has a unique architecture, with only 1 room built on a stone pillar located in the middle of Linh Chieu Lake,...Enjoy Hanoi cuisine, check in hotel and rest. \n'
            'Overnight in Hanoi. \n'
            'Day 4: Hanoi - Trang An (Ninh Binh) - Ha Long (Breakfast, lunch, dinner) \n'
            'The group had breakfast and checked out of the hotel. \n'
            'Visit the Ho Chi Minh Mausoleum - where the remains of President Ho Chi Minh are kept. \n'
            'Continuing the journey, the group departs for Ninh Binh, where you can pray to Buddha at: \n'
            'Bai Dinh Pagoda  (including electric car to the pagoda) - The largest pagoda in Vietnam with 500 La Han statues, the largest bronze Buddha statue in Vietnam.The group had lunch with Ninh Binh is specialty of Mountain Goat Rice Crispy Rice. \n'
            'Visit Trang An scenic complex by boat - a UNESCO recognized World Cultural and Natural Heritage.16:00: Depart for Ha Long, passing through Nam Dinh, Thai Binh and Hai Phong on the way. \n'
            'The group has dinner, freely walks around Royal Park , and shops at Ha Long night market. \n'
            'Overnight in Ha Long. \n'
            'Day 5: Ha Long - Hanoi - Ho Chi Minh (Breakfast, lunch) \n'
            'The group has breakfast and checks out of the hotel. The group arrives at Tuan Chau wharf to begin the journey to visit the Natural Heritage in Vietnam, with famous attractions: \n'
            'Thien Cung Cave - Located on Dau Go Island (southwest of Ha Long Bay) at an altitude of about 25m above sea level. The cave is nearly 10,000m2 wide with a complex structure, surrounded on all sides by very high walls and stalactites and stalagmites with many strange shapes. \n'
            'Sightseeing in the Fishing Village - Visitors are easily captivated by the beauty of boats, bamboo boats moored in front of houses, and houses tied together to protect against storms.The group had lunch on the cruise. \n'
            'Admiring Dinh Huong Islet - Located in the middle of the ocean is a very sacred image of Ha Long.See Turtle Island ,  Stone Dog Island ,  Fighting Cock Island ,... \n'
            'In the afternoon, the train arrives at the port and the car takes the group back to Hanoi. \n'
            'Go to the airport to check in for flight back to Ho Chi Minh City, scheduled at 7:30 p.m. \n'
            'End of the Northern tour.',
        'nation': 'Vietnam',
        'tour_price': 2000.0, // Updated to use double
      });
      await db.insert('tours', {
        'tour_id': 12,
        'tour_name':
        'Singapore - Malaysia Tour 5N4D: HCM - Merlion Park - Marina Bay - Gardens By The Bay - Chen Hoon Temple - Putra Jaya',
        'image': 'singapore2.jpg',
        'time': 5,
        'destination':
        'Explore Singapore and Malaysia 5 days 4 nights from Ho Chi Minh City, visit Merlion Park, Marina Bay and Gardens by the Bay in Singapore. Experience diverse cultures in Chinatown, Little India and enjoy local cuisine. Continue the journey to Malaysia, explore Chen Hoon Temple, modern city of Putra Jaya and famous spots in Kuala Lumpur. Enjoy shopping at bustling shopping centers. Perfect tour for families and travelers who love exploring, shopping and experiencing culture.',
        'schedule': 'DAY 01: HO CHI MINH CITY - SINGAPORE (Breakfast, light lunch, dinner) \n'
            '06:00: You gather at Tan Son Nhat airport (International Departure Terminal) - column 9, tour guide picks you up to check in for departure to Singapore. \n'
            'You have breakfast at the airport, Hamburger or Sticky Rice. \n'
            'Arrive at Changi Airport – Airport Singapore. The group has a light lunch at the airport with the specialty Hainanese Chicken Rice. Then depart to visit: \n'
            'Merlion Park is the symbol of Singapore .Parliament House - Also where Prime Minister Lee Kuan Yew read the Declaration of Independence. \n'
            'Take a souvenir photo at Esplanade Theater - With unique architecture famous for the symbol "Durian". (take photo outside)Helix Bridge (DNA Bridge), Singapore Flyer Ferris Wheel. (At your own expense) \n'
            'Go to hotel to rest. \n'
            'The group has dinner. Free to explore the city at night or join the night tour option (at your own expense): \n'
            '- Suntec City Feng Shui Center  - Take a boat ride on the Singapore River and see the Merlion statue shimmering magically in colorful lights. \n'
            '- Experience  Singapore is modern MRT subway  . \n'
            '- Enjoy the " spectra a light and water show " at Marina Bay combined with a visit to the Suntec city commercial complex. \n'
            'DAY 02: VISIT SINGAPORE - MALAYSIA (Breakfast, Lunch, Dinner) \n'
            'Have breakfast at the hotel, check out. Continue to visit Singapore: \n'
            'Garden By The Bay - A 100-hectare artificial garden in Singapore, featuring 250,000 species of plants and super trees that shine thanks to solar energy. From here, you can see the whole view of Marina Bay Sands from a height of 200m.You can shop for Singapore specialties at the Singapore essential oil store, jewelry center... \n'
            'The group had lunch at Goro Goro Korean Buffet Hotpot restaurant. \n'
            'The car takes the group to Sentosa Island - Providing diverse experiences from the iconic Universal Studio, Festival Walk, to SEA Aquarium and Wax Museum, combined with entertainment at Resort World Sentosa Casino. (at your own expense) \n'
            'Explore Resort World and visit the most modern Casino in Asia. \n'
            'The crew took a photo outside Universal Studios .Dao moved to and entered Malaysia. \n'
            'The group had dinner at a local restaurant. Then had free time to enjoy the bustling old town of Malacca. \n'
            'Overnight in Malacca. \n'
            'DAY 03: MALACCA - KUALA LUMPUR (Breakfast, lunch, dinner) \n'
            'Have breakfast and check out. Car and tour guide take the group to visit the ancient city of Malacca with: \n'
            'Cheng Hood Temple - A testament to the long history of the Chinese community in Malacca, Malaysia. \n'
            'St. Paul is Church and AFamosa Fort in Malacca are located on a hill, offering visitors a panoramic view of ancient Malacca and the Straits of Malacca in the distance, weather permitting. \n'
            'Dutch Square - A vestige from the time when Dutch colonialists ruled this place, at the square visitors seem to get lost in the red scenery typical of the Netherlands.Wawasan Bridge  - Sail-shaped cable-stayed bridge. \n'
            'Putra Square and Prime Minister is Office (Green House). \n'
            'You will have lunch at Seoul Gradens BBQ Hotpot + Grill restaurant (Unlimited food) \n'
            'The group departs for Genting Highlands - Conquering an altitude of over 2000m by a 4km long cable car system. You will discover a legendary and truly magnificent Genting with a casino system, hotels, and entertainment games. You can try your luck at the casinos, participate in Indoor and Outdoor games at the Theme Park. (at your own expense - If the cable car is under maintenance, you will travel by Genting car)You will have dinner with the dish "Chili Crab". Then the group will return to the capital Kuala Lumpur to check in at a 4-star hotel. \n'
            'You can go to the Western Quarter, Chinatown, Night Market Quarter, enjoy the unique and bustling street performances. \n'
            'Overnight in Kuala Lumpur. \n'
            'DAY 04: ROYAL PALACE OF MALAYSIA - PETRONAS TWIN TOWERS (Breakfast, lunch, dinner) \n'
            'You will have buffet breakfast at the hotel, then visit: \n'
            'The Royal Palace of Malaysia  - Where the King of Malaysia holds the throne.Visit local specialties such as: Tongkat Ali Ginseng, Malaysian Tin & Black Stone, Duty Free Watches… \n'
            'Batu Caves - A holy place for Malaysians of Indian origin, enjoy Indian milk tea and conquer 272 steps to visit temples with many unique statues.The group has lunch at a local restaurant. In the afternoon, you will visit: \n'
            'Victory Monument. Independence Square - The 3rd tallest flagpole in the world (100 m) \n'
            'Chocolate Factory. \n'
            'Visit the 452m high Petronas Twin Towers . \n'
            'You have dinner and return to the hotel. You are free to explore the bustling capital at night - Bukit bintang entertainment area where local and international cuisines converge, shopping, and nightlife entertainment. \n'
            'Overnight in Kuala Lumpur. \n'
            'DAY 05: MALAYSIA - HO CHI MINH CITY (Breakfast, light lunch at the airport) \n'
            'In the morning, you will have a buffet breakfast at the hotel. After checking out, the group will depart to visit: \n'
            ' Thien Hau Thanh Mau Temple - Known as a very sacred place of worship for the Chinese community in Malaysia.Then, the car takes the group to Kuala Lumpur airport. Free shopping at duty-free stores and check in for the flight back to Ho Chi Minh City. \n'
            'You will have a light lunch of hamburgers at the airport. \n'
            'The plane landed in Ho Chi Minh City, the tour guide said goodbye to the group and see you again on the next trip.',
        'nation': 'Singapore',
        'tour_price': 779.52, // Updated to use double
      });
      await db.insert('tours', {
        'tour_id': 13,
        'tour_name':
        'Singapore Tour 3N2D: Explore Lion Island - Gardens By The Bay - Buddha Tooth Relic Temple',
        'image': 'singapore3.jpg',
        'time': 3,
        'destination':
        'Experience a 3-day, 2-night journey to explore the Lion Island, with highlights such as Gardens by the Bay, Buddha Tooth Relic Temple and many other landmarks. Enjoy the modern beauty of Singapore at Gardens by the Bay with impressive supertrees and Flower Dome. Visit Buddha Tooth Relic Temple, a famous Buddhist temple with magnificent architecture and precious relics. Explore other attractive destinations such as Marina Bay Sands, Merlion Park and Orchard shopping district.',
        'schedule': 'DAY 1: HO CHI MINH CITY - SINGAPORE - CITY TOUR (Breakfast on plane, Light lunch, Dinner) \n'
            'You gather at Tan Son Nhat airport, international departure terminal, the tour leader will guide you through the flight procedures to Changi international airport. \n'
            'Scheduled flight: \n'
            'VJ813 SGN SIN 07:00 - 10:05  (Breakfast at VN airport. Lunch) \n'
            ' VJ811 SGN SIN 09:00 - 12:05  (Breakfast at VN airport. Lunch) \n'
            'Visitors: \n'
            'Parliament House outside tour. \n'
            'Merlion Park -  Symbol of Singapore.Victoria Theatre  - Singapore is oldest theatre. It has been the centre of Singapore is performing arts since colonial times. \n'
            'Esplanade Theatre - Famous for its iconic “durian” symbol - Singapore is most modern theatre.The group has dinner. You check in to rest or join the 3-in-1 program to explore Singapore at night -  Singapore By Night  (at your own expense). \n'
            '- Explore Singapore is underground life with the MRT subway system . \n'
            ' - Enjoy the Spectra Show water music program at Marina Bay Sands resort. \n'
            '- Experience a cruise on the Singapore River with panoramic views of Clarke Quay and Marina Bay. \n'
            'DAY 2: GARDEN BY THE BAY - BUDDHA TOOTH TEMPLE - SENTOSA (Breakfast, Lunch, Dinner) \n'
            'The group has breakfast at the hotel. Then the car takes the group to visit: \n'
            'Garden By The Bay - A 100-hectare artificial garden in Singapore, featuring 250,000 species of plants and super trees that shine thanks to solar energy. From here, you can see the whole view of Marina Bay Sands from a height of 200m.Buddha Tooth Relic Temple & Museum - Located in Chinatown and built in 2007, it offers an insight into Buddhist art and history through its meticulous interior design and comprehensive exhibits, narrating hundreds of years of culture.Diamond Industry. \n'
            'Shop for essential oils, collagen for skin care and other traditional, famous and unique products of Singapore (Harbourmart). \n'
            'Faber Mount  - Enjoy panoramic views of Singapore from above.The group had a BBQ lunch buffet. \n'
            'Then depart for Sentosa Island to visit: \n'
            'Take a photo with the Universal Studios theme park icon .Resorts World  - Visit Asia is most modern Casino at Singapore is largest 5-star hotel.SEA Aquarium - One of the largest aquariums in the world recognized by UNESCO. You can admire more than 100,000 marine animals of more than 800 different species from all over the world. (At your own expense)The group had dinner with Bak Kuh Teh specialties . Return to the hotel to rest. Overnight in Singapore. \n'
            'DAY 3: SINGAPORE - HO CHI MINH CITY (Breakfast, light lunch) \n'
            'The group has breakfast buffet at the hotel. Check out. Then, the car takes the group to visit: \n'
            'Jewel Changi - A fusion of nature and human creativity. Admire the 40m high Rain Vortex, the world is tallest indoor waterfall.At the appointed time, you will check in to return to Vietnam, the flight arrives in Ho Chi Minh City. \n'
            'Expected flight: \n'
            'VJ814 SIN - SGN l16:55-18:05  (Lunch at local restaurant) ',
        'nation': 'Singapore',
        'tour_price': 844.54, // Updated to use double
      });
      await db.insert('tours', {
        'tour_id': 14,
        'tour_name':
        'Japan Tour 5N5D: Golden Route Osaka - Kyoto - Tokyo Autumn',
        'image': 'japan3.jpg',
        'time': 5,
        'destination':
        'Experience a 5-day, 5-night journey on the golden route from Osaka, Kyoto to Tokyo, exploring Japan is famous and attractive destinations. Start in Osaka, a vibrant city with bustling shopping areas and rich street food. Continue to Kyoto, a place that preserves ancient beauty with temples, shrines and traditional gardens. The journey ends in Tokyo, a modern and vibrant capital, where you can admire skyscrapers, visit fashion districts and experience unique culture. This trip promises to bring you memorable memories and wonderful experiences of the land of cherry blossoms.',
        'schedule': 'Day 01: SAIGON - KANSAI (OVERNIGHT ON PLANE) \n'
            'Tour guide will pick you up at Tan Son Nhat airport, assist with check-in procedures for flight  VJ828 SGN - KIX 01:00 - 08:30 to Japan. \n'
            'DAY 01: KANSAI - OSAKA (Breakfast on plane, lunch, dinner) \n'
            'The group arrives at Kansai airport, the car picks up the group and departs for Osaka to visit: \n'
            'Hakutsuru Sake Museum -  This type of sake is called Nihonshu in Japanese, you can try Japan is national drink.Osaka Castle - Symbol of Osaka city, one of the most famous castles possessing ancient beauty and long history of Japan. (take pictures outside) \n'
            'Enjoy shopping at Shinsaibashi - the most famous shopping street in Shisaibashi Suji area, Osaka city.The group had dinner with famous  Kobe beef specialties  , then returned to their rooms to rest. \n'
            'Overnight in Osaka. \n'
            'DAY 02: OSAKA - KYOTO - NAGOYA (Breakfast, lunch, dinner) \n'
            'The group has breakfast at the hotel, checks out. Depart for Kyoto - the ancient capital of Japan to visit: \n'
            'Enjoy the art of Japanese tea ceremony  - Shop for items made from the famous green tea as the main ingredient.Sagano Bamboo Forest  (Arashiyama) - The beautiful forest in Kyoto has long been an unmissable destination for visitors when visiting the peaceful space, feeling the true breath of nature amidst the noisy, modern life.Kiyomizudera Temple  - Built in 778, it boasts unique scenery in every season. The temple grounds have the Otowa stream, visitors who take a sip from one of the three streams will achieve one of three wishes: Longevity - Academic success - Happy love.The group had dinner and checked into the hotel to rest. \n'
            'Overnight in Nagoya or vicinity. \n'
            'DAY 03: NAGOYA - FUJI (Breakfast, lunch, dinner) \n'
            'The group has breakfast at the hotel, checks out. The car picks up the group and departs for Yamanashi. \n'
            'The company gives you 1 ticket  to experience the Shinkansen train  - one of the fastest and safest means of transport on the ground today with an average speed of 320 km/h, sometimes up to 581 km/h.Mount Fuji  (up to 5th station if weather permits) - Known as the symbol of Japan. The mountain has always been an endless source of inspiration for artists, authors and tourists.Earthquake Museum  - A place that preserves the history related to Japan is earthquakes. Experience each level of earthquake tremors, learn about the history related to earthquakes and how the Japanese people have coped with harsh nature.Oshino Hakkai Village  - Recognized by Unesco as a world cultural heritage. It is an ancient village that still retains its ancient culture, beautiful scenery, quiet and peaceful located at the foot of Mount Fuji.You have dinner, check in and rest. Enjoy Onsen hot spring bath  at the hotel. \n'
            'Wear Kimono  and take photos at the hotel. (If you want to rent a Kimono for sightseeing the next day, the rental fee is 3,000-5,000 yen/set)DAY 04: YAMANASHI - TOKYO (BREAKFAST, LUNCH, DINNER ON YOUR OWN) \n'
            'The group has breakfast, checks out. Then departs for Tokyo. Visit the following attractions depending on the appropriate time: \n'
            'Yamanakako Hanano Miyako Park (applicable before September 27) - A flower field located right at the foot of Mount Fuji with millions of petals blooming brilliantly in each season, visitors from all over can enjoy the scenery here. \n'
            '(Park spots may change depending on the season. If there are no flowers in the park, the sightseeing spot will change to taking pictures by Lake Kawaguchi)Visit Oishi Park (valid from October 2, 2024 - November 8, 2024) - Oishi Park is a place to enjoy a panoramic view of beautiful Mount Fuji. Especially during this time, visitors will be able to see the bright red Kochia flowers spreading across the road, covering a corner of the sky.Momiji Kairou Tour (valid from 11/13/2024 - 12/13/2024) - Also known as the maple leaf corridor, maple leaf tunnel, located near Lake Kawaguchi, Yamanashi Prefecture. This is one of the most famous autumn leaf viewing spots in Japan. It is only about 2 hours by car from Tokyo and also has an ideal view of Mount Fuji.Meiji Jingu Gaien (valid from 13/11/2024 - 13/12/2024) - Two rows of giant ginkgo trees line the street of Gaien. This street is 300m long and has 146 ginkgo trees that turn yellow every autumn. This street is a famous place to see the extremely attractive autumn colors of the rows of red and yellow leaves of Japan.The ancient Sensoji Temple (Asakusa Kannon) in Tokyo has a distinctive traditional architecture. Nearby, Nakamise-dori Street is famous for its snacks and souvenirs.Enjoy shopping at JTC department store , Akihabara street - the world is leading electronics district. \n'
            'Aeon Mall & Daiso 100 Yen - You are free to shop and have dinner on your own here to experience local cuisine. \n'
            'The group returned to the hotel to check in and rest. \n'
            'Stay overnight in Narita ready for early flight the next day. \n'
            'DAY 05: NARITA - SAIGON (Light breakfast, lunch on the plane) \n'
            'The group checks out and has a light breakfast prepared by the hotel, then moves to the airport to return to Saigon on flight  VJ823 NRT - SGN 08:55 - 12:55 . \n'
            'The group arrives at Tan Son Nhat airport. The tour guide says goodbye to the group. See you again on the next journey.',
        'nation': 'Japan',
        'tour_price': 1706.16, // Updated to use double
      });
      await db.insert('tours', {
        'tour_id': 15,
        'tour_name':
        'Japan Tour 4N4D: Ho Chi Minh City - Red Leaf Season Narita - Yamanashi - Tokyo',
        'image': 'tourjap1.jpg',
        'time': 5,
        'destination':
        'Explore the brilliant red leaves season in Narita, Yamanashi and Tokyo on a 4-day, 4-night Japan tour departing from Ho Chi Minh City. Experience the majestic scenery of Mount Fuji, immerse yourself in the poetic space of Lake Kawaguchi, and enjoy shopping in the bustling Shinjuku district. With a streamlined itinerary and simple visa procedures, this tour promises to bring visitors wonderful experiences of Japanese nature, culture and cuisine.',
        'schedule': 'Day 01: HO CHI MINH CITY - NARITA \n'
            'The tour guide will pick you up at Gate D2, 2nd Floor, Tan Son Nhat International Departure Terminal, Tan Son Nhat Airport. Check in for Vietjet Air flight VJ822 departing for Narita at 23:50. The group will stay overnight and eat on the plane. \n'
            'DAY 2: TOKYO – YAMANASHI (BREAKFAST, LUNCH, DINNER) \n'
            'The group landed at Narita airport, the tour guide guided the group through immigration procedures, the car picked up the group and had a quick breakfast on the car, starting the tour of Japan. Move to the Yamanashi area. \n'
            'Cruise on Lake Ashi , one of the Fuji Five Lakes. The lake next to Mount Fuji is a popular tourist destination in Japan. Or see the red leaves at Hakone Shrine - Hakone Jinja during the red leaf season. Characterized by the Torii shrine gate built on the water. This is one of the places you cannot miss when traveling to Hakone. Strolling among the rows of cedar trees with many trees over 350 years old and many trees up to 30 to 40 meters high, you will definitely experience the ancient atmosphere like a tourist from the Edo period. (Depending on the red leaf season, the tour guide will arrange to visit 01 of 02 places)Visit Owakudani Valley : This place is always bustling with visitors and has the special dish of lucky black eggs Kurotamag. In Owakudani Valley, there is a Jizo god (Ksitigarbha Bodhisattva) called "Enmei Jizo Bosatsu" - the protector of children and longevity - said to be created by Kobo Daishi in the Heian period (794-1185). Legend has it that Jizo god said that eating a lucky black egg "Kurotamago" will give you 7 more years of longevity (Egg Purchase Costs at your own expense).Visit the garden and pick fruit. You will depart to  the Fruit Garden - enjoy the clean seasonal fruits (grapes, strawberries, cherries, peaches, plums, pears, etc.) that are especially sweet and completely clean, without chemicals. You can enjoy the fruit comfortably in the garden right on the tree. The feeling of picking ripe, sweet fruits and enjoying them right there is extremely interesting and unforgettable.Evening: Check in at the hotel and have dinner. Experience Onsen bathing & wearing Yukata – a type of Japanese hydrotherapy. Overnight in Yamanashi. \n'
            'Recommended hotels: Fujinomori Hotel, Tominoko Kawaguchiko hotel, Fuji-zakura hotel or equivalent. \n'
            'DAY 3: YAMANASHI – KAWAGUCHIKO – TOKYO/YOKOHAMA (BREAKFAST, LUNCH, DINNER) \n'
            'Breakfast at hotel, check out. The group departs to visit: \n'
            'Visit Mount Fuji (ascend to 5th station if weather permits) At 3776m, Mount Fuji is the highest mountain in Japan, shaped like an isosceles triangle, the number 8 八 is known as the symbol of Japan. This most famous mountain in Japan has been and continues to be an endless source of inspiration for artists, authors and tourists.Visit Oshino Hakkai cultural village recognized by Unesco as a world cultural heritage, an ancient village that still retains its ancient culture, beautiful scenery, quiet and peaceful located at the foot of Mount Fuji.Lunch; Lunch at local restaurant and free shopping at Gotemba Outlet \n'
            'Evening: Transfer to Tokyo/Yokohama. Dinner at local restaurant. Overnight at hotel. \n'
            'Reference hotels: APA Hotel & Resort Yokohama Bay Tower, APA hotel Hotel & Resort Tokyo Bay Makuhari or equivalent. \n'
            'DAY 4: VISIT TOKYO - NARITA (BREAKFAST, LUNCH, DINNER) \n'
            'Morning: Have breakfast at the hotel, check out. The group departs to visit: \n'
            'Asakusa Kannon Temple, also known as Sensō-ji, is an ancient temple located in Asakusa, Taito, Tokyo, Japan. It can be said that this is the oldest and most important temple in Japan. The temple was built specifically to worship Bodhisattva Avalokitesvara. \n'
            'Tokyo Sky Tree (taken from Sumida Park ): is the tallest TV tower in the world located in Sumida-ku, Tokyo with a height of 634m. It has an observation deck Tokyo Sky Tree Tembo Deck at 350m above ground level and Tokyo Sky Tree Tembo Kairo at 450m.Lunch; Lunch at a local restaurant (Japanese set menu) and enjoy shopping in Akihabara or Ginza \n'
            'Visit the artificial island of Odaiba located in Tokyo Bay, connected to the center via the Rainbow Bridge. “Replica of the Statue of Liberty” – Previously, the French brought the original statue currently located in Paris to exhibit, then brought it back to their country. To attract visitors, a replica of the Statue of Liberty was built after the original was returned.Evening: Dinner at local restaurant. Overnight at hotel in Narita. \n'
            'Reference hotels: Narita View hotel, The Hedistar Narita hotel or equivalent \n'
            'DAY 5: NARITA – HO CHI MINH CITY (BREAKFAST, LUNCH) \n'
            'Morning: Check out early. The hotel packs breakfast to bring along. The group moves to Narita airport, takes VietjetAir flight VJ823 at 08:55 to Ho Chi Minh City. Lunch on the plane. End of tour. Tour guide says goodbye and see you again.',
        'nation': 'Japan',
        'tour_price': 1868.73, // Updated to use double
      });
    },
    version: 1,
  );
  return database;
}