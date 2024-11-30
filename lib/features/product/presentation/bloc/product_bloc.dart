import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'product_event.dart';
part 'product_state.dart';

class UpdateCartQuantity extends ProductEvent {
  final Map<String, dynamic> product;
  final int quantity;

  UpdateCartQuantity(this.product, this.quantity);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  List _products = [];
  List _cart = [];

  ProductBloc() : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final response = await http.get(Uri.parse(
            'https://dummyjson.com/products?limit=10&skip=${(event.page - 1) * 10}'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          _products.addAll(data['products']);
          emit(ProductLoaded(products: _products, cart: _cart));
        } else {
          emit(ProductError('Failed to fetch products.'));
        }
      } catch (e) {
        emit(ProductError('Something went wrong.'));
      }
    });

    on<AddToCart>((event, emit) {
      _cart.add(event.product);
      emit(ProductLoaded(products: _products, cart: _cart));
    });
    on<RemoveFromCart>((event, emit) {
      _cart.remove(event.product);
      emit(ProductLoaded(products: _products, cart: _cart));
    });
    on<UpdateCartQuantity>((event, emit) {
      // Find the product in the cart and update its quantity
      final productIndex =
          _cart.indexWhere((item) => item['id'] == event.product['id']);
      if (productIndex != -1) {
        // Update the quantity of the product
        if (event.quantity == 0) {
          _cart.removeAt(productIndex); // Remove item if quantity is 0
        } else {
          _cart[productIndex]['quantity'] = event.quantity;
        }
      }
      // Emit updated cart state
      emit(ProductLoaded(products: _products, cart: _cart));
    });
  }
}
