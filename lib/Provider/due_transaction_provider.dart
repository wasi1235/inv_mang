import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/model/due_transaction_model.dart';
import 'package:mobile_pos/repository/transactions_repo.dart';

DueTransitionRepo dueTransitionRepo = DueTransitionRepo();
final dueTransactionProvider = FutureProvider<List<DueTransactionModel>>((ref) => dueTransitionRepo.getAllTransition());
