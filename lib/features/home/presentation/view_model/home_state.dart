import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:orenda/features/home/presentation/view/bottom_view/cart_view.dart';
import 'package:orenda/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:orenda/features/home/presentation/view/bottom_view/menu_view.dart';
import 'package:orenda/features/home/presentation/view/bottom_view/order_view.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({
    required this.selectedIndex,
    required this.views,
  });

  static HomeState initial() {
    return HomeState(
      selectedIndex: 1,
      views: [
        const Center(
          child: DashboardView(),
        ),
        const Center(
          child: MenuView(),
        ),
        const Center(
          child: CartView(),
        ),
        const Center(
          child: OrderView(),
        ),
      ],
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, views];
}
