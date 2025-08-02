import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/session_provider.dart';

class PosePreviewScreen extends StatelessWidget {
  const PosePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, session, child) {
        final sequence = session.yogaSession?.sequence ?? [];
        return Scaffold(
          appBar: AppBar(
            title: Text('Pose Preview'),
          ),
          body: ListView.builder(
            itemCount: sequence.length,
            itemBuilder: (context, index) {
              final seqItem = sequence[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: seqItem.script.isNotEmpty
                      ? Image.asset(
                          'assets/images/${session.yogaSession!.assets.images[seqItem.script[0].imageRef]}',
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                        )
                      : null,
                  title: Text(seqItem.name),
                  subtitle: Text('Duration: ${seqItem.durationSec} sec'),
                ),
              );
            },
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/session');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Start Session'),
              ),
          ),
        );
      },
    );
  }
}
