import 'package:flutter/material.dart';
import 'expense.dart';
import 'ExpenseListModel.dart';

class FormPage extends StatefulWidget {
  FormPage({Key key, this.id, this.expenses}) : super(key: key);
  final int id;
  final ExpenseListModel expenses;

  @override _FormPageState createState() => _FormPageState(id: id, expenses: expenses);
}
class _FormPageState extends State<FormPage> {
  _FormPageState({Key key, this.id, this.expenses});

  final int id;
  final ExpenseListModel expenses;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  double _amount;
  DateTime _date;
  String _category;

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      if (this.id == 0) expenses.add(Expense(0, _amount, _date, _category));
      else expenses.update(Expense(this.id, _amount, _date, _category));
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, appBar: AppBar(
      title: Text('Enter expense details'),
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey, child: Column(
          children: [
            TextFormField(
              style: TextStyle(fontSize: 22),
              decoration: const InputDecoration(
                  icon: const Icon(Icons.monetization_on),
                  labelText: 'Amount (Rupiah)',
                  labelStyle: TextStyle(fontSize: 18)
              ),
              validator: (val) {
                Pattern pattern = r'^[1-9]\d*(\.\d+)?$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(val))
                  return 'Enter a valid number'; else return null;
              },
              initialValue: id == 0
                  ? '' : expenses.byId(id).amount.toString(),
              onSaved: (val) => _amount = double.parse(val),
            ),
            TextFormField(
              style: TextStyle(fontSize: 22),
              decoration: const InputDecoration(
                icon: const Icon(Icons.calendar_today),
                hintText: 'Enter date',
                labelText: 'Date (yyyy-mm-dd)',
                labelStyle: TextStyle(fontSize: 18),
              ),
              validator: (val) {
                Pattern pattern = r'^((?:19|20)\d\d)[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(val))
                return 'Enter a valid date';
                else return null;
              },
              onSaved: (val) => _date = DateTime.parse(val),
              initialValue: id == 0
                  ? '' : expenses.byId(id).formattedDate,
              keyboardType: TextInputType.datetime,
            ),
            TextFormField(
              style: TextStyle(fontSize: 22),
              decoration: const InputDecoration(
                  icon: const Icon(Icons.category),
                  labelText: 'Category',
                  labelStyle: TextStyle(fontSize: 18)
              ),
              onSaved: (val) => _category = val,
              initialValue: id == 0 ? ''
                  : expenses.byId(id).category.toString(),
            ),
            RaisedButton(
              color: Colors.teal,
              onPressed: _submit,
              child: new Text('Submit',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
        ),
      ),
    );
  }
}