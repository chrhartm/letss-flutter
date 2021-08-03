import 'package:flutter/material.dart';

class EmailForm extends StatefulWidget {
  const EmailForm({Key? key}) : super(key: key);

  @override
  EmailFormState createState() {
    return EmailFormState();
  }
}

class EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email address';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Next'),
              style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor,
                    textStyle: Theme.of(context).textTheme.button,
                    minimumSize: Size(double.infinity, 40)
                  ),
            ),
          ),
        ],
      ),
    );
  }
}