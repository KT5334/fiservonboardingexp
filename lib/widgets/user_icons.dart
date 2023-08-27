import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiservonboardingexp/screens/nav_app_overlay.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserIcon extends StatefulWidget {
  final Icon initialUserIcon;
  final void Function(Icon) onIconChanged;
  final CollectionReference userCollection;
  final String userId;
  final Map<String, dynamic> userData;
  final Color iconColor;

  const UserIcon({
    required this.initialUserIcon,
    required this.onIconChanged,
    required this.userCollection,
    required this.userId,
    required this.userData,
    required this.iconColor,
  });

  @override
  _UserIconState createState() => _UserIconState();
}

class _UserIconState extends State<UserIcon> {
  late Icon userIcon;
  late Color iconColor;

  @override
  void initState() {
    super.initState();
    userIcon = widget.initialUserIcon;
    iconColor = widget.iconColor;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.initialUserIcon,
      color: widget.iconColor,
      iconSize: 70,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Widget customContent = Column(
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20.0,
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.ghost),
                      iconSize: 55,
                      color: Colors.black87,
                      onPressed: () async {
                        setState(() {
                          userIcon = const Icon(FontAwesomeIcons.ghost);
                        });
                        Navigator.of(context).pop();
                        await widget.userCollection.doc(widget.userId).update({
                          'selectedIcon': 'ghost',
                          'iconColor': '#1f1f1f',
                        });
                        widget.onIconChanged(userIcon);
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.seedling),
                      iconSize: 55,
                      color: Colors.lightGreen,
                      onPressed: () async {
                        setState(() {
                          userIcon = const Icon(FontAwesomeIcons.seedling);
                        });
                        Navigator.of(context).pop();
                        await widget.userCollection.doc(widget.userId).update({
                          'selectedIcon': 'seedling',
                          'iconColor': '#8fd94e'
                        });
                        widget.onIconChanged(userIcon);
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.poo),
                      iconSize: 55,
                      color: const Color.fromARGB(255, 58, 33, 23),
                      onPressed: () async {
                        setState(() {
                          userIcon = const Icon(FontAwesomeIcons.poo);
                        });
                        Navigator.of(context).pop();
                        await widget.userCollection.doc(widget.userId).update(
                            {'selectedIcon': 'poo', 'iconColor': '#402408'});
                        widget.onIconChanged(userIcon);
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.fish),
                      iconSize: 55,
                      color: Colors.amberAccent,
                      onPressed: () async {
                        setState(() {
                          userIcon = const Icon(FontAwesomeIcons.fish);
                        });
                        Navigator.of(context).pop();
                        await widget.userCollection.doc(widget.userId).update(
                            {'selectedIcon': 'fish', 'iconColor': '#ffbb00'});
                        widget.onIconChanged(userIcon);
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.userNinja),
                      iconSize: 55,
                      color: Colors.black,
                      onPressed: () async {
                        setState(() {
                          userIcon = const Icon(FontAwesomeIcons.userNinja);
                        });
                        Navigator.of(context).pop();
                        await widget.userCollection.doc(widget.userId).update({
                          'selectedIcon': 'userNinja',
                          'iconColor': '#000000'
                        });
                        widget.onIconChanged(userIcon);
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.dog),
                      iconSize: 55,
                      color: Colors.brown,
                      onPressed: () async {
                        setState(() {
                          userIcon = const Icon(FontAwesomeIcons.dog);
                        });
                        Navigator.of(context).pop();
                        await widget.userCollection.doc(widget.userId).update(
                            {'selectedIcon': 'dog', 'iconColor': '#a16e3b'});
                        widget.onIconChanged(userIcon);
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.cat),
                      iconSize: 55,
                      color: Colors.orangeAccent,
                      onPressed: () async {
                        setState(() {
                          userIcon = const Icon(FontAwesomeIcons.cat);
                        });
                        Navigator.of(context).pop();
                        await widget.userCollection.doc(widget.userId).update(
                            {'selectedIcon': 'cat', 'iconColor': '#ffa41c'});
                        widget.onIconChanged(userIcon);
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.frog),
                      iconSize: 55,
                      color: Colors.green[700],
                      onPressed: () async {
                        setState(() {
                          userIcon = const Icon(FontAwesomeIcons.frog);
                        });
                        Navigator.of(context).pop();
                        await widget.userCollection.doc(widget.userId).update(
                            {'selectedIcon': 'frog', 'iconColor': '#11801c'});
                        widget.onIconChanged(userIcon);
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.robot),
                      iconSize: 55,
                      color: Colors.grey[800],
                      onPressed: () async {
                        setState(() {
                          userIcon = const Icon(FontAwesomeIcons.robot);
                        });
                        Navigator.of(context).pop();
                        await widget.userCollection.doc(widget.userId).update(
                            {'selectedIcon': 'robot', 'iconColor': '#333333'});
                        widget.onIconChanged(userIcon);
                      },
                    ),
                  ],
                ),
              ],
            );

            return Center(
              child: SizedBox(
                width: 400,
                height: 450,
                child: AlertDialog(
                  title: const Text('My Icons', textAlign: TextAlign.center),
                  content: customContent,
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6600),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
