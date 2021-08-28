import 'dart:io';

import 'package:contact/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final _nameFocus = FocusNode();

  bool _userEditted = false;

  Contact? _editedContact;

  @override
  void initState() {
    super.initState();
    print(widget.contact);
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());

      if (_editedContact?.name != null) {
        _nameController.text = _editedContact?.name as String;
      }

      if (_editedContact?.email != null) {
        _emailController.text = _editedContact?.email as String;
      }

      if (_editedContact?.phone != null) {
        _phoneController.text = _editedContact?.phone as String;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedContact?.name ?? "Novo Contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedContact!.name != null &&
                  _editedContact!.name!.isNotEmpty) {
                Navigator.pop(context, _editedContact);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedContact?.img != null
                                ? FileImage(File(_editedContact?.img as String))
                                : AssetImage("images/person.png")
                                    as ImageProvider,
                        fit: BoxFit.cover),
                      ),
                    ),
                    onTap: () {
                      _picker.pickImage(
                          source: ImageSource.camera
                      ).then((file) {
                        if(file == null) return;
                        setState(() {
                          _editedContact?.img = file.path;
                        });
                      });
                    },
                  ),
                  TextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    decoration: InputDecoration(labelText: "Nome"),
                    onChanged: (text) {
                      _userEditted = true;
                      setState(() {
                        _editedContact?.name = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    onChanged: (text) {
                      _userEditted = true;
                      _editedContact?.email = text;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: "Phone"),
                    onChanged: (text) {
                      _userEditted = true;
                      _editedContact?.phone = text;
                    },
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ))),
      onWillPop: _requestPop,
    );
  }

  Future<bool> _requestPop() {
    if (_userEditted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Descartar Alterações?"),
            content: Text("Se sair as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
