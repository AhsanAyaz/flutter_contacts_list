import 'package:contacts_app/app-contact.class.dart';
import 'package:contacts_app/components/contact-avatar.dart';
import 'package:flutter/material.dart';

class ContactDetails extends StatefulWidget {
  ContactDetails(this.contact, {this.onContactUpdate, this.onContactDelete});

  final AppContact contact;
  final Function(AppContact) onContactUpdate;
  final Function(AppContact) onContactDelete;
  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 180,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Center(child: ContactAvatar(widget.contact, 100)),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    alignment: Alignment.topLeft,
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(shrinkWrap: true, children: <Widget>[
                ListTile(
                  title: Text("Name"),
                  trailing: Text(widget.contact.info.givenName ?? ""),
                ),
                ListTile(
                  title: Text("Family name"),
                  trailing: Text(widget.contact.info.familyName ?? ""),
                ),
                Column(
                  children: <Widget>[
                    ListTile(title: Text("Phones")),
                    Column(
                      children: widget.contact.info.phones
                        .map(
                          (i) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ListTile(
                              title: Text(i.label ?? ""),
                              trailing: Text(i.value ?? ""),
                            ),
                          ),
                        )
                        .toList(),
                    )
                  ],
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
