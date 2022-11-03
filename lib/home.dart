import 'package:flutter/material.dart';
import 'package:stockcalculater/models/MyStock.dart';
import 'package:stockcalculater/my-stock-header.dart';
import 'package:stockcalculater/my-text-field.dart';
import 'package:stockcalculater/my-text-form-field.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();

  final buyRateController = TextEditingController();
  final buyQtyController = TextEditingController();
  final tradingRateController = TextEditingController();

  double buyTotal = 0;
  double totalQty = 0;
  double totalBrought = 0;
  double avgPrice = 0;
  double tradingPrice = 0;
  double priceChange = 0;
  

  List<MyStock> myStocks = [];

  @override
  void initState() {
      super.initState();
      buyRateController.addListener(() {
        calculateTotal();
      });

      buyQtyController.addListener(() {
        calculateTotal();
      });

      tradingRateController.addListener(() {
        setState(() {
          if(tradingRateController.text.isNotEmpty) {
            tradingPrice = double.parse(tradingRateController.text);
          }
        });

        calculatePriceChange();
      });
    }

  @override
  void dispose() {
    buyRateController.dispose();
    buyQtyController.dispose();
    tradingRateController.dispose();
    super.dispose();
  }

  addStock(double buyRate, double buyQty) {
    MyStock myStock = MyStock(buyRate, buyQty);
    setState(() {
      myStocks.add(myStock);
      totalQty += myStock.qty;
      totalBrought += myStock.total;
    });
    calculateAvgRate();
    calculatePriceChange();
    this.clearBuyTextFields();
  }

  removeStock(MyStock myStock, int i) {
    setState(() {
      myStocks.removeAt(i);
      totalQty -= myStock.qty;
      totalBrought -= myStock.total;
    });
    calculateAvgRate();
  }

  void calculateAvgRate() {
    setState(() {
      avgPrice = totalBrought > 0 && totalQty > 0 ? totalBrought / totalQty : 0;
    });
  }

  void calculatePriceChange() {
    setState(() {
      double differAmount = tradingPrice - avgPrice;
      setState(() {
        priceChange = ((differAmount / avgPrice) * 100);
      });
    });
  }

  void calculateTotal() {
    if (buyRateController.text.isNotEmpty && buyQtyController.text.isNotEmpty) {
      double buyRate = double.parse(buyRateController.text);
      double buyQty = double.parse(buyQtyController.text);

      setState(() {
        buyTotal = buyRate * buyQty;
      });
    } else {
      setState(() {
        buyTotal = 0;
      });
    }
  }

  clearBuyTextFields() {
    buyRateController.clear();
    buyQtyController.clear();
  }

  double getTotalBuyRate() {
    double total = 0;
    for (MyStock myStock in myStocks) {
      total += myStock.rate;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final fullMediaWidth = MediaQuery.of(context).size.width;
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    final containerWidth = fullMediaWidth > 700 ? halfMediaWidth : fullMediaWidth;
    return Container(
      width: containerWidth,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // heading
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(2.0),
                  width: (containerWidth / 3.5),
                  child: MyStockHeader(content: 'Buying Rate'),
                ),
                Container(
                  padding: EdgeInsets.all(2.0),
                  width: (containerWidth / 3.5),
                  child: MyStockHeader(content: "Buying Quantity"),
                ),
                Container(
                    padding: EdgeInsets.all(2.0),
                    width: (containerWidth / 4.8),
                    child: MyStockHeader(content: "Total")),
                Container(
                  padding: EdgeInsets.all(2.0),
                  width: (containerWidth / 4.8),
                  child: MyStockHeader(content: "Action"),
                )
              ],
            ),
            // brougth stock added row
            Column(children: (() {
              List<Widget> list = [];
              for (var i = 0; i < myStocks.length; i++) {
                MyStock myStock = myStocks[i];

                list.add(Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: (containerWidth / 3.5),
                      child: MyTextField(content: myStock.rate.toString()),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: (containerWidth / 3.5),
                      child: MyTextField(content: myStock.qty.toString()),
                    ),
                    Container(
                        padding: EdgeInsets.all(5.0),
                        width: (containerWidth / 4.8),
                        child: MyTextField(content: myStock.total.toString())),
                    Container(
                        padding: EdgeInsets.all(5.0),
                        width: (containerWidth / 4.8),
                        child: ElevatedButton(
                          child: Icon(Icons.delete),
                          onPressed: () {
                            removeStock(myStock, i);
                          },
                        ))
                  ],
                ));
              }
              return list;
            })()),
            // brought stock new add input row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  width: (containerWidth / 3.5),
                  child: MyTextFormField(
                    hintText: 'Buy Rate',
                    controller: buyRateController,
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: (containerWidth / 3.5),
                  child: MyTextFormField(
                    hintText: 'Buy Quantity',
                    controller: buyQtyController,
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(8.0),
                    width: (containerWidth / 4.8),
                    child: MyTextField(content: buyTotal.toStringAsPrecision(6))
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: (containerWidth / 4.8),
                  child: ElevatedButton(
                    // color: Colors.blue,
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _formKey.currentState.save();
                      if (buyRateController.text.isNotEmpty &&
                          buyQtyController.text.isNotEmpty) {
                        double buyRate = double.parse(buyRateController.text);
                        double buyQty = double.parse(buyQtyController.text);
                        if (buyRate == 0 || buyQty == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Please enter valid buy rate and quantity.')));
                        } else {
                          addStock(buyRate, buyQty);
                        }
                      }
                    },
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.blue,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  width: (containerWidth / 3.5),
                  child: MyTextField(content: '' /*getTotalBuyRate().toString()*/),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  width: (containerWidth / 3.5),
                  child: MyTextField(content: totalQty.toStringAsPrecision(6)),
                ),
                Container(
                    padding: EdgeInsets.all(5.0),
                    width: (containerWidth / 4.8),
                    child: MyTextField(content: totalBrought.toStringAsPrecision(6)))
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: (containerWidth / 2),
                  child: MyStockHeader(content: 'Average Buy Rate'),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: (containerWidth / 3.5),
                  child: MyTextField(content: avgPrice.toStringAsPrecision(6))
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: (containerWidth / 2),
                  child: MyStockHeader(content: 'Current Trading Rate'),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: (containerWidth / 3.5),
                  child: MyTextFormField(
                    hintText: 'Trading Rate',
                    controller: tradingRateController,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: (containerWidth / 2),
                  child: MyStockHeader(content: 'Profite/Loss %'),
                ),
                Container(
                    padding: EdgeInsets.all(8.0),
                    width: (containerWidth / 3.5),
                    child: MyTextField(content: priceChange.toStringAsPrecision(6))
                )
              ],
            )
          ],
        ),
      ),
    );
  }1.
}
