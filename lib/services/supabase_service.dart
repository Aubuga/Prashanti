import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyTablePage extends StatefulWidget {
  const MyTablePage({Key? key}) : super(key: key);

  @override
  State<MyTablePage> createState() => _MyTablePageState();
}

class _MyTablePageState extends State<MyTablePage> {
  final supabase = Supabase.instance.client;
  List<dynamic> rows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await supabase
          .from('products') // replace with your table name
          .select();

      setState(() {
        rows = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Supabase Data products')),
      body: ListView.builder(
        itemCount: rows.length,
        itemBuilder: (context, index) {
          final row = rows[index];
          return ListTile(
            title: Text(row['name'] ?? 'No name'),
            subtitle: Text(row['description'] ?? ''),
          );
        },
      ),
    );
  }
}
