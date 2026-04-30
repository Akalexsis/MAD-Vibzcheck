/*
    Author - Kayla Thornton
    Purpose - Capture session data and save it to database
 */
import 'package:flutter/material.dart';


class SessionForm extends StatefulWidget {
  const SessionForm({super.key,});

  @override
  State<SessionForm> createState() => _SessionFormState();
}

class _SessionFormState extends State<SessionForm> {
    // initialize model and service

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: 
            Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    children: [
                        Text("New Listening Session", style: TextStyle( fontSize: 32, )),
                    ],
                ),
            ),
        );
    }
}