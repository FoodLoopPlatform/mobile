import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/features/add_product/data/models/expiration_batch.dart';
import 'package:foodloop/features/add_product/data/models/product_draft.dart';
import 'package:foodloop/features/add_product/presentation/views/verification_results_view.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/scanning_body.dart';

/// Arguments for the camera-scan screen.
class ScanningArgs {
  final File image;
  final ProductDraft draft;
  final List<ExpirationBatch> batches;

  const ScanningArgs({
    required this.image,
    required this.draft,
    this.batches = const [],
  });
}

class ScanningView extends StatelessWidget {
  const ScanningView({super.key, required this.args});

  final ScanningArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScanningBody(
        image: args.image,
        // Replaces itself so Back from the results skips the scan screen.
        onFinished: () => Navigator.pushReplacementNamed(
          context,
          RoutesNames.verificationResultsView,
          arguments: VerificationResultsArgs(
            draft: args.draft,
            batches: args.batches,
          ),
        ),
      ),
    );
  }
}
