import 'package:flutter/material.dart';

/// 簡易 stub，用於流程銜接
class ProposalPage extends StatelessWidget {
  const ProposalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Proposal')),
      body: const Center(child: Text('Proposal Page')),
    );
  }
}