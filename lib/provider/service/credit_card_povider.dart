import 'package:domi/core/classes/paginated.dart';
import 'package:domi/models/wallet/card.dart';
import 'package:domi/repositories/wallet_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final creditCardProvider =
    StateNotifierProvider<CreditCardProvider, CreditCardState>(
        (ref) => CreditCardProvider(CreditCardState()));

class CreditCardProvider extends APIProvider<CreditCardState> {
  final repository = WalletRepository();

  CreditCardProvider(CreditCardState state) : super(state);

  getCards() async {
    if (isLoading) {
      return;
    }
    if (!hasMoreResults) {
      return;
    }

    toggleLoading();
    try {
      final newResults = await repository.getCreditCard(page: page);
      hasMoreResults = newResults.length >= pageSize;
      state.results.addAll(newResults);
      page++;
    } catch (e) {
      return Future.error(e);
    } finally {
      toggleLoading();
    }
  }
   void setCreditCard(Card card){
    state.results.add(card);
    state=state;
   }


   Future<void> deletedCreditCard(int cardId) async{
    try{
      await repository.deleteCreditCard(cardId);
      state.results.removeWhere((element) => element.id==cardId);
      state=state;
    }catch(e){

    }

   }
}

class CreditCardState {
  List<Card> results = [];
}
