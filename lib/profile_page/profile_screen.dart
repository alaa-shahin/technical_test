import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/providers/users.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/ProfileScreen';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Users>(context, listen: false).getUser(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Sorry, Something went wrong!\n But We're working on it.\n\nIf the issue still persists please contact us at alaashahin743@gmail.com",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            backgroundColor: Colors.white,
          );
        }
        List docs = snapshot.data;
        var user = docs[0];
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile Page'),
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user['image']),
                    maxRadius: 50,
                    backgroundColor: Colors.orange,
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'First Name',
                    ),
                    readOnly: true,
                    initialValue: user['firstName'],
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                    ),
                    readOnly: true,
                    initialValue: user['lastName'],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'City',
                    ),
                    readOnly: true,
                    initialValue: user['city'],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Bio',
                    ),
                    readOnly: true,
                    initialValue: user['bio'],
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
