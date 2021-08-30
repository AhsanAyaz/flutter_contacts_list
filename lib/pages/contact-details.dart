import 'package:contacts_app/app-contact.class.dart';
import 'package:contacts_app/components/contact-avatar.dart';
import 'package:contacts_service/contacts_service.dart';
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
    List<String> actions = <String>[
      'Edit',
      'Delete'
    ];

    showDeleteConfirmation() {
      Widget cancelButton = FlatButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget deleteButton = FlatButton(
        color: Colors.red,
        child: Text('Delete'),
        onPressed: () async {
          await ContactsService.deleteContact(widget.contact.info);
          widget.onContactDelete(widget.contact);
          Navigator.of(context).pop();
        },
      );
      AlertDialog alert= AlertDialog(
        title: Text('Delete contact?'),
        content: Text('Are you sure you want to delete this contact?'),
        actions: <Widget>[
          cancelButton,
          deleteButton
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        }
      );

    }

    onAction(String action) async {
      switch(action) {
        case 'Edit':
          try {
            Contact updatedContact = await ContactsService.openExistingContact(widget.contact.info);
            setState(() {
              widget.contact.info = updatedContact;
            });
            widget.onContactUpdate(widget.contact);
          } on FormOperationException catch (e) {
            switch(e.errorCode) {
              case FormOperationErrorCode.FORM_OPERATION_CANCELED:
              case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
              case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                print(e.toString());
            }
          }
          break;
        case 'Delete':
          showDeleteConfirmation();
          break;
      }
      print(action);
    }

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
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PopupMenuButton(
                        onSelected: onAction,
                        itemBuilder: (BuildContext context) {
                          return actions.map((String action) {
                            return PopupMenuItem(
                              value: action,
                              child: Text(action),
                            );
                          }).toList();
                        },
                      ),
                    ),
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
