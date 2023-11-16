import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/app_loader.dart';

import '../constants/styles.dart';
import 'center_text.dart';

class CollectionQueryBuilder<T> extends StatelessWidget {
  const CollectionQueryBuilder(
      {super.key,
      required this.query,
      this.pageSize = 15,
      required this.builder});
  final Query<T> query;
  final int pageSize;
  final Widget Function(BuildContext, FirestoreQueryBuilderSnapshot<T>) builder;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder(
        query: query,
        builder: (context, snapshot, _) {
          return switch ((snapshot.isFetching, snapshot.hasError)) {
            (false, false) => builder(context, snapshot),
            (true, false) => AppLoader.circularProgress(),
            (false || true, true) => CenterText(
                text: snapshot.error.toString(),
                style: Styles.k20Bold(context),
              ),
          };
        });
  }
}
