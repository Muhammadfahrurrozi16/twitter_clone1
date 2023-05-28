import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homeview extends ConsumerWidget {
  static route() => MaterialPageRoute(
    builder:(context)=> const Homeview(),
  );
  const Homeview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold();
    
  }
}