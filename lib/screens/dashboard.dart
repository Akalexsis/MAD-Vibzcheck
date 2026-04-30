/*
    Author - Kayla Thornton
    Purpose - Display all of a user's recently created sessions
 */
import 'package:flutter/material.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key,});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

    // get all user sessions after logging in
    @override
    void initState() {
        super.initState();
        // _getSessions();
    }

    // get all user sessions after logging in
    Future<void> _getSessions() async {
        try {

        } catch (error) {

        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Home", style: TextStyle( fontSize: 32, color: Colors.white )),
                backgroundColor: Colors.black,
            ),
            body: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    children: [
                        Text("Recent Sessions", style: TextStyle( fontSize: 24, )),
                    ],
                ),
            ),
        );
    }
}