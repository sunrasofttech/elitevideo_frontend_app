import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite/utils/widgets/custom_no_network.dart';
import 'package:elite/utils/widgets/customcircularprogressbar.dart';

class BlocWithInternetHandler<B extends StateStreamable<S>, S> extends StatelessWidget {
  final Widget Function(BuildContext, S) builder;
  final Widget? loading;
  final void Function(BuildContext, S)? listener;
  final VoidCallback onRetry;

  const BlocWithInternetHandler({
    super.key,
    required this.builder,
    required this.onRetry,
    this.loading,
    this.listener,
  });

  bool _isNoInternet(S state) {
    return state.toString().contains("Check Internet Connection");
  }

  bool _isLoading(S state) {
    return state.toString().toLowerCase().contains("loading");
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      listener: listener ?? (_, __) {},
      builder: (context, state) {
        if (_isLoading(state)) {
          return loading ?? const Center(child: CustomCircularProgressIndicator());
        } else if (_isNoInternet(state)) {
          return NoInternetScreen(onRetry: onRetry);
        } else {
          return builder(context, state);
        }
      },
    );
  }
}
