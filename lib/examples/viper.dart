import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Entity
class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

// View
class ProductCatalogView extends StatelessWidget {
  const ProductCatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ProductCatalogPresenter>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
      ),
      body: Consumer<List<Product>>(
        builder: (context, products, child) {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.price.toString()),
                trailing: IconButton(
                  onPressed: () {
                    presenter.addToCart(product);
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          presenter.navigateToCart();
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

// Interactor
class ProductCatalogInteractor {
  final ProductRepository repository;

  ProductCatalogInteractor({required this.repository});

  Future<List<Product>> getProducts() async {
    return repository.getProducts();
  }

  void addToCart(Product product) {
    repository.addToCart(product);
  }
}

// Presenter
class ProductCatalogPresenter with ChangeNotifier {
  final ProductCatalogInteractor interactor;
  final ProductCatalogRouter router;
  List<Product> products = [];

  ProductCatalogPresenter({
    required this.interactor,
    required this.router,
  });

  Future<List<Product>> getProducts() async {
    products = await interactor.getProducts();
    notifyListeners(); // Notify listeners to update the UI
    return products;
  }

  void addToCart(Product product) {
    interactor.addToCart(product);
  }

  void navigateToCart() {
    router.navigateToCart();
  }
}

// Repository
class ProductRepository {
  Future<List<Product>> getProducts() async {
    // TODO: Implement this method to get the product data from a remote API or database.
    return [Product(id: 001, name: "ABC", price: 100)];
  }

  void addToCart(Product product) {
    // TODO: Implement this method to add the product to the cart.
  }
}

// Router
class ProductCatalogRouter {
  final ProductCatalogInteractor interactor;

  ProductCatalogRouter({required this.interactor});

  void navigateToCart() {
    // TODO: Implement this method to navigate to the cart screen.
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductCatalogPresenter(
            interactor: ProductCatalogInteractor(
              repository: ProductRepository(),
            ),
            router: ProductCatalogRouter(
              interactor: ProductCatalogInteractor(
                repository: ProductRepository(),
              ),
            ),
          ),
        ),
        FutureProvider<List<Product>>(
          initialData: const [],
          create: (context) {
            final presenter = Provider.of<ProductCatalogPresenter>(context);
            return presenter.getProducts();
          },
        ),
      ],
      child: const MaterialApp(
        home: ProductCatalogView(),
      ),
    ),
  );
}
