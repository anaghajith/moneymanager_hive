import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneymanager/controllers/db_helper.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  static final TextInputFormatter digitsOnly =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  int? amount;
  String note = "Some Expense";
  String type = "Income";
  DateTime selectedDate = DateTime.now();

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Future<void> _selectedDate(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021,12),
        lastDate: DateTime(2100,01),
    );
    if(picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
        ),
        backgroundColor: Color(0xffe2e7ef),
        body: ListView(padding: EdgeInsets.all(12), children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Add Transaction",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.attach_money,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "0000",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  onChanged: (value) {
                    try{
                      amount = int.parse(value);
                    }catch(e){}
                  },
                  inputFormatters: [digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.description_outlined,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Note on Transaction",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  onChanged: (val) {
                    note = val;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.moving_sharp,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              ChoiceChip(
                label: Text("Income",style: TextStyle(
                  fontSize: 16,
                  color: type == "Income" ? Colors.white : Colors.black,
                ),),
                selectedColor: Colors.indigo,
                selected: type == "Income" ? true : false,
                onSelected: (value) {
                  setState(() {
                    type = "Income";
                  });
                },
              ),
              SizedBox(
                width: 12,
              ),
              ChoiceChip(
                label: Text("Expense",style: TextStyle(
                  fontSize: 16,
                  color: type == "Expense" ? Colors.white : Colors.black,
                ),),
                selectedColor: Colors.indigo,
                selected: type == "Expense" ? true : false,
                onSelected: (value) {
                  setState(() {
                    type = "Expense";
                  });
                },
              ),            ],
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: TextButton(
              onPressed: () {
                _selectedDate(context);
              },
              style: ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.moving_sharp,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    "${selectedDate.day} ${months[selectedDate.month - 1]}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
               if(amount != null && note.isNotEmpty){
                 DbHelper dbHelper = DbHelper();
                 dbHelper.addData(amount!, selectedDate, note, type);
               }else{
                 print("All values are not provided");
               }
              },
              child: Text(
                "Add",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ]));
  }
}
