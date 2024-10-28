import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'About the app',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We provide the following services:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ServiceCard(serviceName: 'About', description: 'Established in 2010, BrigthStar is a member of BrigthStar with over 20 years of experience in the field of Tourism - Hotel. BrigthStar is a pioneer in creating convenient tourism products for domestic customers. Continuously growing strongly over the years, BrigthStar is currently the leading OTA in Vietnam in the high-end segment with a system of about 2,500 hotels in Vietnam & more than 30,000 international hotels.'),
            ServiceCard(serviceName: 'RULES OF OPERATION', description: 'BrigthStar  is an e-commerce trading floor serving merchants, organizations, and individuals who need to post and sell hotel booking services, tours, tourist vehicles, and airline tickets The mission that Ivivu.com aims for is to become a trusted E-commerce trading platform in the E-commerce market and a commercial bridge between hotel and tourism service providers and members.'),
            ServiceCard(serviceName: 'Privacy Policy', description: 'At BrigthStar we are committed to protecting the privacy and security of personal information (hereinafter referred to as PII) that you provide. Personal information may be your name, address, telephone number or email address.This privacy policy explains how we handle and protect personal information in accordance with the regulations accepted by the Association for the Protection of Personal Information. These policies were revised on March 18, 2011.We are committed to protecting information regardless of changes or amendments to this policy regardless of time and reason. Any changes to the personal information protection policy will be announced in advance before implementation. Any questions please send to the email address info@ivivu.com or send to:'),
            ServiceCard(serviceName: 'CUSTOMER TERMS & CONDITIONS', description: 'We do not provide your credit card details to any room suppliers.Therefore, our supplier may require you to provide the information on the card used to pay for the service and the corresponding cardholder signature. The supplier will request to present your ID card or passport at the time of using the service. A copy of your credit card / ID card or passport may also be retained by the supplier.We will not be liable for any damages, losses, claims or expenses (including but not limited to: direct or indirect consequences of misrepresentation) arising from our website in connection with the products or services listed on this website. We makeno warranties or representations about any accommodation products or services on our website or any linked site. Our responsibility here is to make reservations only. We are not liable for the reason that rooms are not available because the hotel has overbooked.All terms and conditions are recognized by Vietnamese law. We receive payments from member hotels from providing our room reservation services. For any questions, please contact VIVU Company to confirm your reservation via email. For detailed information on how we handle personal information, please refer to our Privacy Policy.'),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String description;

  const ServiceCard({required this.serviceName, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              serviceName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(description),
          ],
        ),
      ),
    );
  }
}
