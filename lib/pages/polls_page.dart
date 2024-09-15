import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PollOption {
  String optionId;
  String option;
  int value;

  PollOption(
      {required this.optionId, required this.option, required this.value});
}

class PollsPage extends StatefulWidget {
  const PollsPage({super.key});

  @override
  State<PollsPage> createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  final databaseReference = FirebaseDatabase.instance.ref();
  List<PollOption> pollOptions = [];
  Map<String, int> votes = {};

  @override
  void initState() {
    super.initState();
    databaseReference.child('polls').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<String, dynamic> pollData = snapshot.value as Map<String, dynamic>;
        pollData.forEach((key, value) {
          pollOptions.add(PollOption(
            optionId: key,
            option: value['option'],
            value: value['votes'],
          ));
          votes[key] = value['votes'];
        });
        setState(() {});
      }
    });
  }

  void _voteForOption(String optionId) {
    databaseReference
        .child('polls')
        .child(optionId)
        .runTransaction((Object? transaction) {
      if (transaction != null) {
        // Assuming transaction is a Map<String, dynamic>
        Map<String, dynamic> currentData =
            Map<String, dynamic>.from(transaction as Map);
        int currentVotes = currentData['votes'] ?? 0;
        currentData['votes'] = currentVotes + 1;
        return Transaction.success(currentData);
      } else {
        // If transaction is null, set the initial vote count to 1
        Map<String, dynamic> newData = {'votes': 1};
        return Transaction.success(newData);
      }
    }).then((transactionResult) {
      if (transactionResult.committed) {
        setState(() {
          votes[optionId] = (votes[optionId] ?? 0) + 1;
        });
      }
    }).catchError((error) {
      // Handle any error that occurs during the transaction
      print('Transaction failed: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polls'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: pollOptions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(pollOptions[index].option),
                  trailing: Text('${pollOptions[index].value} votes'),
                  onTap: () {
                    _voteForOption(pollOptions[index].optionId);
                  },
                );
              },
            ),
          ),
          Text('Total votes: ${votes.isNotEmpty ? votes.values.reduce((a, b) => a + b) : 0}'),
        ],
      ),
    );
  }
}
