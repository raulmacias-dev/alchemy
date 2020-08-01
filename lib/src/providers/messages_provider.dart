import 'package:alchemy/src/repository/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:alchemy/src/repository/message_model.dart';

class MessagesProvider{
  
  User _user = GetIt.I.get<User>();
  String _groupChatId;
  String _idFrom;
  String _idTo;

  MessagesProvider();
  
  String get id => _idFrom;
  String get groupChatId => _groupChatId;

  void sendMessage(Message message ){
    
    _idFrom = message.idFrom ;
    _idTo = message.idTo;
    if (_idFrom.hashCode <= _idTo.hashCode) {
      _groupChatId = '$_idFrom-$_idTo';
    } else {
      _groupChatId = '$_idTo-$_idFrom';
    }
    var documentReference = Firestore.instance
    .collection('messages')
    .document(_groupChatId)
    .collection(_groupChatId)
    .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });

  }

}
