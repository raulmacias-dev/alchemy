import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/bloc/game_bloc/game_bloc.dart';
import 'package:alchemy/src/ui/game/game_page.dart';
import 'package:alchemy/src/bloc/authentication_bloc/bloc.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/repository/user_repository.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  final String name;
  final UserRepository _userRepository;

  HomePage({Key key, @required this.name,@required UserRepository userRepository}) 
  : assert(userRepository != null),
    _userRepository = userRepository,
    super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  User _user = GetIt.I.get<User>();
  Signaling _signaling = GetIt.I.get<Signaling>();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget._userRepository.getAllUsers();
    _signaling.emit('login', _user.displayName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('4lchemy'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          )
        ],
      ),
      body: Stack(
          children: <Widget>[
            // List
            AnimatedBackground(
              behaviour: RandomParticleBehaviour(),
              vsync: this,
              child: Container(
                child: StreamBuilder(
                  stream: widget._userRepository.usersStream,
                  //Firestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.purple),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) => 
                        (snapshot.data.documents[index]['uid'] == _user.uid)
                            ? Container()
                            : Container(
                                margin: EdgeInsets.all(2),
                                padding: EdgeInsets.all(2),
                                child: FlatButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  padding: EdgeInsets.all(5),
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: <Widget>[
                                          CupertinoButton(
                                            onPressed: () {},
                                            padding: EdgeInsets.all(10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: Image.network(
                                                snapshot.data.documents[index]
                                                    ['photoUrl'],
                                                width: 40,
                                              ),
                                            ),
                                          ),
                                          snapshot.data.documents[index]
                                                  ['isActive']
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle),
                                                  padding: EdgeInsets.all(3),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.greenAccent,
                                                        shape: BoxShape.circle),
                                                    width: 25 / 2,
                                                    height: 25 / 2,
                                                  ),
                                                )
                                              : Container(
                                                  width: 0.0,
                                                  height: 0.0,
                                                ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data.documents[index]
                                                  ['displayName'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            snapshot.data.documents[index]['isActive']
                                            ?
                                            Image(
                                              image: AssetImage(
                                                  "assets/boton-de-play.png"),
                                              width: 50,
                                            )
                                            : Container(
                                                  width: 0.0,
                                                  height: 0.0,
                                                ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<GameBloc>(context).add(EWait());
                                    if(snapshot.data.documents[index]['isActive']){
                                      _signaling.emit('request',snapshot.data.documents[index]['displayName']);
                                    //Navigator.push(
                                    //    context,
                                    //    MaterialPageRoute(
                                    //        builder: (context) => Game()));
                                    }
                                  },
                                ),
                              ),
                        itemCount: snapshot.data.documents.length,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
    );
  }
}