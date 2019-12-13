import 'package:find_rooms_app/model/User.dart';
import 'package:find_rooms_app/until/database.dart';
import 'package:find_rooms_app/widgets/ButtonCustom.dart';
import 'package:find_rooms_app/widgets/UpdateUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class EditInformation extends StatefulWidget {
  static String title = "/editInformation";
  @override
  _EditInformationState createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformation> {
  TextEditingController fullNameController;
  TextEditingController phoneNumberController;
  TextEditingController addressController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool gender = true;
  User user;

  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
    fullNameController = TextEditingController();
    addressController = TextEditingController();
    _currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.back),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(32, 35, 48, 1),
        padding: EdgeInsets.only(top: 50, bottom: 30),
        child: ListView(
          children: <Widget>[
            UpdateUser(
              title: "Fullname:",
              controller: fullNameController,
              placeholder: user != null ? user.fullName : "Fullname",
            ),
            UpdateUser(
              title: "Address:",
              controller: addressController,
              placeholder: user != null ? user.address : "Address",
            ),
            UpdateUser(
              title: "Phone number:",
              controller: phoneNumberController,
              placeholder: user != null ? user.phoneNumber : "Phone number",
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: 70,
                  child: Text(
                    "Birthday:",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 46,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      border: Border.all(
                        style: BorderStyle.solid,
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: MaterialButton(
                      height: 46,
                      onPressed: _getDatePicker,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          user != null && user.birthday != null
                              ? user.birthday
                              : "Birthday",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 70,
                    child: Text(
                      "Gender:",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    child: Row(children: <Widget>[
                      Container(
                        child: Radio(
                          value: true,
                          groupValue: (user != null && user.gender != null)
                              ? user.gender
                              : gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                              user.gender = gender;
                              print(user.gender);
                            });
                          },
                        ),
                      ),
                      Text(
                        "Male",
                        style: TextStyle(fontSize: 14),
                      ),
                    ]),
                  ),
                  Container(
                    width: 145,
                    child: ListTile(
                      leading: Radio(
                        value: false,
                        groupValue: (user != null && user.gender != null)
                            ? user.gender
                            : gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                            user.gender = gender;
                            print(user.gender);
                          });
                        },
                      ),
                      title: Text(
                        "Female",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: ButtonCustom(
                title: "Update",
                onPressed: _updateInformation,
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }

  _dateToString(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date).toString();
  }

  _getDatePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1998),
        maxTime: DateTime(2200),
        currentTime: DateTime.now(),
        locale: LocaleType.en, onChanged: (date) {
      setState(() {
        user.birthday = _dateToString(date);
      });
    }, onConfirm: (date) {
      setState(() {
        user.birthday = _dateToString(date);
      });
    });
  }

  _currentUser() async {
    await DatabaseHelper.getCurrentUser((userRes) {
      setState(() {
        user = userRes;
        print(user.uid);
      });
    });
  }

  _updateInformation() async {
    if (user == null) {
      return;
    }
    await DatabaseHelper.updateInformation(user, context);
  }
}
