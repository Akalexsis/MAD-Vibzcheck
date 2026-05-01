/*
    Author - Kayla Thornton
    Purpose - Display all of a user's recently created sessions
 */
import 'package:flutter/material.dart';
import '../ui/session_form.dart';

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

    // navigates user to session form to create a new listening session
    void _createSession(BuildContext context) {
        Navigator.push( 
            context,
            MaterialPageRoute( builder: (context) => SessionForm() )
        ); 
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    children: [
                        Text("Home", style: TextStyle( fontSize: 32, )),
                        SizedBox(height: 16),

                        // direct users to form page to create new session
                        ElevatedButton(
                            onPressed: () { _createSession(context); },
                            style: ElevatedButton.styleFrom( 
                                backgroundColor: Colors.purple, 
                                foregroundColor: Colors.white
                            ),
                            child: Icon(Icons.add)
                        ),

                        Text("Recent Sessions", style: TextStyle( fontSize: 24, )),
                    ],
                ),
            ),
        );
    }
}