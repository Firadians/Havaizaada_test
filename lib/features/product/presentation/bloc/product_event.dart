part of 'product_bloc.dart';

abstract class ProductEvent {}

class FetchProducts extends ProductEvent {
  final int page;
  FetchProducts({required this.page});
}

class AddToCart extends ProductEvent {
  final Map<String, dynamic> product;
  AddToCart(this.product);
}

class RemoveFromCart extends ProductEvent {
  final Map<String, dynamic> product;
  RemoveFromCart(this.product);
}
