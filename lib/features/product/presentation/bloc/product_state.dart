part of 'product_bloc.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List products;
  final List cart;
  ProductLoaded({required this.products, required this.cart});
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
