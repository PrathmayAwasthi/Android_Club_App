import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchEmail(String email) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (!await launchUrl(emailUri)) {
      throw 'Could not send email to $email';
    }
  }

  Widget buildMember({
    required String name,
    required String position,
    required String bio,
    String? email,
    String? linkedIn,
    String? gitHub,
    String? profilePicture,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: profilePicture != null
                        ? AssetImage(profilePicture)
                        : const AssetImage('assets/images/default_profile.png')
                    as ImageProvider,
                    backgroundColor: Colors.grey.shade200, // Fallback color
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        position,
                        style: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                bio,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (email != null)
                    GestureDetector(
                      onTap: () {
                        _launchEmail(email);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/google_logo.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  if (gitHub != null)
                    GestureDetector(
                      onTap: () {
                        _launchUrl('https://github.com/$gitHub');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/github_logo.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  if (linkedIn != null)
                    GestureDetector(
                      onTap: () {
                        _launchUrl('https://linkedin.com/in/$linkedIn');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/linkedin_logo.jpg',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to the Android Club',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Where innovation meets exploration!',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Established in 2019 by visionary founder xyz, our club has been a hub for Android enthusiasts and tech aficionados alike.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'At Android Club Vit Bhopal, we don\'t just follow trends; we set them. Through immersive workshops, cutting-edge seminars, and collaborative projects, we empower our members to explore the limitless possibilities of Android development. From crafting sleek UI designs to mastering the intricacies of app development, we thrive on creativity and innovation.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Club Members',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),

              // Admin Members
              buildMember(
                name: 'Harsh Raj',
                position: 'Club President',
                bio:
                'The heart and soul of our Android Club. As president, he exemplifies unparalleled leadership and dedication. With a knack for tackling both technical challenges and life’s hurdles, Harsh is the go-to person for all things Android and beyond.',
                email: 'harshraj@example.com',
                linkedIn: 'https://www.linkedin.com/in/harsh-raj-51475021b/',
                gitHub: 'harshraj',
                profilePicture: 'assets/images/HarshRaj.jpg',
              ),
              buildMember(
                name: 'Giriraj Pradeep Parsewar',
                position: 'Vice President',
                bio:
                'Introducing Giriraj Pradeep Parsewar our Vice President and a cornerstone of the Android Club. With a blend of technical expertise and strategic thinking, he seamlessly supports the president while driving forward the club\'s initiatives.',
                email: 'girirajpradeep@example.com',
                linkedIn: 'girirajpradeep',
                gitHub: 'girirajpradeep',
                profilePicture: 'assets/images/Giriraj.jpg',
              ),
              buildMember(
                name: 'Avyaan Verma',
                position: 'General Secretary',
                bio:
                'Say hello to Avyaan Verma, the General Secretary of our Android Club. Avyaan’s exceptional communication skills and organizational prowess keep the club connected and informed.',
                email: 'avyaanverma@example.com',
                linkedIn: 'avyaanverma',
                gitHub: 'avyaanverma',
                profilePicture: 'assets/images/Avyaan.jpg',
              ),

              const Divider(),

              // Executive Board Members
              buildMember(
                name: 'Antareep Dey',
                position: 'Operations Lead',
                bio:
                'The backbone of our logistical and operational success. Antareep’s meticulous planning and exceptional problem-solving skills keep the club running like a well-oiled machine.',
                email: 'antareepdey@example.com',
                linkedIn: 'antareepdey',
                gitHub: 'antareepdey',
                profilePicture:
                'assets/images/AntareepDey_operations_lead.png',
              ),
              buildMember(
                name: 'Samriddhi Tripathi',
                position: 'Operations Manager',
                bio:
                'Excelling as our Operations Manager, Samriddhi manages the day-to-day operations with precision and care. Her proactive approach ensures that everything runs seamlessly.',
                email: 'samriddhitripathi@example.com',
                linkedIn: 'samriddhitripathi',
                gitHub: 'samriddhitripathi',
                profilePicture: 'assets/images/Samriddhi Tripathi.jpg',
              ),
              buildMember(
                name: 'Arrohi Srivastava',
                position: 'Tech Lead',
                bio:
                'At the helm of our technical endeavours, Arrohi leads the Technical Department of our Club. She constantly pushes the boundaries of what’s possible in Android development.',
                email: 'arrohisrivastava@example.com',
                linkedIn: 'arrohisrivastava',
                gitHub: 'arrohisrivastava',
                profilePicture: 'assets/images/Arrohi Srivastava.jpg',
              ),
              buildMember(
                name: 'Sparsh Tiwari',
                position: 'Tech Co-lead',
                bio:
                'A dynamic individual whose technical acumen and collaborative spirit make Sparsh an invaluable part of our club. He brings fresh perspectives and creative solutions.',
                email: 'sparshtiwari@example.com',
                linkedIn: 'sparshtiwari',
                gitHub: 'sparshtiwari',
                profilePicture: 'assets/images/Sparsh Tiwari.jpg',
              ),
              buildMember(
                name: 'Swastik Nanda',
                position: 'Non-Tech Lead',
                bio:
                'Introducing Swastik Nanda, our Non-Tech Lead, the creative force behind the Android Club’s non-technical initiatives. His exceptional organizational skills drive non-tech projects.',
                email: 'swastiknanda@example.com',
                linkedIn: 'swastiknanda',
                gitHub: 'swastiknanda',
                profilePicture: 'assets/images/Swastik Nanda.jpg',
              ),
              buildMember(
                name: 'Disha Gupta',
                position: 'Non-Tech Co-lead',
                bio:
                'With a talent for multitasking and creativity, Disha supports the Non-Tech Lead in executing non-technical operations. Her innovative ideas make her an essential part of the team.',
                email: 'dishagupta@example.com',
                linkedIn: 'dishagupta',
                gitHub: 'dishagupta',
                profilePicture: 'assets/images/Disha Gupta.jpg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
