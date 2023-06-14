import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTwetScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
    builder:(context)=> const CreateTwetScreen(),
  );
  const CreateTwetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateTwetScreenState();
}

class _CreateTwetScreenState extends ConsumerState<CreateTwetScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){},
          icon: const Icon(Icons.close,size: 30,),
        ),
      ),
    );
  }
}