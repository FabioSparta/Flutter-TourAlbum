import 'package:flutter/material.dart';

// This is the main application widget.
class GalleryTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _Gallery();
}

class GridLayout {
  final String title;
  final IconData icon;

  GridLayout({this.title, this.icon});
}

class GridOptions extends StatelessWidget {
  final GridLayout layout;
  GridOptions({this.layout});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              layout.icon,
              size: 40,
            ),
            Text(
              layout.title,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Gallery extends State<GalleryTab> {
  List<GridLayout> options = [
    GridLayout(title: 'Home', icon: Icons.home),
    GridLayout(title: 'Email', icon: Icons.email),
    GridLayout(title: 'Alarm', icon: Icons.access_alarm),
    GridLayout(title: 'Wallet', icon: Icons.account_balance_wallet),
    GridLayout(title: 'Backup', icon: Icons.backup),
    GridLayout(title: 'Book', icon: Icons.book),
    GridLayout(title: 'Camera', icon: Icons.camera_alt_rounded),
    GridLayout(title: 'Person', icon: Icons.person),
    GridLayout(title: 'Print', icon: Icons.print),
    GridLayout(title: 'Phone', icon: Icons.phone),
    GridLayout(title: 'Notes', icon: Icons.speaker_notes),
    GridLayout(title: 'Music', icon: Icons.music_note_rounded),
    GridLayout(title: 'Car', icon: Icons.directions_car),
    GridLayout(title: 'Bicycle', icon: Icons.directions_bike),
    GridLayout(title: 'Boat', icon: Icons.directions_boat),
    GridLayout(title: 'Bus', icon: Icons.directions_bus),
    GridLayout(title: 'Train', icon: Icons.directions_railway),
    GridLayout(title: 'Walk', icon: Icons.directions_walk),
    GridLayout(title: 'Contact', icon: Icons.contact_mail),
    GridLayout(title: 'Duo', icon: Icons.duo),
    GridLayout(title: 'Hour', icon: Icons.hourglass_bottom),
    GridLayout(title: 'Mobile', icon: Icons.mobile_friendly),
    GridLayout(title: 'Message', icon: Icons.message),
    GridLayout(title: 'Key', icon: Icons.vpn_key),
    GridLayout(title: 'Wifi', icon: Icons.wifi),
    GridLayout(title: 'Bluetooth', icon: Icons.bluetooth),
    GridLayout(title: 'Smile', icon: Icons.sentiment_satisfied),
    GridLayout(title: 'QR', icon: Icons.qr_code),
    GridLayout(title: 'ADD', icon: Icons.add_box),
    GridLayout(title: 'Link', icon: Icons.link),
  ];

  Widget buildPhotos() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: List.generate(
        options.length,
        (index) => GridOptions(
          layout: options[index],
        ),
      ), //Here go the photos
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: buildPhotos(),
      ),
    );
  }
}
