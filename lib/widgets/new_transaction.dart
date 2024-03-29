import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    String enteredTitle = _titleController.text;
    double enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTransaction(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return FittedBox(
            child: Theme(
              child: child,
              data: ThemeData(
                primaryColor: Colors.purple[400],
              ),
            ),
          );
        }).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      _selectedDate = pickedDate;

      showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return FittedBox(
            child: Theme(
              child: child,
              data: ThemeData(
                primaryColor: Colors.purple[400],
                accentColor: Theme.of(context).accentColor,
              ),
            ),
          );
        },
      ).then((pickedTime) {
        if (pickedTime == null) {
          setState(() {
            _selectedDate = DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day,
                TimeOfDay.now().hour,
                TimeOfDay.now().minute);
          });
        } else {
          setState(() {
            _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
                _selectedDate.day, pickedTime.hour, pickedTime.minute);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 10.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            children: <Widget>[
              TextField(
                cursorColor: Colors.purple,
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                cursorColor: Colors.green,
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : DateFormat('d.M.y H:m').format(_selectedDate)),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: const Text('Choose Date!',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: _presentDatePicker,
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: AdaptiveFlatButton(
                  child: const Text('Choose Date'),
                  onPressed: _presentDatePicker,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
