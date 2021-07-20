import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'expense.dart';
import 'FormPage.dart';
import 'ExpenseListModel.dart';

void main() {
  final expenses = ExpenseListModel();
  runApp(
      ScopedModel<ExpenseListModel>(
        model: expenses, child: MyApp(),
      )
  );
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiranus Tegar - Expense Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Expense Calculator'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.title),
        ),
        body: ScopedModelDescendant<ExpenseListModel>(
          builder: (context, child, expenses) {
            return ListView.separated(
              itemCount: expenses.items == null ? 1
                  : expenses.items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                      title: Text("Total Expenses: "
                          + expenses.totalExpense.toString(),
                        style: TextStyle(fontSize: 22, color: Colors.black,
                            fontWeight: FontWeight.w400),)
                  );
                } else {
                  index = index - 1;
                  return Dismissible(
                      key: Key(expenses.items[index].id.toString()),
                      onDismissed: (direction) {
                        expenses.delete(expenses.items[index]);
                        Scaffold.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Item with ID, "
                                        + expenses.items[index].id.toString() +
                                        "is dismissed"
                                )
                            )
                        );
                      },
                      child: ListTile( onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => FormPage(
                              id: expenses.items[index].id,
                              expenses: expenses,
                            )
                        )
                        );
                      },
                          leading: Icon(Icons.monetization_on,color: Colors.primaries[Random().nextInt(Colors.primaries.length)],),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          title: Text(expenses.items[index].category + ": " +
                              expenses.items[index].amount.toString() +
                              " \nSpent on " + expenses.items[index].formattedDate,
                            style: TextStyle(fontSize: 18, fontStyle: FontStyle.normal),))
                  );
                }
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            );
          },
        ),
        floatingActionButton: ScopedModelDescendant<ExpenseListModel>(
            builder: (context, child, expenses) {
              return FloatingActionButton( onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => ScopedModelDescendant<ExpenseListModel>(
                        builder: (context, child, expenses) {
                          return FormPage( id: 0, expenses: expenses, );
                        }
                    )
                )
                );
                // expenses.add(new Expense(
                // 2, 1000, DateTime.parse('2019-04-01 11:00:00'), 'Food')
                //);
                // print(expenses.items.length);
              },
                tooltip: 'Increment', child: Icon(Icons.add), );
            }
        )
    );
  }
}