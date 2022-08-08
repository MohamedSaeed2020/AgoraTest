import 'package:agora_test/audio_call.dart';
import 'package:agora_test/video_call.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(150.0),
            child: const Image(
              image:  AssetImage('assets/images/me.jpg'),
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            'Mohamed Saeed',
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(
            '+20 1277364554',
            style: Theme.of(context).textTheme.headline6,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VideoScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.video_call,
                    size: 40,
                    color: Colors.teal,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AudioScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.phone,
                    size: 30,
                  ),
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
