import 'package:flutter/material.dart';

//A stock trading app in Flutter using the MVVM architecture:

// Model
class Stock {
  final String name;
  final double price;

  Stock({required this.name, required this.price});
}

// View Model
class StockViewModel {
  final List<Stock> stocks;

  StockViewModel({required this.stocks});

  Future<void> buyStock(Stock stock) async {
    // TODO: Implement this method to buy the stock using a remote API or database.
  }

  Future<void> sellStock(Stock stock) async {
    // TODO: Implement this method to sell the stock using a remote API or database.
  }

  // Expose the stock data to the view.
  List<Stock> get stockList {
    return stocks;
  }

  // Handle user interactions such as buying and selling stocks.
  void onBuyStock(Stock stock) async {
    await buyStock(stock);
  }

  void onSellStock(Stock stock) async {
    await sellStock(stock);
  }
}

//View
class StockView extends StatefulWidget {
  final StockViewModel viewModel;

  const StockView({Key? key, required this.viewModel}) : super(key: key);

  @override
  StockViewState createState() => StockViewState();
}

class StockViewState extends State<StockView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Trading'),
      ),
      body: ListView.builder(
        itemCount: widget.viewModel.stockList.length,
        itemBuilder: (context, index) {
          final stock = widget.viewModel.stockList[index];

          return ListTile(
            title: Text(stock.name),
            subtitle: Text(stock.price.toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    widget.viewModel.onBuyStock(stock);
                  },
                  icon: const Icon(
                    Icons.currency_rupee,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    widget.viewModel.onSellStock(stock);
                  },
                  icon: const Icon(Icons.sell),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StockView(
      viewModel: StockViewModel(stocks: []),
    ),
  ));
}
